/**
 * Saathi Sync API — v1
 *
 * POST  /v1/sync    — push local changes, pull remote changes
 * DELETE /v1/account — delete all data for this sync key
 *
 * Auth: Authorization: Bearer <sync-key>
 * The raw key is never stored; only its SHA-256 hash is kept in the DB.
 */

import { serve } from '@hono/node-server';
import { Hono } from 'hono';
import { createHash } from 'node:crypto';
import pg from 'pg';

// ── DB pool ────────────────────────────────────────────────────────────────
const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
  max: 10,
});

// ── Helpers ────────────────────────────────────────────────────────────────
const PAGE = 200; // max changes returned per call

/** SHA-256 hex of the raw sync key (never stored as-is). */
function keyHash(raw) {
  return createHash('sha256').update(raw).digest('hex');
}

/** Extract Bearer token from Authorization header, or null. */
function bearerToken(c) {
  const h = c.req.header('authorization') ?? '';
  const m = h.match(/^Bearer\s+(.+)$/i);
  return m ? m[1].trim() : null;
}

/** Validate key format: 43–128 URL-safe base64 chars. */
const KEY_RE = /^[A-Za-z0-9_-]{43,128}$/;

// ── App ────────────────────────────────────────────────────────────────────
const app = new Hono();

// Health check
app.get('/', (c) => c.json({ ok: true, service: 'saathi-sync', version: 1 }));

// ── POST /v1/sync ──────────────────────────────────────────────────────────
app.post('/v1/sync', async (c) => {
  const token = bearerToken(c);
  if (!token || !KEY_RE.test(token)) {
    return c.json({ error: { message: 'Missing or invalid sync key.' } }, 401);
  }
  const hash = keyHash(token);

  let body;
  try {
    body = await c.req.json();
  } catch {
    return c.json({ error: { message: 'Body must be JSON.' } }, 400);
  }

  const cursor = Number(body?.cursor ?? 0);
  const incoming = Array.isArray(body?.changes) ? body.changes : [];

  if (!Number.isInteger(cursor) || cursor < 0) {
    return c.json({ error: { message: 'cursor must be a non-negative integer.' } }, 400);
  }
  if (incoming.length > 500) {
    return c.json({ error: { message: 'Too many changes in one request (max 500).' } }, 400);
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    // 1. Upsert each incoming change (keep the newest updated_at)
    for (const ch of incoming) {
      const { date, prayer, done, updatedAt } = ch;
      if (
        typeof date !== 'string' ||
        typeof prayer !== 'string' ||
        typeof done !== 'boolean' ||
        typeof updatedAt !== 'string'
      ) continue; // skip malformed entries

      // Upsert prayer_states; only win if newer
      const upsert = await client.query(
        `INSERT INTO prayer_states (key_hash, date, prayer, done, updated_at)
         VALUES ($1, $2, $3, $4, $5::timestamptz)
         ON CONFLICT (key_hash, date, prayer)
         DO UPDATE SET
           done       = EXCLUDED.done,
           updated_at = EXCLUDED.updated_at
         WHERE EXCLUDED.updated_at > prayer_states.updated_at
         RETURNING 1`,
        [hash, date, prayer, done, updatedAt],
      );

      if (upsert.rowCount > 0) {
        // Accepted — append to log so other devices see it
        await client.query(
          `INSERT INTO sync_log (key_hash, date, prayer, done, updated_at)
           VALUES ($1, $2, $3, $4, $5::timestamptz)`,
          [hash, date, prayer, done, updatedAt],
        );
      }
    }

    // 2. Pull changes the client has not yet seen
    const pulled = await client.query(
      `SELECT id, date, prayer, done, updated_at
       FROM sync_log
       WHERE key_hash = $1 AND id > $2
       ORDER BY id
       LIMIT $3`,
      [hash, cursor, PAGE + 1],
    );

    await client.query('COMMIT');

    const hasMore = pulled.rows.length > PAGE;
    const rows = pulled.rows.slice(0, PAGE);
    const newCursor = rows.length > 0 ? Number(rows[rows.length - 1].id) : cursor;

    return c.json({
      serverTime: new Date().toISOString(),
      cursor: newCursor,
      hasMore,
      changes: rows.map((r) => ({
        date: r.date,
        prayer: r.prayer,
        done: r.done,
        updatedAt: r.updated_at.toISOString(),
      })),
    });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('sync error', err);
    return c.json({ error: { message: 'Internal server error.' } }, 500);
  } finally {
    client.release();
  }
});

// ── DELETE /v1/account ─────────────────────────────────────────────────────
app.delete('/v1/account', async (c) => {
  const token = bearerToken(c);
  if (!token || !KEY_RE.test(token)) {
    return c.json({ error: { message: 'Missing or invalid sync key.' } }, 401);
  }
  const hash = keyHash(token);
  await pool.query('DELETE FROM prayer_states WHERE key_hash = $1', [hash]);
  await pool.query('DELETE FROM sync_log WHERE key_hash = $1', [hash]);
  return c.body(null, 204);
});

// ── Start ──────────────────────────────────────────────────────────────────
const port = Number(process.env.PORT ?? 3000);
serve({ fetch: app.fetch, port }, () =>
  console.log(`Saathi sync API listening on :${port}`),
);

package com.ikramah.saathi.nativebridge

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject

/**
 * Durable inbox of transaction notifications. The listener service writes here
 * even when the Flutter engine is not running; Flutter reads with [peek] and
 * removes items with [ack] only after they are saved, so a kill or crash at
 * any point loses nothing.
 */
object CaptureQueue {
    private const val PREFS = "saathi_capture"
    private const val KEY_QUEUE = "queue"
    private const val KEY_CONNECTED = "connected"
    private const val KEY_LAST_CONNECTED = "last_connected_at"
    private const val KEY_LAST_CANDIDATE = "last_candidate_at"
    private const val MAX_ITEMS = 300
    private val lock = Any()

    private fun prefs(ctx: Context): SharedPreferences =
        ctx.applicationContext.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    private fun read(p: SharedPreferences): JSONArray =
        try { JSONArray(p.getString(KEY_QUEUE, "[]")) } catch (_: Exception) { JSONArray() }

    /** Returns false when an item with the same id is already waiting. */
    fun add(ctx: Context, id: String, pkg: String, title: String, body: String, time: Long): Boolean =
        synchronized(lock) {
            val p = prefs(ctx)
            val queue = read(p)
            for (i in 0 until queue.length()) {
                if (queue.optJSONObject(i)?.optString("id") == id) return false
            }
            queue.put(
                JSONObject()
                    .put("id", id)
                    .put("package", pkg)
                    .put("title", title)
                    .put("body", body)
                    .put("time", time)
            )
            val kept = if (queue.length() <= MAX_ITEMS) queue else JSONArray().also { out ->
                for (i in queue.length() - MAX_ITEMS until queue.length()) out.put(queue.get(i))
            }
            p.edit()
                .putString(KEY_QUEUE, kept.toString())
                .putLong(KEY_LAST_CANDIDATE, System.currentTimeMillis())
                .commit()
            true
        }

    fun peek(ctx: Context): List<Map<String, Any>> = synchronized(lock) {
        val queue = read(prefs(ctx))
        (0 until queue.length()).mapNotNull { i ->
            val o = queue.optJSONObject(i) ?: return@mapNotNull null
            mapOf(
                "id" to o.optString("id"),
                "package" to o.optString("package"),
                "title" to o.optString("title"),
                "body" to o.optString("body"),
                "time" to o.optLong("time"),
            )
        }
    }

    fun ack(ctx: Context, ids: Collection<String>) = synchronized(lock) {
        if (ids.isEmpty()) return@synchronized
        val p = prefs(ctx)
        val queue = read(p)
        val remaining = JSONArray()
        for (i in 0 until queue.length()) {
            val o = queue.optJSONObject(i) ?: continue
            if (o.optString("id") !in ids) remaining.put(o)
        }
        p.edit().putString(KEY_QUEUE, remaining.toString()).commit()
    }

    fun setConnected(ctx: Context, connected: Boolean) {
        val edit = prefs(ctx).edit().putBoolean(KEY_CONNECTED, connected)
        if (connected) edit.putLong(KEY_LAST_CONNECTED, System.currentTimeMillis())
        edit.commit()
    }

    fun health(ctx: Context): Map<String, Any> {
        val p = prefs(ctx)
        return mapOf(
            "connected" to p.getBoolean(KEY_CONNECTED, false),
            "lastConnectedAt" to p.getLong(KEY_LAST_CONNECTED, 0L),
            "lastCandidateAt" to p.getLong(KEY_LAST_CANDIDATE, 0L),
            "pending" to read(p).length(),
        )
    }
}

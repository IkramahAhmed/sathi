package com.ikramah.saathi.nativebridge

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import org.json.JSONArray

/**
 * Silences the phone during the windows the app sends (jama'at) and puts it back after.
 *
 * Rules that keep it safe:
 *  - it only acts with Do Not Disturb access;
 *  - a phone already in Do Not Disturb is left alone, and never "restored";
 *  - at the end it only restores a state it set itself, and only if that state is still in place.
 */
object SilentController {
    data class Window(val start: Long, val end: Long)

    private const val PREFS = "saathi_native"
    private const val KEY_WINDOWS = "silent_windows"
    private const val KEY_CHANGED = "silent_changed"
    private const val BASE_CODE = 7000
    private const val MAX_WINDOWS = 20
    private const val SLACK_MS = 2000L
    const val ACTION_TICK = "com.ikramah.saathi.nativebridge.SILENT_TICK"

    private fun prefs(c: Context) = c.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun hasAccess(c: Context): Boolean =
        (c.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).isNotificationPolicyAccessGranted

    fun load(c: Context): List<Window> {
        val raw = prefs(c).getString(KEY_WINDOWS, null) ?: return emptyList()
        return try {
            val arr = JSONArray(raw)
            (0 until arr.length()).map { i ->
                val pair = arr.getJSONArray(i)
                Window(pair.getLong(0), pair.getLong(1))
            }
        } catch (e: Exception) {
            emptyList()
        }
    }

    /** Replaces the plan: store it, arm the alarms and bring the phone in line with it. */
    fun apply(c: Context, windows: List<Window>) {
        val kept = windows.take(MAX_WINDOWS)
        val arr = JSONArray()
        kept.forEach { arr.put(JSONArray().put(it.start).put(it.end)) }
        prefs(c).edit().putString(KEY_WINDOWS, arr.toString()).apply()
        arm(c)
        reconcile(c)
    }

    /** Sets one exact alarm per start and end that is still ahead. */
    fun arm(c: Context) {
        val am = c.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        for (i in 0 until MAX_WINDOWS * 2) am.cancel(pending(c, BASE_CODE + i))
        val now = System.currentTimeMillis()
        load(c).forEachIndexed { index, w ->
            if (w.start > now) schedule(c, am, w.start, BASE_CODE + index * 2)
            if (w.end > now) schedule(c, am, w.end, BASE_CODE + index * 2 + 1)
        }
    }

    private fun pending(c: Context, code: Int): PendingIntent =
        PendingIntent.getBroadcast(
            c, code,
            Intent(c, SilentReceiver::class.java).setAction(ACTION_TICK),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

    private fun schedule(c: Context, am: AlarmManager, at: Long, code: Int) {
        val intent = pending(c, code)
        val exact = android.os.Build.VERSION.SDK_INT < 31 || am.canScheduleExactAlarms()
        if (exact) am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, intent)
        else am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, intent)
    }

    /** Makes the phone's state match the plan for this moment. */
    fun reconcile(c: Context) {
        if (!hasAccess(c)) return
        val nm = c.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val now = System.currentTimeMillis() + SLACK_MS
        val inside = load(c).any { now >= it.start && now < it.end }
        val changed = prefs(c).getBoolean(KEY_CHANGED, false)
        val filter = nm.currentInterruptionFilter

        if (inside) {
            if (!changed && filter == NotificationManager.INTERRUPTION_FILTER_ALL) {
                nm.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALARMS)
                prefs(c).edit().putBoolean(KEY_CHANGED, true).apply()
            }
        } else if (changed) {
            if (filter == NotificationManager.INTERRUPTION_FILTER_ALARMS) {
                nm.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
            }
            prefs(c).edit().putBoolean(KEY_CHANGED, false).apply()
        }
    }
}

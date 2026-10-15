package com.ikramah.saathi.nativebridge

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.SystemClock
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject

/**
 * Shows the next prayer with a countdown the system draws by itself, so the widget
 * needs no per-second updates. It redraws once at each prayer time.
 */
class PrayerWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        render(context, manager, ids)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH) refresh(context)
    }

    companion object {
        private const val ACTION_REFRESH = "com.ikramah.saathi.nativebridge.WIDGET_REFRESH"
        private const val REQUEST_CODE = 7900

        /** Redraws every placed widget. */
        fun refresh(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, PrayerWidgetProvider::class.java))
            if (ids.isNotEmpty()) render(context, manager, ids)
        }

        private fun render(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val data = try { WidgetStore.load(context)?.let { JSONObject(it) } } catch (e: Exception) { null }
            val entries = data?.optJSONArray("entries")
            val now = System.currentTimeMillis()

            var nextIndex = -1
            if (entries != null) {
                for (i in 0 until entries.length()) {
                    if (entries.getJSONObject(i).getLong("at") > now) { nextIndex = i; break }
                }
            }

            val open = PendingIntent.getActivity(
                context, 0,
                context.packageManager.getLaunchIntentForPackage(context.packageName),
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            for (id in ids) {
                val views = RemoteViews(context.packageName, R.layout.saathi_widget)
                views.setOnClickPendingIntent(R.id.saathi_widget_root, open)
                if (entries == null || nextIndex < 0) {
                    views.setTextViewText(R.id.saathi_widget_title, context.getString(R.string.saathi_widget_empty))
                    views.setTextViewText(R.id.saathi_widget_name, "")
                    views.setTextViewText(R.id.saathi_widget_time, "")
                    views.setViewVisibility(R.id.saathi_widget_countdown, View.GONE)
                    views.setTextViewText(R.id.saathi_widget_later, "")
                } else {
                    val next = entries.getJSONObject(nextIndex)
                    val city = data?.optString("city").orEmpty()
                    val title = data?.optString("nextLabel").orEmpty()
                    views.setTextViewText(R.id.saathi_widget_title, if (city.isEmpty()) title else "$title · $city")
                    views.setTextViewText(R.id.saathi_widget_name, next.getString("label"))
                    views.setTextViewText(R.id.saathi_widget_time, next.getString("timeText"))
                    views.setViewVisibility(R.id.saathi_widget_countdown, View.VISIBLE)
                    val base = SystemClock.elapsedRealtime() + (next.getLong("at") - now)
                    views.setChronometerCountDown(R.id.saathi_widget_countdown, true)
                    views.setChronometer(R.id.saathi_widget_countdown, base, null, true)

                    val later = StringBuilder()
                    for (i in nextIndex + 1 until minOf(entries.length(), nextIndex + 3)) {
                        val e = entries.getJSONObject(i)
                        if (later.isNotEmpty()) later.append("   ")
                        later.append(e.getString("label")).append(' ').append(e.getString("timeText"))
                    }
                    views.setTextViewText(R.id.saathi_widget_later, later.toString())
                }
                manager.updateAppWidget(id, views)
            }

            scheduleRefresh(context, if (nextIndex >= 0) entries!!.getJSONObject(nextIndex).getLong("at") else null)
        }

        /** Redraw just after the current "next prayer" passes, so the widget moves on by itself. */
        private fun scheduleRefresh(context: Context, at: Long?) {
            val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = PendingIntent.getBroadcast(
                context, REQUEST_CODE,
                Intent(context, PrayerWidgetProvider::class.java).setAction(ACTION_REFRESH),
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
            am.cancel(intent)
            if (at != null) am.setAndAllowWhileIdle(AlarmManager.RTC, at + 1500, intent)
        }
    }
}

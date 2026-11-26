package com.ikramah.saathi.nativebridge

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import org.json.JSONObject
import android.widget.RemoteViews

/**
 * Lists the next five prayers with their times. It reads the same data as the
 * countdown widget and is redrawn together with it.
 */
class PrayerTimesWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        render(context, manager, ids)
        PrayerWidgetProvider.scheduleNext(context)
    }

    companion object {
        private val NAME_IDS = intArrayOf(
            R.id.saathi_times_name_1, R.id.saathi_times_name_2, R.id.saathi_times_name_3,
            R.id.saathi_times_name_4, R.id.saathi_times_name_5
        )
        private val TIME_IDS = intArrayOf(
            R.id.saathi_times_time_1, R.id.saathi_times_time_2, R.id.saathi_times_time_3,
            R.id.saathi_times_time_4, R.id.saathi_times_time_5
        )

        /** Redraws every placed copy of this widget. */
        fun refresh(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, PrayerTimesWidgetProvider::class.java))
            if (ids.isNotEmpty()) render(context, manager, ids)
        }

        private fun render(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val data = try { WidgetStore.load(context)?.let { JSONObject(it) } } catch (e: Exception) { null }
            val entries = data?.optJSONArray("entries")
            val now = System.currentTimeMillis()

            var first = -1
            if (entries != null) {
                for (i in 0 until entries.length()) {
                    if (entries.getJSONObject(i).getLong("at") > now) { first = i; break }
                }
            }

            val open = PendingIntent.getActivity(
                context, 1,
                context.packageManager.getLaunchIntentForPackage(context.packageName),
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            for (id in ids) {
                val views = RemoteViews(context.packageName, R.layout.saathi_times_widget)
                views.setOnClickPendingIntent(R.id.saathi_times_root, open)
                val city = data?.optString("city").orEmpty()
                views.setTextViewText(
                    R.id.saathi_times_title,
                    if (first < 0 || entries == null) context.getString(R.string.saathi_widget_empty) else city
                )
                for (row in NAME_IDS.indices) {
                    val index = first + row
                    if (first >= 0 && entries != null && index < entries.length()) {
                        val e = entries.getJSONObject(index)
                        views.setTextViewText(NAME_IDS[row], e.getString("label"))
                        views.setTextViewText(TIME_IDS[row], e.getString("timeText"))
                    } else {
                        views.setTextViewText(NAME_IDS[row], "")
                        views.setTextViewText(TIME_IDS[row], "")
                    }
                }
                manager.updateAppWidget(id, views)
            }
        }
    }
}

package com.ikramah.saathi.nativebridge

import android.content.Context

/** The JSON the app last sent for the widget. */
object WidgetStore {
    private const val PREFS = "saathi_native"
    private const val KEY = "widget_data"

    fun save(c: Context, json: String) =
        c.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().putString(KEY, json).apply()

    fun load(c: Context): String? = c.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getString(KEY, null)
}

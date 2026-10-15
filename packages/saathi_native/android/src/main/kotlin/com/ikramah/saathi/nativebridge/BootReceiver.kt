package com.ikramah.saathi.nativebridge

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** After a reboot, or when the clock or time zone changes, put everything back in place. */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        SilentController.arm(context)
        SilentController.reconcile(context)
        PrayerWidgetProvider.refresh(context)
    }
}

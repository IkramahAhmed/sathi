package com.ikramah.saathi.nativebridge

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** Fires at the start and end of each silent window. */
class SilentReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        SilentController.reconcile(context)
        // Chain: this also re-arms anything the system dropped.
        SilentController.arm(context)
    }
}

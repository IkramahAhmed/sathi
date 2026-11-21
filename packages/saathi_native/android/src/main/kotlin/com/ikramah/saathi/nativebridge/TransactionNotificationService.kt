package com.ikramah.saathi.nativebridge

import android.app.Notification
import android.content.Intent
import android.os.Bundle
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

/**
 * Listens for all incoming notifications and forwards bank transaction ones
 * to Flutter via a broadcast. Flutter picks these up through the native channel.
 */
class TransactionNotificationService : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val pkg = sbn.packageName ?: return
        val extras: Bundle = sbn.notification?.extras ?: return

        val title = extras.getString(Notification.EXTRA_TITLE) ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString() ?: ""
        val body = if (bigText.isNotEmpty()) bigText else text

        Log.d(TAG, "onNotificationPosted: pkg=$pkg title=$title body=$body")

        if (!isBankNotification(pkg, title, body)) return

        Log.d(TAG, "Bank notification matched! Sending broadcast.")

        val intent = Intent(ACTION_TRANSACTION_NOTIFICATION).apply {
            setPackage(packageName)   // explicit: required by Android 8+ for dynamic receivers
            putExtra("package", pkg)
            putExtra("title", title)
            putExtra("body", body)
            putExtra("time", sbn.postTime)
        }
        sendBroadcast(intent)
    }

    private fun isBankNotification(pkg: String, title: String, body: String): Boolean {
        // Known Pakistani bank/wallet app package names
        val bankPackages = setOf(
            "com.hbl.android",           // HBL Mobile
            "com.meezan.internetbanking", // Meezan Internet Banking (old)
            "invo8.meezan.mb",            // Meezan Mobile Banking (current)
            "com.ubl.ubldirectapp",       // UBL Digital
            "com.mcb.android",            // MCB Mobile
            "com.alfalahbankapp",         // Bank Alfalah
            "com.jazzcash.android",       // JazzCash
            "com.easypaisa.app",          // EasyPaisa
            "com.sadapay.app",            // SadaPay
            "com.nayapay.app",             // NayaPay
            "com.dibpak.android",         // DIB Pakistan
            "com.askaribank.android",     // Askari Bank
            "com.jsbl.android",           // JS Bank
            "com.faysalbank.android",     // Faysal Bank
            "com.bankalhabib.android",    // Bank Al Habib
            "com.scb.android",            // Standard Chartered
            "com.tmb.android",            // TMB
            "com.abl.android",            // Allied Bank
        )
        if (pkg in bankPackages) return true

        // Fallback: keyword match for any notification
        val combined = "$title $body".lowercase()
        val txKeywords = listOf(
            "debited", "credited", "transferred", "withdrawn", "deposited",
            "rs.", "pkr", "payment received", "payment sent",
            "transaction", "debit", "credit", "balance",
        )
        return txKeywords.any { combined.contains(it) }
    }

    companion object {
        const val ACTION_TRANSACTION_NOTIFICATION =
            "com.ikramah.saathi.TRANSACTION_NOTIFICATION"
        private const val TAG = "SaathiTxCapture"
    }
}

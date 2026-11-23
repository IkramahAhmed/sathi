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
        // Saathi's own "transaction saved" / budget / udhaar alerts contain amounts too.
        if (pkg == packageName) return
        val notification = sbn.notification ?: return
        // Grouped notifications repeat the child's text in a summary; capture the child only.
        if (notification.flags and Notification.FLAG_GROUP_SUMMARY != 0) return
        val extras: Bundle = notification.extras ?: return

        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString() ?: ""
        val body = if (bigText.isNotEmpty()) bigText else text

        if (!isBankNotification(pkg, title, body)) return

        // Never log notification text: it contains private messages, OTPs and balances.
        Log.d(TAG, "Transaction candidate from $pkg")

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
            "com.dibpak.android",         // DIB Pakistan (old)
            "com.avanza.ambitwizdib",     // DIB Pakistan (current)
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

package com.ikramah.saathi.nativebridge

import android.app.Notification
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

/**
 * Writes every bank-transaction notification to [CaptureQueue], then pings
 * Flutter. The queue survives the app being swiped away or killed, so a
 * transaction is never lost just because Saathi was not open.
 */
class TransactionNotificationService : NotificationListenerService() {

    override fun onListenerConnected() {
        CaptureQueue.setConnected(this, true)
        // Catch up on anything that arrived while we were unbound (reboot, kill, app update).
        val added = try {
            activeNotifications?.count { capture(it) } ?: 0
        } catch (e: Exception) {
            Log.w(TAG, "Catch-up failed", e)
            0
        }
        Log.d(TAG, "Listener connected, caught up $added")
        if (added > 0) pingFlutter()
    }

    override fun onListenerDisconnected() {
        CaptureQueue.setConnected(this, false)
        requestRebind(ComponentName(this, TransactionNotificationService::class.java))
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        if (capture(sbn)) pingFlutter()
    }

    /** Returns true when at least one new item was queued. */
    private fun capture(sbn: StatusBarNotification): Boolean {
        val pkg = sbn.packageName ?: return false
        // Saathi's own "transaction saved" / budget / udhaar alerts contain amounts too.
        if (pkg == packageName || pkg in IGNORED_PACKAGES) return false
        val notification = sbn.notification ?: return false
        // Grouped notifications repeat the child's text in a summary; capture the child only.
        if (notification.flags and Notification.FLAG_GROUP_SUMMARY != 0) return false
        val extras: Bundle = notification.extras ?: return false

        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""

        // SMS apps stack several messages from one sender into one notification;
        // each message is its own transaction.
        val messages = messagesOf(extras)
        if (messages.isNotEmpty()) {
            var added = false
            for ((text, time) in messages) {
                if (!isBankNotification(pkg, title, text)) continue
                val id = "${pkg}_${time}_${text.hashCode()}"
                if (CaptureQueue.add(this, id, pkg, title, text, time)) added = true
            }
            if (added) Log.d(TAG, "Transaction candidate from $pkg")
            return added
        }

        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString() ?: ""
        val body = if (bigText.isNotEmpty()) bigText else text
        if (!isBankNotification(pkg, title, body)) return false

        // Never log notification text: it contains private messages, OTPs and balances.
        Log.d(TAG, "Transaction candidate from $pkg")
        return CaptureQueue.add(this, "${pkg}_${sbn.postTime}", pkg, title, body, sbn.postTime)
    }

    @Suppress("DEPRECATION")
    private fun messagesOf(extras: Bundle): List<Pair<String, Long>> {
        val raw = extras.getParcelableArray(Notification.EXTRA_MESSAGES) ?: return emptyList()
        return raw.mapNotNull { p ->
            val b = p as? Bundle ?: return@mapNotNull null
            val text = b.getCharSequence("text")?.toString() ?: return@mapNotNull null
            text to b.getLong("time")
        }
    }

    private fun pingFlutter() {
        sendBroadcast(Intent(ACTION_TRANSACTION_NOTIFICATION).setPackage(packageName))
    }

    private fun isBankNotification(pkg: String, title: String, body: String): Boolean {
        if (pkg in BANK_PACKAGES) return true
        // Fallback for SMS apps and unknown wallets; Flutter's parser filters further.
        val combined = "$title $body".lowercase()
        return AMOUNT_RE.containsMatchIn(combined) || TX_KEYWORDS.any { combined.contains(it) }
    }

    companion object {
        const val ACTION_TRANSACTION_NOTIFICATION = "com.ikramah.saathi.TRANSACTION_NOTIFICATION"
        private const val TAG = "SaathiTxCapture"

        private val BANK_PACKAGES = setOf(
            "com.hbl.android",
            "com.meezan.internetbanking",
            "invo8.meezan.mb",
            "com.ubl.ubldirectapp",
            "com.mcb.android",
            "com.alfalahbankapp",
            "com.jazzcash.android",
            "com.easypaisa.app",
            "com.sadapay.app",
            "com.nayapay.app",
            "com.dibpak.android",
            "com.avanza.ambitwizdib",
            "com.askaribank.android",
            "com.jsbl.android",
            "com.faysalbank.android",
            "com.bankalhabib.android",
            "com.scb.android",
            "com.tmb.android",
            "com.abl.android",
        )

        // Chat and debt-tracking apps: amounts there are conversation, not money movement.
        // Kept out of the queue so private chats are never stored.
        private val IGNORED_PACKAGES = setOf(
            "com.whatsapp",
            "com.whatsapp.w4b",
            "org.telegram.messenger",
            "com.facebook.orca",
            "com.facebook.katana",
            "com.instagram.android",
            "com.snapchat.android",
            "com.Splitwise.SplitwiseMobile",
        )

        // "Rs 500", "PKR5,000", "2500/-" — a currency amount, not just the letters "rs".
        private val AMOUNT_RE = Regex("""\b(?:rs\.?|pkr)\s*\d|\d\s*/-""")
        private val TX_KEYWORDS = listOf(
            "debited", "credited", "transferred", "withdrawn", "deposited",
            "payment received", "payment sent",
        )

        /** Asks Android to reconnect the listener if it was dropped (e.g. after an update). */
        fun rebind(ctx: Context) {
            requestRebind(ComponentName(ctx, TransactionNotificationService::class.java))
        }
    }
}

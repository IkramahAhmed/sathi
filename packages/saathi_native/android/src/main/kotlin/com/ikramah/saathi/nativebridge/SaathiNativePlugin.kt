package com.ikramah.saathi.nativebridge

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.GeomagneticField
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

/** The `com.ikramah.saathi/native` channel. Also registered in the background isolate. */
class SaathiNativePlugin : FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private var channel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var notificationReceiver: BroadcastReceiver? = null
    private var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL).also { it.setMethodCallHandler(this) }
        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL).also { it.setStreamHandler(this) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        context = null
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        android.util.Log.d("SaathiNative", "onListen called — registering broadcast receiver")
        val ctx = context ?: return
        eventSink = sink
        val receiver = object : BroadcastReceiver() {
            // Just a wake-up: the data itself is read from CaptureQueue.
            override fun onReceive(context: Context?, intent: Intent?) {
                sink?.success(true)
            }
        }
        val filter = IntentFilter(TransactionNotificationService.ACTION_TRANSACTION_NOTIFICATION)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ctx.registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            ctx.registerReceiver(receiver, filter)
        }
        notificationReceiver = receiver
        android.util.Log.d("SaathiNative", "BroadcastReceiver registered OK")
    }

    override fun onCancel(arguments: Any?) {
        context?.let { ctx ->
            notificationReceiver?.let { ctx.unregisterReceiver(it) }
        }
        notificationReceiver = null
        eventSink = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val ctx = context ?: return result.error("no_context", "Plugin is detached", null)
        try {
            when (call.method) {
                "silentAccess" -> result.success(SilentController.hasAccess(ctx))
                "openSilentAccessSettings" -> {
                    val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    ctx.startActivity(intent)
                    result.success(null)
                }
                "setSilentWindows" -> {
                    val raw = call.argument<List<Map<String, Any>>>("windows") ?: emptyList()
                    val windows = raw.map {
                        SilentController.Window((it["start"] as Number).toLong(), (it["end"] as Number).toLong())
                    }
                    SilentController.apply(ctx, windows)
                    result.success(null)
                }
                "setWidgetData" -> {
                    val entries = JSONArray()
                    for (e in call.argument<List<Map<String, Any>>>("entries") ?: emptyList()) {
                        entries.put(
                            JSONObject()
                                .put("label", e["label"] as String)
                                .put("at", (e["at"] as Number).toLong())
                                .put("timeText", e["timeText"] as String)
                        )
                    }
                    val data = JSONObject()
                        .put("city", call.argument<String>("city") ?: "")
                        .put("nextLabel", call.argument<String>("nextLabel") ?: "")
                        .put("entries", entries)
                    WidgetStore.save(ctx, data.toString())
                    PrayerWidgetProvider.refresh(ctx)
                    result.success(null)
                }
                "declination" -> {
                    val lat = (call.argument<Number>("lat") ?: 0).toFloat()
                    val lng = (call.argument<Number>("lng") ?: 0).toFloat()
                    // Android's built-in World Magnetic Model, accurate to about a degree.
                    val field = GeomagneticField(lat, lng, 0f, System.currentTimeMillis())
                    result.success(field.declination.toDouble())
                }
                "hasNotificationAccess" -> {
                    val enabled = Settings.Secure.getString(
                        ctx.contentResolver,
                        "enabled_notification_listeners"
                    ) ?: ""
                    result.success(enabled.contains(ctx.packageName))
                }
                "peekCaptureQueue" -> result.success(CaptureQueue.peek(ctx))
                "ackCaptureQueue" -> {
                    CaptureQueue.ack(ctx, call.argument<List<String>>("ids") ?: emptyList())
                    result.success(null)
                }
                "captureHealth" -> result.success(CaptureQueue.health(ctx))
                "rebindCaptureListener" -> {
                    TransactionNotificationService.rebind(ctx)
                    result.success(null)
                }
                "openNotificationAccessSettings" -> {
                    val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    ctx.startActivity(intent)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("native_error", e.message, null)
        }
    }

    companion object {
        const val CHANNEL = "com.ikramah.saathi/native"
        const val EVENT_CHANNEL = "com.ikramah.saathi/notifications"
    }
}

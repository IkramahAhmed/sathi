package com.ikramah.saathi.nativebridge

import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

/** The `com.ikramah.saathi/native` channel. Also registered in the background isolate. */
class SaathiNativePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private var channel: MethodChannel? = null
    private var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL).also { it.setMethodCallHandler(this) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        context = null
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
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("native_error", e.message, null)
        }
    }

    companion object {
        const val CHANNEL = "com.ikramah.saathi/native"
    }
}

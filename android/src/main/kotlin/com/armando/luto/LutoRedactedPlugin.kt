package com.armando.luto

import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class LutoRedactedPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var activityBinding: ActivityPluginBinding? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "com.armando.luto/secure")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    val activity = activityBinding?.activity
    if (activity == null) {
      result.error("NO_ACTIVITY", "Activity null", null)
      return
    }
    when (call.method) {
      "enableSecure" -> {
        activity.runOnUiThread {
          activity.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
        result.success(null)
      }
      "disableSecure" -> {
        activity.runOnUiThread {
          activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
        result.success(null)
      }
      
      "toggleSecure" -> {
        activity.runOnUiThread {
          val window = activity.window
          val hasSecure = (window.attributes.flags and WindowManager.LayoutParams.FLAG_SECURE) != 0
          
          if (hasSecure) {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
          } else {
            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
          }
        }
        result.success(null)
      }




      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) { activityBinding = binding }
  override fun onDetachedFromActivityForConfigChanges() { activityBinding = null }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { activityBinding = binding }
  override fun onDetachedFromActivity() { activityBinding = null }
}
package com.example.protected_screen

import android.app.Activity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import android.view.WindowManager.LayoutParams;
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.os.Build
import android.util.Log
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.LifecycleEventObserver
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference


/** ScreenProtectorPlugin */
class ProtectedScreenPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: Activity? = null
    // private var higherThanAndroid12 : Boolean = true
    private lateinit var channel: MethodChannel

    // determines if the app should go into secure mode on ON_PAUSE Lifecycle event 
    private var protectOnPause = false

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "protected_screen")
        channel.setMethodCallHandler(this)
        // higherThanAndroid12 = Build.VERSION.SDK_INT >= Build.VERSION_CODES.R
    }

    // private fun view(): ViewGroup? = activity?.findViewById(android.R.id.content)

    // private fun visible() {
    //     view()?.visibility = View.VISIBLE
    // }

    // private fun invisible() {
    //     view()?.visibility = View.INVISIBLE
    // }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) =
        when (call.method) {
            "addProtectionForPause" -> {
                protectOnPause = true
                result.success(true)
            }
            "removeProtectionForPause" -> {
              protectOnPause = false
              result.success(true)
            }
            else -> result.success(false)
        }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        (binding.lifecycle as HiddenLifecycleReference)
        .lifecycle
        .addObserver(LifecycleEventObserver { source, event ->
            Log.e("Activity state: ", event.toString())
            when (event.toString()) {
                "ON_PAUSE", "ON_STOP" -> {
                    if (protectOnPause) activity?.window?.addFlags(LayoutParams.FLAG_SECURE)
                }
                "ON_START", "ON_RESUME" -> {
                    activity?.window?.clearFlags(LayoutParams.FLAG_SECURE)
                }
            }
        })
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity

    }

    override fun onDetachedFromActivity() {
    }
}
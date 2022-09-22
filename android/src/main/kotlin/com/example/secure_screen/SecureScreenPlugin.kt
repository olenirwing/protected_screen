package com.example.secure_screen

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.app.Activity
import android.view.WindowManager.LayoutParams;
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


// import android.util.Log
// import androidx.annotation.NonNull;
// import io.flutter.embedding.engine.plugins.FlutterPlugin
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler
// import io.flutter.plugin.common.MethodChannel.Result
// import io.flutter.plugin.common.PluginRegistry.Registrar
// import androidx.lifecycle.Lifecycle
// import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
// import androidx.lifecycle.LifecycleObserver
// import androidx.lifecycle.OnLifecycleEvent


class SecureScreenPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  lateinit var instance: SwiftSecureScreenPlugin

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "secure_screen")
    channel.setMethodCallHandler(this)
    instance = SecureScreenPlugin()
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "secure") {
      activity?.window?.addFlags(LayoutParams.FLAG_SECURE)
      result.success(true)
    } else if (call.method == "unsecure") {
      activity?.window?.clearFlags(LayoutParams.FLAG_SECURE)
        result.success(true)
    } else {
      result.success(true)
    }
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    if (::instance.isInitialized)
      instance.activity = binding.activity
    else
      this.activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    // not used for now but might be used to add some features in the future
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // not used for now but might be used to add some features in the future
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    if (::instance.isInitialized)
      instance.activity = binding.activity
    else
      this.activity = binding.activity
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}


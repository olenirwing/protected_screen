// package com.example.protected_screen

// import androidx.annotation.NonNull

// import io.flutter.embedding.engine.plugins.FlutterPlugin
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler
// import io.flutter.plugin.common.MethodChannel.Result
// import android.app.Activity
// import android.view.WindowManager.LayoutParams;
// import io.flutter.Log
// import io.flutter.embedding.engine.plugins.activity.ActivityAware
// import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


// // import android.util.Log
// // import androidx.annotation.NonNull;
// // import io.flutter.embedding.engine.plugins.FlutterPlugin
// // import io.flutter.plugin.common.MethodCall
// // import io.flutter.plugin.common.MethodChannel
// // import io.flutter.plugin.common.MethodChannel.MethodCallHandler
// // import io.flutter.plugin.common.MethodChannel.Result
// // import io.flutter.plugin.common.PluginRegistry.Registrar
// // import androidx.lifecycle.Lifecycle
// // import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
// // import androidx.lifecycle.LifecycleObserver
// // import androidx.lifecycle.OnLifecycleEvent


// class ProtectedScreenPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
//   /// The MethodChannel that will the communication between Flutter and native Android
//   ///
//   /// This local reference serves to register the plugin with the Flutter Engine and unregister it
//   /// when the Flutter Engine is detached from the Activity
//   private lateinit var channel : MethodChannel
//   private var activity: Activity? = null
//   lateinit var instance: ProtectedScreenPlugin

//   override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//     channel = MethodChannel(flutterPluginBinding.binaryMessenger, "protected_screen")
//     channel.setMethodCallHandler(this)
//     instance = ProtectedScreenPlugin()
//   }

//   override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
//     Log.d("call", "method call")
//     if (call.method == "addProtection") {
//       Log.d("call", "addProtection")

//       activity?.window?.addFlags(LayoutParams.FLAG_SECURE)
//       result.success(true)
//     } else if (call.method == "removeProtection") {
//       activity?.window?.clearFlags(LayoutParams.FLAG_SECURE)
//         result.success(true)
//     } else {
//       result.success(true)
//     }
//   }


//   override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//       this.activity = binding.activity
//   }

  

//   override fun onDetachedFromActivity() {
//     // not used for now but might be used to add some features in the future
//   }

//   override fun onDetachedFromActivityForConfigChanges() {
//     // not used for now but might be used to add some features in the future
//   }

//   override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//     // if (::instance.isInitialized)
//     //   instance.activity = binding.activity
//     // else
//       this.activity = binding.activity
//   }

//   override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
//     channel.setMethodCallHandler(null)
//   }
// }




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
import android.view.View
import android.view.ViewGroup


/** ScreenProtectorPlugin */
class ProtectedScreenPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: Activity? = null

    private var higherThanAndroid12 : Boolean = true
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "protected_screen")
        channel.setMethodCallHandler(this)
        higherThanAndroid12 = Build.VERSION.SDK_INT >= Build.VERSION_CODES.R
    }

    private fun view(): ViewGroup? = activity?.findViewById(android.R.id.content)

    private fun visible() {
        view()?.visibility = View.VISIBLE
    }

    private fun invisible() {
        view()?.visibility = View.INVISIBLE
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) =
        when (call.method) {
            "addProtection" -> {
                if (higherThanAndroid12) invisible()
                activity?.window?.addFlags(LayoutParams.FLAG_SECURE)
                result.success(true)
            }
            "removeProtection" -> {
              if (higherThanAndroid12) visible()
              activity?.window?.clearFlags(LayoutParams.FLAG_SECURE)
              result.success(true)
            }
            else -> result.success(false)
        }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity

    }

    override fun onDetachedFromActivity() {
    }
}
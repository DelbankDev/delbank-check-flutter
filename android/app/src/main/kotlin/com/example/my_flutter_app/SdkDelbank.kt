package com.example.my_flutter_app

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Parcelable
import android.util.Log
import br.com.delbank.otpsdk.android.FastValidade
import br.com.delbank.otpsdk.android.models.ErrorModel
import br.com.delbank.otpsdk.android.models.SucessModel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener

class SdkDelbank : FlutterPlugin, MethodCallHandler, ActivityAware,
   ActivityResultListener {
    private var channel: MethodChannel? = null
    private var result: MethodChannel.Result? = null
    private var activity: Activity? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var context: Context? = null


    @Synchronized
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        if (call.method == CALL_METHOD) {
            this.result = result
            start(call)
        } else {
            result.notImplemented()
            this.result = null
        }
    }
    @Synchronized
    private fun start(call: MethodCall) {
        val argumentsMap = call.arguments as HashMap<*, *>
        val intent = Intent(context, FastValidade::class.java)
        activity?.startActivityForResult(intent, REQUEST_CODE)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME)
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        context = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        activityBinding?.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
    }

    @Synchronized
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_CODE && data != null) {

            if (resultCode == Activity.RESULT_OK && data != null) {
                val resultModel: SucessModel? =
                    data.getSerializableExtra(FIELD_NAME_RESULT_SUCCESS_OBJECT) as SucessModel?
                    if (resultModel != null) {
                        val parameter: MutableMap<String, Any> = java.util.HashMap()
                        parameter[FIELD_NAME_RESULT_SUCCESS_ID] = resultModel.authorizationId
                        result?.success(parameter)
                    }
            } else {
                val parameter: MutableMap<String, Any> = java.util.HashMap()
                val error: ErrorModel? =
                    data.getSerializableExtra(FIELD_NAME_RESULT_ERROR_OBJECT) as ErrorModel?
                if (error != null) {
                    parameter[FIELD_NAME_RESULT_ID] = error.id
                    parameter[FIELD_NAME_RESULT_ERROR_CODE] = error.code
                    parameter[FIELD_NAME_RESULT_ERROR_DESCRIPTION] = error.description
                    result?.error(error.code, error.description, parameter)
                } else {
                    parameter[FIELD_NAME_RESULT_ID] = ""
                    parameter[FIELD_NAME_RESULT_ERROR_CODE] = "-1"
                    parameter[FIELD_NAME_RESULT_ERROR_DESCRIPTION] = "Platform Error"
                    result?.error("-1", "Platform Error", parameter)
                }
            }
        }
        return false
    }
    
    companion object {
        private const val REQUEST_CODE = 1001
        private const val CHANNEL_NAME = "delbank.sdk/antiCheat"
        private const val CALL_METHOD = "startCheck"
        private  const val FIELD_NAME_RESULT_SUCCESS_OBJECT= "auth"
        private const val FIELD_NAME_RESULT_ERROR_OBJECT = "error"
        private const val FIELD_NAME_RESULT_SUCCESS_ID = "authorizationId"
        private const val FIELD_NAME_RESULT_ID = "id"
        private const val FIELD_NAME_RESULT_ERROR_CODE = "code"
        private const val FIELD_NAME_RESULT_ERROR_DESCRIPTION = "description"

    }
}
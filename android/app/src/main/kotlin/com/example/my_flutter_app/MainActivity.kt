package com.example.my_flutter_app

import io.flutter.embedding.android.FlutterActivity
import android.app.Activity.RESULT_CANCELED

import android.app.Activity.RESULT_OK

import android.content.ComponentName

import android.content.Intent

import android.os.Build
import android.util.Log

import android.widget.FrameLayout

import android.widget.Toast
import androidx.core.app.ActivityCompat.startActivityForResult
import br.com.delbank.otpsdk.android.FastValidade
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(SdkDelbank())
    }
}

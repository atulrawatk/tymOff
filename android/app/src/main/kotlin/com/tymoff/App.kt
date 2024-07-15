package com.example.medicationreminder

import io.flutter.app.FlutterApplication
import android.content.Context
import androidx.multidex.MultiDex

import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import vn.hunghd.flutterdownloader.FlutterDownloaderPlugin


class App : FlutterApplication(), PluginRegistry.PluginRegistrantCallback  {

  override fun attachBaseContext(base: Context) {
    super.attachBaseContext(base)
    MultiDex.install(this)
  }

  override fun registerWith(registry: PluginRegistry) {
    GeneratedPluginRegistrant.registerWith(registry)
  }
}
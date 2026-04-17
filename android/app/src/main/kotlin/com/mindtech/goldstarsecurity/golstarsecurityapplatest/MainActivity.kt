package com.mindtech.goldstarsecurity.golstarsecurityapplatest

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
  private val channelName = "com.mindtech.goldstarsecurity/public_downloads"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
      if (call.method != "savePdf") {
        result.notImplemented()
        return@setMethodCallHandler
      }

      try {
        val bytes = call.argument<ByteArray>("bytes")
        val fileName = call.argument<String>("fileName") ?: "verification.pdf"
        if (bytes == null) {
          result.error("ARG_ERROR", "Missing bytes", null)
          return@setMethodCallHandler
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
          val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
            put(MediaStore.MediaColumns.MIME_TYPE, "application/pdf")
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
            put(MediaStore.MediaColumns.IS_PENDING, 1)
          }

          val resolver = applicationContext.contentResolver
          val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
          if (uri == null) {
            result.error("IO_ERROR", "Unable to create MediaStore entry", null)
            return@setMethodCallHandler
          }

          resolver.openOutputStream(uri)?.use { stream ->
            stream.write(bytes)
            stream.flush()
          }

          values.clear()
          values.put(MediaStore.MediaColumns.IS_PENDING, 0)
          resolver.update(uri, values, null, null)
          result.success(uri.toString())
        } else {
          // Pre-Android 10: scoped storage not available. Return an error so Dart can ignore gracefully.
          result.error("UNSUPPORTED", "Public Downloads export requires Android 10+", null)
        }
      } catch (e: Exception) {
        result.error("IO_ERROR", e.message, null)
      }
    }
  }
}

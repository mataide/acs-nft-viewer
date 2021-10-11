package com.bimsina.re_walls

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import android.app.WallpaperManager
import android.graphics.BitmapFactory
import java.io.File
import android.os.Build
import android.annotation.TargetApi
import android.content.Context
import androidx.annotation.NonNull

private const val CHANNEL = "com.bimsina.re_walls/wallpaper"
private const val HOME = "setWallpaper"
private const val LOCK = "setLockWallpaper"

class MainActivity: FlutterActivity() {

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      print("call ${call.method}")
      if (call.method == HOME || call.method == LOCK) {
        val setWallpaper = setWallpaper(call.arguments as String, applicationContext)
        if (setWallpaper == 0) {
          result.success(setWallpaper)
        } else {
          result.error("UNAVAILABLE", "", null)
        }
      } else {
        result.notImplemented()
      }
    }
  }

  @TargetApi(Build.VERSION_CODES.ECLAIR)
  private fun setWallpaper(path: String, applicationContext: Context): Int {
    var setWallpaper = 1
    val bitmap = BitmapFactory.decodeFile(path)
    val wm: WallpaperManager? = WallpaperManager.getInstance(applicationContext)
    setWallpaper = try {
      wm?.setBitmap(bitmap)
      0
    } catch (e: IOException) {
      1
    }

    return setWallpaper
  }
}


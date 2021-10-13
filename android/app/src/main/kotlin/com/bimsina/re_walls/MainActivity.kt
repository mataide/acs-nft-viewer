package com.bimsina.re_walls

import android.annotation.TargetApi
import android.app.WallpaperManager
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.view.View
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import org.walletconnect.Session
import org.walletconnect.nullOnThrow
import java.io.IOException

private const val CHANNEL = "com.bimsina.re_walls/wallpaper"
private const val HOME = "setWallpaper"
private const val LOCK = "setLockWallpaper"
private const val WALLET_CONNECTION = "initWalletConnection"
private const val WALLET_DISCONNECTION = "initWalletDisconnection"

class MainActivity: FlutterActivity(), Session.Callback {

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      print("call ${call.method}")
      if (call.method == WALLET_CONNECTION) {
        initWalletConnection()
      } else if (call.method == WALLET_DISCONNECTION) {
        initWalletDisconnection()
      } else if (call.method == HOME || call.method == LOCK) {
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

  override fun onStart() {
    super.onStart()
    initialSetup()
  }

  override fun onStatus(status: Session.Status) {
    when(status) {
      Session.Status.Approved -> sessionApproved()
      Session.Status.Closed -> sessionClosed()
      Session.Status.Connected,
      Session.Status.Disconnected,
      is Session.Status.Error -> {
        // Do Stuff
      }
    }
  }

  private fun initialSetup() {
    val session = nullOnThrow { ExampleApplication.session } ?: return
    session.addCallback(this)
    sessionApproved()
  }

  override fun onMethodCall(call: Session.MethodCall) {
  }
  private fun sessionApproved(): String {
    val result = runBlocking {
      "Connected: ${ExampleApplication.session.approvedAccounts()}"
    }
    return result
  }

  private fun sessionClosed() {
  }

  private fun initWalletConnection() {
    ExampleApplication.resetSession()
    ExampleApplication.session.addCallback(this)
    val i = Intent(Intent.ACTION_VIEW)
    i.data = Uri.parse(ExampleApplication.config.toWCUri())
    startActivity(i)
  }

  private fun initWalletDisconnection() {
    ExampleApplication.session.kill()
  }

}


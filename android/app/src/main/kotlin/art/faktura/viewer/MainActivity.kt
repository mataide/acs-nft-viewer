package art.faktura.viewer

import android.annotation.TargetApi
import android.app.WallpaperManager
import android.content.Context
import android.graphics.BitmapFactory
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

private const val CHANNEL = "com.bimsina.re_walls/MainActivity"
private const val HOME = "setWallpaper"
private const val LOCK = "setLockWallpaper"
private const val WALLET_CONNECTION = "initWalletConnection"
private const val WALLET_DISCONNECTION = "initWalletDisconnection"
private const val EVENT_CHANNEL_WALLET = "com.bimsina.re_walls/WalletStreamHandler"


class MainActivity: FlutterActivity() {

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_WALLET)
      .setStreamHandler(WalletStreamHandler(this))

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
        }
        else {
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

  private fun initWalletConnection() {
    WalletConnect.getInstance(applicationContext).connect()
  }

  private fun initWalletDisconnection() {
    WalletConnect.getInstance(applicationContext).session.kill()
  }

}


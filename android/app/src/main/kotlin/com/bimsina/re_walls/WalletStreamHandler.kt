package com.bimsina.re_walls

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.runBlocking
import org.walletconnect.Session

class WalletStreamHandler(private var activity: Activity?) : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        activity?.applicationContext?.let { initialSetup(it) }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        activity = null
    }

    private val sessionCallback = object : Session.Callback {

        override fun onMethodCall(call: Session.MethodCall) {
            TODO("Not yet implemented")
        }

        override fun onStatus(status: Session.Status) {
            when(status) {
                Session.Status.Approved -> keyApproved()
                Session.Status.Closed -> sessionClosed()
                Session.Status.Connected -> {
                    requestConnectionToWallet()
                }
                Session.Status.Disconnected,
                is Session.Status.Error -> {
                    activity?.runOnUiThread { eventSink?.error("error","error", "error") }
                }
            }
        }
    }

    private fun keyApproved () = runBlocking {
        activity?.runOnUiThread { eventSink?.success(activity?.applicationContext?.let {
            WalletConnect.getInstance(it).session.approvedAccounts()?.get(0)
        }) }
    }


    private fun sessionClosed() {
        activity?.runOnUiThread { eventSink?.success("disconnected") }
    }

    private fun initialSetup(applicationContext: Context) {
        if(WalletConnect.getInstance(applicationContext).isSessionInitialized()) {
            val session = WalletConnect.getInstance(applicationContext).session
            session.addCallback(sessionCallback)
            keyApproved()
        }
    }

    private fun requestConnectionToWallet() {
        val i = Intent(Intent.ACTION_VIEW)
        i.data = Uri.parse(activity?.applicationContext?.let { WalletConnect.getInstance(it).config.toWCUri() })
        activity?.startActivity(i)
    }
}
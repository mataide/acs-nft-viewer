package com.bimsina.re_walls

import android.content.Context
import androidx.multidex.MultiDexApplication
import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import io.walletconnect.example.server.BridgeServer
import okhttp3.OkHttpClient
import org.komputing.khex.extensions.toNoPrefixHexString
import org.walletconnect.Session
import org.walletconnect.impls.*
import org.walletconnect.nullOnThrow
import java.io.File
import java.util.*

class ExampleApplication : MultiDexApplication() {

    companion object {
        private lateinit var client: OkHttpClient
        private lateinit var moshi: Moshi
        private lateinit var bridge: BridgeServer
        private lateinit var storage: WCSessionStore
        lateinit var config: Session.FullyQualifiedConfig
        lateinit var session: Session

        fun isSessionInitialized() = ::session.isInitialized


        fun init(context:Context) {
            initMoshi()
            initClient()
            initBridge()
            initSessionStorage(context)
        }

        private fun initClient() {
            client = OkHttpClient.Builder().build()
        }

        private fun initMoshi() {
            moshi = Moshi.Builder().addLast(KotlinJsonAdapterFactory()).build()
        }


        private fun initBridge() {
            bridge = BridgeServer(moshi)
            bridge.start()
        }

        private fun initSessionStorage(context:Context) {
            storage = FileWCSessionStore(File(context.cacheDir, "session_store.json").apply { createNewFile() }, moshi)
        }

        fun resetSession() {
            nullOnThrow { session }?.clearCallbacks()
            val key = ByteArray(32).also { Random().nextBytes(it) }.toNoPrefixHexString()
            config = Session.FullyQualifiedConfig(UUID.randomUUID().toString(), "http://localhost:${BridgeServer.PORT}", key)
            // The walletConnect app freezes/crashes if "icons" in passed PeerMeta is not filled, so pass at least an empty list.
            session = WCSession(config,
                MoshiPayloadAdapter(moshi),
                storage,
                OkHttpTransport.Builder(client, moshi),
                Session.PeerMeta(
                    url = "www.accursedshare.art",
                    name = "ACC: NFT Viewer",
                    description = "Login with wallet connect. Permission required: Public Address",
                    icons = listOf()
                )
            )
            session.offer()
        }
    }
}
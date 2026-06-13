package com.nfcpay.app

import android.nfc.NfcAdapter
import android.nfc.Tag
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.nfcpay.app/nfc"
    private var nfcAdapter: NfcAdapter? = null
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "isNfcAvailable" -> {
                    nfcAdapter = NfcAdapter.getDefaultAdapter(this)
                    result.success(nfcAdapter != null && nfcAdapter!!.isEnabled)
                }
                "enableNfcForeground" -> {
                    enableNfcForegroundDispatch()
                    result.success(true)
                }
                "disableNfcForeground" -> {
                    disableNfcForegroundDispatch()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
    }

    override fun onResume() {
        super.onResume()
        // Handle NFC intent if app launched via NFC tag
        intent?.let { handleNfcIntent(it) }
    }

    private fun handleNfcIntent(intent: android.content.Intent) {
        val tag = intent.getParcelableExtra<Tag>(NfcAdapter.EXTRA_TAG)
        tag?.let {
            val tagId = it.id.joinToString("") { byte -> "%02X".format(byte) }
            methodChannel?.invokeMethod("onTagDiscovered", mapOf("tagId" to tagId))
        }
    }

    private fun enableNfcForegroundDispatch() {
        // Implementation will use PendingIntent for foreground dispatch
        nfcAdapter?.let { adapter ->
            if (!adapter.isEnabled) return
            // Foreground dispatch setup here
        }
    }

    private fun disableNfcForegroundDispatch() {
        nfcAdapter?.disableForegroundDispatch(this)
    }
}

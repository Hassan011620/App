package com.nfcpay.app

import android.nfc.cardemulation.HostApduService
import android.os.Bundle

/**
 * Host Card Emulation Service
 * يستجيب لأوامر APDU من terminal الدفع
 */
class NfcHceService : HostApduService() {

    companion object {
        // AID الخاص بالتطبيق
        private val AID_BYTES = byteArrayOf(
            0xA0.toByte(), 0x00, 0x00, 0x00, 0x04, 0x10, 0x10
        )
        // SELECT AID command
        private val SELECT_APDU_HEADER = byteArrayOf(
            0x00, 0xA4.toByte(), 0x04, 0x00
        )
        // Response codes
        private val OK_SW    = byteArrayOf(0x90.toByte(), 0x00)
        private val FAIL_SW  = byteArrayOf(0x6A, 0x82.toByte())
        private val UNKNOWN_SW = byteArrayOf(0x6D, 0x00)
    }

    override fun processCommandApdu(commandApdu: ByteArray, extras: Bundle?): ByteArray {
        if (commandApdu.isEmpty()) return UNKNOWN_SW

        return when {
            isSelectAid(commandApdu) -> buildSelectResponse()
            isGetBalance(commandApdu) -> buildBalanceResponse()
            else -> UNKNOWN_SW
        }
    }

    private fun isSelectAid(apdu: ByteArray): Boolean {
        if (apdu.size < SELECT_APDU_HEADER.size + 1) return false
        for (i in SELECT_APDU_HEADER.indices) {
            if (apdu[i] != SELECT_APDU_HEADER[i]) return false
        }
        return true
    }

    private fun isGetBalance(apdu: ByteArray): Boolean {
        return apdu.size >= 4 && apdu[0] == 0x80.toByte() && apdu[1] == 0x50.toByte()
    }

    private fun buildSelectResponse(): ByteArray {
        // Application label + SW_OK
        val label = "NFC PAY".toByteArray()
        return label + OK_SW
    }

    private fun buildBalanceResponse(): ByteArray {
        // Demo balance: 12450.75 SDG encoded as BCD
        val balance = byteArrayOf(0x01, 0x24, 0x50, 0x75)
        return balance + OK_SW
    }

    override fun onDeactivated(reason: Int) {
        // Called when connection is lost
    }
}

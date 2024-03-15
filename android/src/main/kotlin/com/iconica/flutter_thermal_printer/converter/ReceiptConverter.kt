package com.iconica.flutter_thermal_printer.converter

import com.iconica.flutter_thermal_printer.enums.ReceiptType
import com.iconica.flutter_thermal_printer.models.TableInfo

import org.json.JSONArray
import org.json.JSONException

import java.util.logging.Logger

/**
 * Service to convert receipt data.
 *
 * @since 1.0.0
 * @version 1.0.0
 * @author Mark Kiepe
 */
class ReceiptConverter {

    val logger = Logger.getLogger("ReceiptConverter")

    /**
     * This function converts JSON data to a list of pairs of receipt types and their values.
     *
     * @param receiptData {@link ArrayList} The receipt data to be converted.
     * @return {@link List} A list of pairs of receipt types and their values.
     */
    fun convertReceipt(receiptData: ArrayList<HashMap<String, String>>): List<Pair<ReceiptType, Any>> {
        val result = mutableListOf<Pair<ReceiptType, Any>>()

        receiptData.forEach {
            val type = getReceiptType(it["type"] as String)

            if (type == ReceiptType.table) {
                val value = it["value"] as String
                logger.info("Parsing JSON: $value")

                if (!isValidJson(value)) {
                    logger.severe("Invalid JSON string: $value")
                    return@forEach
                }

                val json = JSONArray(value)

                val table = mutableListOf<List<String>>()
                for (i in 0 until json.length()) {
                    val row = json.getJSONArray(i)
                    val rowList = mutableListOf<String>()
                    for (j in 0 until row.length()) {
                        rowList.add(row.getString(j))
                    }
                    table.add(rowList)
                }

                result.add(Pair(type, TableInfo(table)))
                return@forEach
            } else {
                val value = it["value"]
                result.add(Pair(type, value!!))
            }
        }

        return result
    }

    private fun getReceiptType(type: String): ReceiptType {
        return when (type) {
            "text" -> ReceiptType.text
            "table" -> ReceiptType.table
            "qrCode" -> ReceiptType.qrCode
            "barcode" -> ReceiptType.barcode
            "spacing" -> ReceiptType.spacing
            else -> throw IllegalArgumentException("Invalid receipt type")
        }
    }

    private fun isValidJson(json: String): Boolean {
        return try {
            JSONArray(json)
            true
        } catch (ex: JSONException) {
            false
        }
    }
}

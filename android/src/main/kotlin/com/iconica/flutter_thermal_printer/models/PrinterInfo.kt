package com.iconica.flutter_thermal_printer.models

import com.starmicronics.starioextension.StarIoExt

/**
 * This class represents the printer information.
 *
 * @property portName The port name of the printer.
 * @property modelName The model name of the printer.
 * @property macAddress The MAC address of the printer.
 * @property emulation The emulation of the printer.
 * @property portSettings The port settings of the printer.
 *
 * @author Mark Kiepe
 * @since 1.0.0
 * @version 1.0.0
 */
class PrinterInfo(
    val portName: String,
    val modelName: String,
    val macAddress: String,
    val emulation: StarIoExt.Emulation,
    val portSettings: String,
) {

    /**
     * This method converts the printer information to a map.
     *
     * @return Map<String, Any> The printer information as a map.
     */
    fun toMap(): Map<String, Any> {
        return mapOf(
            "portName" to portName,
            "modelName" to modelName,
            "macAddress" to macAddress,
            "emulation" to emulation.toString(),
            "portSettings" to portSettings
        )
    }
}

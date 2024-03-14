package com.iconica.flutter_thermal_printer.services

import android.content.Context

import com.iconica.flutter_thermal_printer.models.PrinterInfo

import com.starmicronics.stario.PortInfo
import com.starmicronics.stario.StarIOPort
import com.starmicronics.stario.StarIOPortException

import java.util.logging.Logger

/**
 * Service for searching for a printer.
 *
 * @implSpec This service will first search for a Bluetooth printer and if none is found, it will
 * search for a wireless printer.
 *
 * @author Mark Kiepe
 * @since 1.0.0
 * @version 1.0.0
 */
class PrinterSearchingService {

    private val logger = Logger.getLogger("SearchPrinterService")
    private val printerSettingsService = PrinterSettingsService()

    private var selectedPrinter: PrinterInfo? = null

    /**
     * Gets the selected printer as set by an user.
     *
     * @return {@link PrinterInfo} The selected printer.
     */
    fun getSelectedPrinter(): PrinterInfo? {
        return selectedPrinter
    }

    /**
     * This method gets a list of all the printers that are available to the device.
     *
     * @implSpec Do not overuse this method as it can be slow. It is recommended to use this
     * method once, and let the user decide which printer to use.
     *
     * @param applicationContext {@link Context} The application context.
     * @return {@link List} A list of all the printers that are available to the device.
     */
    fun getPrinters(applicationContext: Context): List<PrinterInfo> {
        val printers = mutableListOf<PrinterInfo>()

        getBluetoothPrinters().forEach {
            printers.add(toPrinterInfo(it))
        }

        getWirelessPrinters().forEach {
            printers.add(toPrinterInfo(it))
        }

        getUsbPrinters(applicationContext).forEach {
            printers.add(toPrinterInfo(it))
        }

        return printers
    }

    /**
     * This method gets the most compatible printer for the device.
     *
     * @implSpec This method will first check if a printer has been selected by the user. If a
     * printer has been selected, it will return that printer. If no printer has been selected, it
     * will check for a USB printer, then a Bluetooth printer, and finally a wireless printer.
     *
     * @param applicationContext {@link Context} The application context.
     * @return {@link PrinterInfo} The most compatible printer for the device.
     */
    fun getMostCompatiblePrinter(applicationContext: Context): PrinterInfo? {
        selectedPrinter?.let {
            return it
        }

        val usbPrinters = getUsbPrinters(applicationContext)
        if (usbPrinters.isNotEmpty()) {
            return toPrinterInfo(usbPrinters[0])
        }

        val bluetoothPrinters = getBluetoothPrinters()
        if (bluetoothPrinters.isNotEmpty()) {
            return toPrinterInfo(bluetoothPrinters[0])
        }

        val wirelessPrinters = getWirelessPrinters()
        if (wirelessPrinters.isNotEmpty()) {
            return toPrinterInfo(wirelessPrinters[0])
        }

        return null
    }

    /**
     * This method tries to get a printer based on the port name.
     *
     * @param applicationContext {@link Context} The application context.
     * @param portName {@link String} The port name of the printer.
     * @return {@link PrinterInfo} The printer with the provided port name.
     */
    fun getPrinterFromPortName(applicationContext: Context, portName: String): PrinterInfo? {
        val printers = getPrinters(applicationContext)
        return printers.find { it.portName == portName }
    }

    /**
     * This method sets the selected printer.
     *
     * @param printer {@link PrinterInfo} The printer to set as the selected printer.
     */
    fun setSelectedPrinter(printer: PrinterInfo) {
        selectedPrinter = printer
    }

    /**
     * Some printers do not return a model name inside of the {@link PortInfo} object. This method will
     * attempt to get the model name of the printer by opening a port and getting the firmware
     * information.
     *
     * @implNote This method is not recommended to be used often as it can be slow.
     * @implSpec This method attempts to open a port without portSettings. If the port cannot be
     * opened, it will return an empty string.
     *
     * @param portInfo {@link PortInfo} The port info of the printer.
     * @return {@link String} The model name of the printer.
     */
    fun getModelName(portInfo: PortInfo): String {
        if (portInfo.modelName.isNotEmpty()) {
            return portInfo.modelName
        }

        var port: StarIOPort? = null

        try {
            port = StarIOPort.getPort(portInfo.portName, "", 1000, null)
            val firmwareInformation = port.firmwareInformation

            if (firmwareInformation.containsKey("ModelName"))  {
                return firmwareInformation["ModelName"] ?: ""
            }
        } catch (e: StarIOPortException) {
            logger.warning("Error getting model name: ${e.message}")
        } finally {
            port?.let {
                try {
                    StarIOPort.releasePort(it)
                } catch (e: StarIOPortException) {
                    logger.warning("Error releasing port: ${e.message}")
                }
            }
        }

        return ""
    }

    private fun toPrinterInfo(portInfo: PortInfo): PrinterInfo {
        val modelName = getModelName(portInfo)
        val emulation = printerSettingsService.getEmulation(modelName)
        val portSettings = printerSettingsService.getPortSettingsOption(emulation.toString())
        return PrinterInfo(portInfo.portName, modelName, portInfo.macAddress, emulation, portSettings)
    }

    private fun getBluetoothPrinters(): List<PortInfo> {
        try {
            return StarIOPort.searchPrinter("BT:")
        } catch (e: StarIOPortException) {
            logger.warning("Error searching for Bluetooth printer: ${e.message}")
        }

        return emptyList()
    }

    private fun getWirelessPrinters(): List<PortInfo> {
        try {
            return StarIOPort.searchPrinter("TCP:")
        } catch (e: StarIOPortException) {
            logger.warning("Error searching for wireless printer: ${e.message}")
        }

        return emptyList()
    }

    private fun getUsbPrinters(context: Context): List<PortInfo> {
        try {
            return StarIOPort.searchPrinter(
                "USB:",
                context
            ) // Change to USB:SN:serial to use multiple printers
        } catch (e: StarIOPortException) {
            if (!e.message.equals("Cannot find printer", ignoreCase = true)) {
                logger.warning("Error searching for USB printer: ${e.message}")
            }
        }

        return emptyList()
    }
}

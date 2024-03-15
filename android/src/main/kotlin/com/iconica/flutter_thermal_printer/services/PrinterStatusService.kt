package com.iconica.flutter_thermal_printer.services

import android.content.Context

import com.iconica.flutter_thermal_printer.enums.PrinterState

import com.starmicronics.stario.StarIOPort
import com.starmicronics.stario.StarIOPortException
import com.starmicronics.stario.StarPrinterStatus
import java.io.IOException

import java.util.logging.Logger

/**
 * Service to check the status of the printer.
 *
 * @author Mark Kiepe
 * @since 1.0.0
 * @version 1.0.0
 */
class PrinterStatusService {

    private val logger = Logger.getLogger("PrinterStatusService")
    private val printerSearchingService = PrinterSearchingService()

    /**
     * This method checks if the printer is able to print based on the status of the printer.
     *
     * @param status {@link StarPrinterStatus} The status of the printer.
     * @return {@link Boolean} True if the printer is able to print, false otherwise.
     */
    fun isPrinterAbleToPrint(status: StarPrinterStatus): Boolean {
        return when {
            status.offline -> false
            status.coverOpen -> false
            status.presenterPaperJamError -> false
            status.cutterError -> false
            status.overTemp -> false
            status.voltageError -> false
            status.receiptPaperEmpty -> false
            status.paperDetectionError -> false
            status.blackMarkError -> false
            status.unrecoverableError -> false
            else -> true
        }
    }

    /**
     * Check the status of the printer.
     *
     * @param applicationContext {@link Context} The application context.
     * @return {@link PrinterState} The state of the printer.
     */
    fun checkStatus(applicationContext: Context): PrinterState {
        var port: StarIOPort? = null
        var printerState = PrinterState.notFound

        val printerInfo = printerSearchingService.getMostCompatiblePrinter(applicationContext) ?: return printerState

        try {
            port = StarIOPort.getPort(
                printerInfo.portName,
                printerInfo.portSettings,
                TIMEOUT,
                applicationContext
            )

            val status = port.retreiveStatus()

            printerState = when {
                status.offline -> PrinterState.offline
                status.coverOpen -> PrinterState.coverOpen
                status.presenterPaperJamError -> PrinterState.paperJamError
                status.cutterError -> PrinterState.cutterError
                status.overTemp -> PrinterState.highTemperatureError
                status.voltageError -> PrinterState.voltageError
                status.receiptPaperEmpty -> PrinterState.paperEmptyError
                status.paperDetectionError -> PrinterState.paperPositionError
                status.receiptPaperNearEmptyOuter || status.receiptPaperNearEmptyInner -> PrinterState.paperNearEmptyNotification
                status.blackMarkError -> PrinterState.cleaningNotification
                status.unrecoverableError -> PrinterState.unknown
                else -> PrinterState.ok
            }
        } catch(ex: StarIOPortException) {
            logger.warning("Error checking printer status: ${ex.message}")
        } catch (e: IOException) {
            logger.warning("Failed to connect to Socket: ${e.message}")
        } finally {
            port?.let {
                try {
                    StarIOPort.releasePort(it)
                } catch (e: StarIOPortException) {
                    logger.warning("Error releasing port: ${e.message}")
                }
            }
        }

        return printerState
    }

    internal companion object {
        private const val TIMEOUT = 10_000
    }
}

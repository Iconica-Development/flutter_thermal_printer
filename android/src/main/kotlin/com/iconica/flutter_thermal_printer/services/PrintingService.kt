package com.iconica.flutter_thermal_printer.services

import android.content.Context
import com.iconica.flutter_thermal_printer.models.PrinterInfo

import com.starmicronics.stario.StarIOPort
import com.starmicronics.stario.StarIOPortException
import com.starmicronics.starioextension.ICommandBuilder
import com.starmicronics.starioextension.StarIoExt

import java.util.logging.Logger

/**
 * Service to print to the printer.
 *
 * @author Mark Kiepe
 * @since 1.0.0
 * @version 1.0.0
 */
class PrintingService {

    private val logger = Logger.getLogger("PrintingService")

    private val printerSearchingService = PrinterSearchingService()
    private val printerStatusService = PrinterStatusService()

    private var isPrinting = false

    /**
     * Checks if the printer is currently printing.
     *
     * @return {@link Boolean} True if the printer is printing, false otherwise.
     */
    fun isPrinting(): Boolean {
        return isPrinting
    }

    /**
     * Print to the printer.
     *
     * @see StarIOPort
     *
     * @param applicationContext {@link Context} The application context.
     * @return {@link Boolean} True if the print was successful, false otherwise.
     */
    fun startPrint(applicationContext: Context): Boolean {
        if (isPrinting) {
            logger.warning("Already printing")
            return false
        }

        isPrinting = true

        var port: StarIOPort? = null

        val printerInfo = printerSearchingService.getMostCompatiblePrinter(applicationContext)
        if (printerInfo == null) {
            logger.severe("No printer found")
            return false
        }

        val receiptBuilder = buildReceipt(printerInfo)

        try {
            port = StarIOPort.getPort(
                printerInfo.portName,
                printerInfo.emulation.toString(),
                TIMEOUT,
                applicationContext
            )

            var status = port.beginCheckedBlock()

            if (!printerStatusService.isPrinterAbleToPrint(status)) {
                logger.warning("Printer is not able to print")
                return false
            }

            port.writePort(receiptBuilder.commands, 0, receiptBuilder.commands.size)

            status = port.endCheckedBlock()

            return if (!printerStatusService.isPrinterAbleToPrint(status)) {
                logger.warning("Failed to print")
                false
            } else {
                true
            }
        } catch (e: StarIOPortException) {
            logger.severe("Error opening port: ${e.message}")
            return false
        } finally {
            port?.let {
                try {
                    StarIOPort.releasePort(it)
                } catch (e: StarIOPortException) {
                    logger.severe("Error releasing port: ${e.message}")
                }
            }
            isPrinting = false
        }
    }

    private fun buildReceipt(printerInfo: PrinterInfo): ICommandBuilder {
        val builder = StarIoExt.createCommandBuilder(printerInfo.emulation)
        builder.beginDocument()

        builder.appendQrCode("https://iconica.app".toByteArray(), ICommandBuilder.QrCodeModel.No2, ICommandBuilder.QrCodeLevel.M, 5)
        builder.appendUnitFeed(32)
        builder.appendCutPaper(ICommandBuilder.CutPaperAction.PartialCutWithFeed)

        builder.endDocument()

        return builder
    }

    internal companion object {
        private const val TIMEOUT = 10_000
    }

}

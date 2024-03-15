package com.iconica.flutter_thermal_printer.services

import android.content.Context

import com.iconica.flutter_thermal_printer.enums.ReceiptType
import com.iconica.flutter_thermal_printer.models.PrinterInfo
import com.iconica.flutter_thermal_printer.models.TableInfo

import com.starmicronics.stario.StarIOPort
import com.starmicronics.stario.StarIOPortException
import com.starmicronics.starioextension.ICommandBuilder
import com.starmicronics.starioextension.StarIoExt

import java.io.IOException
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

    private val printerBuilder = PrinterBuilder()
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
    fun startPrint(
        applicationContext: Context,
        receiptData: List<Pair<ReceiptType, Any>>
    ): Boolean {
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

        val receiptBuilder = buildReceipt(printerInfo, receiptData)

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
        } catch (e: IOException) {
            logger.warning("Failed to connect to Socket: ${e.message}")
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

    private fun buildReceipt(
        printerInfo: PrinterInfo,
        receiptData: List<Pair<ReceiptType, Any>>
    ): ICommandBuilder {
        val builder = StarIoExt.createCommandBuilder(printerInfo.emulation)
        builder.beginDocument()

        for (data in receiptData) {
            try {
                when (data.first) {
                    ReceiptType.text -> {
                        val textData = data.second as String
                        builder.appendBitmap(
                            printerBuilder.createBitmapFromText(
                                textData,
                                PAPER_WIDTH
                            ),
                            true,
                            PAPER_WIDTH,
                            true
                        )
                    }

                    ReceiptType.qrCode -> {
                        val qrCodeData = (data.second as String).toByteArray()
                        builder.appendQrCodeWithAlignment(
                            qrCodeData,
                            ICommandBuilder.QrCodeModel.No1,
                            ICommandBuilder.QrCodeLevel.Q,
                            8,
                            ICommandBuilder.AlignmentPosition.Center
                        )
                    }

                    ReceiptType.barcode -> {
                        val barcodeData = (data.second as String).toByteArray()
                        builder.appendBarcodeWithAlignment(
                            barcodeData,
                            ICommandBuilder.BarcodeSymbology.Code128,
                            ICommandBuilder.BarcodeWidth.Mode1,
                            50,
                            true,
                            ICommandBuilder.AlignmentPosition.Center
                        )
                    }

                    ReceiptType.table -> {
                        val tableData = data.second as TableInfo
                        builder.appendBitmap(
                            printerBuilder.createBitmapFromTableInfo(PAPER_WIDTH, tableData),
                            true,
                            PAPER_WIDTH,
                            true
                        )
                    }

                    ReceiptType.spacing -> {
                        val spacing = (data.second as String).toIntOrNull()
                        if (spacing != null) {
                            builder.appendUnitFeed(spacing)
                        } else {
                            logger.warning("Invalid spacing value: ${data.second}")
                            builder.appendUnitFeed(20)
                        }
                    }
                }
            } catch (e: IncorrectAndroidVersionException) {
                logger.severe("Failed to create bitmap: ${e.message}")
            }
        }

        builder.appendCutPaper(ICommandBuilder.CutPaperAction.PartialCutWithFeed)

        builder.endDocument()

        return builder
    }

    internal companion object {
        private const val TIMEOUT = 10_000
        private const val PAPER_WIDTH = 576
    }
}

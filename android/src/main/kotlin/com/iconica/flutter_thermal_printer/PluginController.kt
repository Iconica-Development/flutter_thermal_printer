package com.iconica.flutter_thermal_printer

import android.content.Context
import android.os.Build
import android.os.StrictMode

import com.iconica.flutter_thermal_printer.services.PrinterStatusService
import com.iconica.flutter_thermal_printer.services.PrintingService
import com.iconica.flutter_thermal_printer.services.PrinterSearchingService

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * This class is the main controller for the plugin.
 *
 * @implSpec This class is responsible for handling all the method calls from the Dart side.
 *
 * @see FlutterPlugin
 * @see MethodCallHandler
 *
 * @author Mark Kiepe
 * @since 1.0.0
 * @version 1.0.0
 */
class PluginController: FlutterPlugin, MethodCallHandler {

  private lateinit var channel: MethodChannel
  private lateinit var applicationContext: Context

  private val printerSearchingService = PrinterSearchingService()
  private val printerStatusService = PrinterStatusService()
  private val printingService = PrintingService()

  /**
   * This {@code FlutterPlugin} has been associated with a {@link
   * io.flutter.embedding.engine.FlutterEngine} instance.
   *
   * <p>Relevant resources that this {@code FlutterPlugin} may need are provided via the {@code
   * binding}. The {@code binding} may be cached and referenced until {@link
   * #onDetachedFromEngine(FlutterPluginBinding)} is invoked and returns.
   */
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_thermal_printer")
    channel.setMethodCallHandler(this)
    applicationContext = flutterPluginBinding.applicationContext

    val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
    StrictMode.setThreadPolicy(policy)
  }

  /**
   * Handles the specified method call received from Flutter.
   *
   * <p>Handler implementations must submit a result for all incoming calls, by making a single
   * call on the given {@link Result} callback. Failure to do so will result in lingering Flutter
   * result handlers. The result may be submitted asynchronously and on any thread. Calls to
   * unknown or unimplemented methods should be handled using {@link Result#notImplemented()}.
   *
   * <p>Any uncaught exception thrown by this method will be caught by the channel implementation
   * and logged, and an error result will be sent back to Flutter.
   *
   * <p>The handler is called on the platform thread (Android main thread) by default, or
   * otherwise on the thread specified by the {@link BinaryMessenger.TaskQueue} provided to the
   * associated {@link MethodChannel} when it was created. See also <a
   * href="https://github.com/flutter/flutter/wiki/The-Engine-architecture#threading">Threading in
   * the Flutter Engine</a>.
   *
   * @param call A {@link MethodCall}.
   * @param result A {@link Result} used for submitting the result of the call.
   */
  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPrinter" -> {
        printerSearchingService.getMostCompatiblePrinter(applicationContext)?.let {
          result.success(it.toMap())
        } ?: run {
          result.success(null)
        }
      }

      "getPrinters" -> {
        val printers = printerSearchingService.getPrinters(applicationContext)
        result.success(printers.map { it.toMap() })
      }

      "getStatus" -> {
        result.success(
          mapOf(
            "state" to printerStatusService.checkStatus(applicationContext).toString(),
            "isRecoverable" to "true",
          )
        )
      }

      "isPrinting" -> {
        result.success(printingService.isPrinting())
      }

      "selectPrinter" -> {
        val portName = call.argument<String>("portName")

        if (portName == null) {
          result.error("INVALID_PORT_NAME", "The port name is invalid", null)
          return
        }

        val printer = printerSearchingService.getPrinterFromPortName(applicationContext, portName)

        if (printer == null) {
          result.error("PRINTER_NOT_FOUND", "The printer was not found", null)
          return
        }

        printerSearchingService.setSelectedPrinter(printer)
        result.success(true)
      }

      "print" -> {
        result.success(printingService.startPrint(applicationContext))
      }

      else -> {
        result.notImplemented()
      }
    }
  }

  /**
   * This {@code FlutterPlugin} has been removed from a {@link
   * io.flutter.embedding.engine.FlutterEngine} instance.
   *
   * <p>The {@code binding} passed to this method is the same instance that was passed in {@link
   * #onAttachedToEngine(FlutterPluginBinding)}. It is provided again in this method as a
   * convenience. The {@code binding} may be referenced during the execution of this method, but it
   * must not be cached or referenced after this method returns.
   *
   * <p>{@code FlutterPlugin}s should release all resources in this method.
   */
  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

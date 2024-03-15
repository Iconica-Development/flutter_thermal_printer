package com.iconica.flutter_thermal_printer.enums

/**
 * Enum for the printer state.
 *
 * @since 1.0.0
 * @version 1.0.0
 * @author Mark Kiepe
 */
enum class PrinterState {
    ok,
    notFound,
    unknown,
    offline,
    coverOpen,
    cutterError,
    highTemperatureError,
    voltageError,
    paperJamError,
    paperEmptyError,
    paperPositionError,
    paperNearEmptyNotification,
    cleaningNotification
}

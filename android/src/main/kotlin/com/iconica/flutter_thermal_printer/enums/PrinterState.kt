package com.iconica.flutter_thermal_printer.enums

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

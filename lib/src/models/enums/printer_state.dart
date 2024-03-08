enum PrinterState {
  ok,
  unknown,
  offline,

  coverOpen,

  paperSeparatorError,
  cutterError,
  highTemperatureError,
  voltageError,

  paperJamError,
  paperEmptyError,
  paperPositionError,

  paperNearEmptyNotification,
  cleaningNotification,
}

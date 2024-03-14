enum PrinterState {
  ok,
  unknown,
  notFound,
  offline,

  coverOpen,

  cutterError,
  highTemperatureError,
  voltageError,

  paperJamError,
  paperEmptyError,
  paperPositionError,

  paperNearEmptyNotification,
  cleaningNotification,
}

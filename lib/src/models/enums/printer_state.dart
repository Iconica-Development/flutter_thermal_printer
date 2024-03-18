/// Enum for printer state
/// This enum is used to represent the state of a printer.
/// The state of the printer can be used to determine if the printer is
/// ready to print, or if there is an error with the printer.
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

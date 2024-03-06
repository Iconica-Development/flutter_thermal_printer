import "package:intl/intl.dart";

/// Formats the given [date] into a string representation
/// of day, month, and year.
///
/// The [separator] parameter is optional and defaults to "/".
/// It specifies the separator character to be used between the
/// day, month, and year components in the formatted string.
///
/// Example:
/// ```dart
/// DateTime date = DateTime(2022, 10, 15);
/// String formattedDate = formatDayMonthYear(date);
/// print(formattedDate); // Output: "15/10/2022"
/// ```
String formatDayMonthYear(DateTime date, {String? separator = "/"}) =>
    DateFormat("dd${separator}MM${separator}yyyy").format(date);

/// Formats the given [date] into a string representation of the
/// hour and minute in 24-hour format.
///
/// Example:
/// ```dart
/// DateTime now = DateTime.now();
/// String formattedTime = formatHourMinute(now); // e.g. "14:30"
/// ```
String formatHourMinute(DateTime date) => DateFormat("HH:mm").format(date);

/// Formats the given [date] into a string representation of
/// hour, minute, and second.
///
/// The resulting string will be in the format "HH:mm:ss".
/// Example:
/// ```dart
/// DateTime now = DateTime.now();
/// String formattedTime = formatHourMinuteSecond(now); // e.g. "14:30:00"
/// ```
String formatHourMinuteSecond(DateTime date) =>
    DateFormat("HH:mm:ss").format(date);

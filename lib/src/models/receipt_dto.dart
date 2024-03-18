import "package:flutter_thermal_printer/src/models/enums/receipt_data.dart";
import "package:pair/pair.dart";

/// A data transfer object for a receipt.
/// Use this class to create a receipt data transfer object.
///
/// Do not use this class directly!
/// Instead, use [ReceiptBuilder] to create a receipt data transfer object.
class ReceiptDTO {
  List<Pair<ReceiptData, dynamic>> data = List.empty();

  /// Creates a JSON object from the receipt data transfer object.
  List<Map<String, String>> toJson() {
    var transformedData = data
        .map(
          (e) => e.transform(
            (key, value) {
              if (value is String) {
                return {
                  "type": key.name,
                  "value": value,
                };
              } else if (value is List<List<String>>) {
                return {
                  "type": key.name,
                  "value": value.toString(),
                };
              } else {
                throw const FormatException("Invalid type");
              }
            },
          ),
        )
        .toList();

    return transformedData;
  }
}

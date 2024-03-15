// ignore_for_file: avoid_returning_this

import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer/src/models/enums/receipt_data.dart";
import "package:flutter_thermal_printer/src/models/receipt_dto.dart";
import "package:pair/pair.dart";

/// A builder for [ReceiptDTO].
///
/// Use this class to build a [ReceiptDTO] object.
///
/// Example:
/// ```dart
/// var receiptDTO = ReceiptBuilder()
///  .addText("Hello, World!")
/// .addQRCode("https://github.com")
/// .addBarcode("1234567890")
/// .addTable([
///  ["Item", "Price"],
///  ["Apple", "1.00"],
///  ["Banana", "0.50"],
/// ])
/// .addSpacing(20)
/// .build();
/// ```
class ReceiptBuilder {
  final List<Pair<ReceiptData, String>> _data = List.empty(growable: true);

  /// Adds text to the receipt.
  ///
  /// [text] is the text to add to the receipt.
  ReceiptBuilder addText(String text) {
    _data.add(Pair(ReceiptData.text, text));
    return this;
  }

  /// Adds a QR code to the receipt.
  ///
  /// [qrCode] is the QR code to add to the receipt.
  ReceiptBuilder addQRCode(String qrCode) {
    _data.add(Pair(ReceiptData.qrCode, qrCode));
    return this;
  }

  /// Adds a barcode to the receipt.
  ///
  /// [barcode] is the barcode to add to the receipt.
  ReceiptBuilder addBarcode(String barcode) {
    _data.add(Pair(ReceiptData.barcode, barcode));
    return this;
  }

  /// Adds a table to the receipt.
  ///
  /// [table] is the table to add to the receipt.
  ReceiptBuilder addTable(List<List<String>> table) {
    _data.add(Pair(ReceiptData.table, _tableToJson(table)));
    return this;
  }

  /// Adds spacing to the receipt.
  ///
  /// [spacing] is the spacing to add to the receipt.
  ReceiptBuilder addSpacing(int spacing) {
    _data.add(Pair(ReceiptData.spacing, spacing.toString()));
    return this;
  }

  /// Builds the [ReceiptDTO] object.
  ///
  /// Returns the [ReceiptDTO] object.
  ReceiptDTO build() {
    var receiptDTO = ReceiptDTO();
    receiptDTO.data = _data;
    return receiptDTO;
  }

  String _tableToJson(List<List<String>> table) {
    var json = StringBuffer("[");

    for (var innerList in table) {
      json.write("[");
      for (var i = 0; i < innerList.length; i++) {
        json.write('"${innerList[i]}"');
        if (i < innerList.length - 1) {
          json.write(",");
        }
      }
      json.write("],");
    }

    if (json.length > 1 && json.toString().endsWith(",")) {
      json = StringBuffer(json.toString().substring(0, json.length - 1));
    }

    json.write("]");

    return json.toString();
  }
}

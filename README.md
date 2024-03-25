# flutter_thermal_printer

This plugin allows you to create receipts on any STAR Micronics printer.

## Support

The current version only supports android.

## Permissions

### Android

Include the following permissions in your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

## Example Usage

### Building a Receipt

This plugin contains a built-in `ReceiptBuilder` class that allows you to easily create
receipts. Here is how you do it:

```dart
ReceiptDTO receiptDTO = ReceiptBuilder()
    .addText("Thanks for your purchase!")
    .addSpacing(20)
    .addText("Your items:")
    .addSpacing(20)
    .addTable(
        List.of(
            [
                ["Product", "Quantity", "Price"],
                ["-------", "--------", "-----"],
                ["Product 1", "1x", "$ 5.00"]
            ],
        ),
    )
    .addSpacing(30)
    .addText(r"Total: $ 5.00")
    .addSpacing(50)
    .addText("Liked your order? Leave a review:")
    .addQRCode("https://www.iconica.app")
    .build();
```

### Printing your Receipt

Once you have your receipt, you can create a `PrintJobRequest`. This class contains two properties:
* ReceiptDTO
* OrderMetadata

The `ReceiptDTO` contains all the information that will be used by the printer to make sure the correct receipt gets printed. 

The `OrderMetadata` class is a simple list where you can store any metadata that you want to give your `PrintJobRequest`. By using this, you can map certain information about a receipt to your PrintJob. 

When you try to print your receipt, your `PrintJobRequest` gets converted into a `PrintJobResult` containing the same `OrderMetadata`. From that point forward, only use the Result, and not the request. 

The `PrintJobResult` contains extra information about the status of the PrintJob.

To start printing, use the following code:

```dart
var printJobRequest = PrintJobRequest(
    receiptDTO: ReceiptBuilder()
          .addText("Thanks for your order!")
          .addSpacing(20)
          // Add the rest of your receipt.
          .build(),
    orderMetadata: OrderMetadata()
        ..set("OrderId", 1)
        ..set("OrderDate", DateTime.now()),
);

PrintJobResult printJobResult = await Printer.instance.executePrint(randomOrder)

// See the status of the PrintJob
print(printJobResult.orderPrintInfo.status);
```

### Best Practice

This plugin is capable for connecting with not only Bluetooth printers but also with LAN and USB printers. Since looking for all three of these printers is quite time consuming, it is recommended that the user-interface will have the option to see all printers that can be connected to (this can be done using the `getPrinters()` method), and then to let the user select their preferred printer. You can set the preferred printer using the `setPrinter()` method. From this point forward, the plugin will only look at the preferred printer and ignore the rest.

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_thermal_printer) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](./CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_thermal_printer/pulls).

## Author

This flutter_thermal_printer for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>

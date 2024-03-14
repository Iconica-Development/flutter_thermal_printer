import "package:permission_handler/permission_handler.dart";

Future<PermissionStatus> requestBluetoothPermission() async {
  var permissions = [
    Permission.bluetoothConnect,
    Permission.location,
    Permission.bluetoothScan,
    Permission.bluetooth,
  ];

  for (var permission in permissions) {
    var status = await permission.status;
    if (!status.isGranted) {
      var result = await permission.request();
      if (result != PermissionStatus.granted) {
        return result;
      }
    }
  }

  return Permission.bluetooth.status;
}

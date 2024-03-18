import "package:permission_handler/permission_handler.dart";

/// Requests the necessary permissions for Bluetooth functionality.
///
/// This function requests the following permissions:
/// - [Permission.bluetoothConnect]
/// - [Permission.location]
/// - [Permission.bluetoothScan]
/// - [Permission.bluetooth]
///
/// If any of the permissions are not granted, the function will request
/// the permission from the user. If the user denies the permission request,
/// the function will return the [PermissionStatus] of the denied permission.
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

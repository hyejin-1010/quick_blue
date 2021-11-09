import 'dart:typed_data';

class BlueScanResult {
  String name;
  String deviceId;
  Uint8List manufacturerData;
  int rssi;

  String get macAddress {
    if (num.tryParse(deviceId) != null) {
      String result = int.parse(deviceId).toRadixString(16).toUpperCase().replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}:");
      if (result[result.length - 1] == ':') {
        result = result.substring(0, result.length - 1);
      }
      return result;
    }
    return '';
  }

  BlueScanResult.fromMap(map)
      : name = map['name'],
        deviceId = map['deviceId'],
        manufacturerData = map['manufacturerData'],
        rssi = map['rssi'];

  Map toMap() => {
        'name': name,
        'deviceId': deviceId,
        'macAddress': macAddress,
        'manufacturerData': manufacturerData,
        'rssi': rssi,
      };
}
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:quick_blue_platform_interface/quick_blue_platform_interface.dart';

class MethodChannelQuickBlue extends QuickBluePlatform {
  static const MethodChannel _method = const MethodChannel('quick_blue/method');
  static const _event_scanResult = const EventChannel('quick_blue/event.scanResult');
  static const _message_connector = const BasicMessageChannel('quick_blue/message.connector', StandardMessageCodec());

  MethodChannelQuickBlue() {
    _message_connector.setMessageHandler(_handleConnectorMessage);
  }

  @override
  void startScan() {
    _method.invokeMethod('startScan')
        .then((_) => print('startScan invokeMethod success'));
  }

  @override
  void stopScan() {
    _method.invokeMethod('stopScan')
        .then((_) => print('stopScan invokeMethod success'));
  }

  Stream<dynamic> _scanResultStream = _event_scanResult.receiveBroadcastStream({'name': 'scanResult'});

  @override
  Stream<dynamic> get scanResultStream => _scanResultStream;

  @override
  void connect(String deviceId) {
    _method.invokeMethod('connect', {
      'deviceId': deviceId,
    }).then((_) => print('connect invokeMethod success'));
  }

  @override
  void disconnect(String deviceId) {
    _method.invokeMethod('disconnect', {
      'deviceId': deviceId,
    }).then((_) => print('disconnect invokeMethod success'));
  }

  @override
  void discoverServices(String deviceId) {
    _method.invokeMethod('discoverServices', {
      'deviceId': deviceId,
    }).then((_) => print('discoverServices invokeMethod success'));
  }

  Future<void> _handleConnectorMessage(dynamic message) {
    print('_handleConnectorMessage $message');
    if (message['ConnectionState'] != null) {
      String deviceId = message['deviceId'];
      BlueConnectionState connectionState = BlueConnectionState.parse(message['ConnectionState']);
      onConnectionChanged?.call(deviceId, connectionState);
    } else if (message['ServiceState'] != null) {
      if (message['ServiceState'] == 'discovered') {
        String deviceId = message['deviceId'];
        List<dynamic> services = message['services'];
        for (var s in services) {
          onServiceDiscovered?.call(deviceId, s);
        }
      }
    }
  }
}

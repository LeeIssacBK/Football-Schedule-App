
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolpo/api/api_filter.dart';
import 'package:geolpo/api/auth_api.dart';
import 'package:geolpo/dto/device_dto.dart';
import 'package:http/http.dart' as http;

Future<void> saveUserDeviceAndFcmToken() async {
  final device = await getUserDevice();
  Map<String, String> requestHeader = baseHeader;
  requestHeader['Content-Type'] = 'application/json';
  baseHeader['Authorization'] = 'Bearer ${auth!.accessToken}';
  processResponse(await http.post(Uri.parse('$baseUrl/device'), headers: requestHeader,
      body: jsonEncode(device.toJson())));
}

Future<Device> getUserDevice() async {
  String? platform;
  String? uuid;
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    platform = 'Android';
    uuid = androidInfo.id;
  }
  if (Platform.isIOS) {
    platform = 'IOS';
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    uuid = iosInfo.identifierForVendor;
  }
  return Device(platform: platform!,
      uuid: uuid!,
      fcmToken: fcmToken!);
}
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolpo/api/api_filter.dart';
import 'package:geolpo/dto/device_dto.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../dto/api_user_dto.dart';
import '../dto/auth_dto.dart';

const String baseUrl = 'http://192.168.45.129:8090';
late Auth? auth;
late ApiUser? user;
Map<String, String> baseHeader = {};


Future<void> kakaoLogin() async {
  try {
    bool isInstalled = await isKakaoTalkInstalled();
    OAuthToken kakaoOauth = isInstalled
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();
    final authResponse = await http.get(Uri.parse('$baseUrl/oauth/kakao?token=${kakaoOauth.accessToken}'));
    if (authResponse.statusCode == 200) {
      auth = Auth.fromJson(json.decode(authResponse.body));
    }
    baseHeader['Authorization'] = 'Bearer ${auth!.accessToken}';
    final userInfoResponse = await http.get(Uri.parse('$baseUrl/oauth/me'), headers: baseHeader);
    user = ApiUser.fromJson(json.decode(utf8.decode(userInfoResponse.bodyBytes)));
  } catch (e) {
    //do nothing
  }
}

void reissueToken() async {
  baseHeader['RefreshToken'] = auth!.refreshToken;
  final response = processResponse(await http.post(Uri.parse('$baseUrl/oauth/reissue'), headers: baseHeader));
  auth = Auth.fromJson(json.decode(response.body));
}

Future<void> deleteToken() async {
  baseHeader['RefreshToken'] = auth!.refreshToken;
  processResponse(await http.delete(Uri.parse('$baseUrl/oauth/logout'), headers: baseHeader));
}

Future<void> generateUserDeviceAndFcmToken() async {
  final device = await getUserDevice();
  baseHeader['Authorization'] = 'Bearer ${auth!.accessToken}';
  processResponse(await http.post(Uri.parse('$baseUrl/device'), headers: baseHeader,
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

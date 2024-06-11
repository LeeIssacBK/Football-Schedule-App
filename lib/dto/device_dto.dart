class Device {
  final String platform;
  final String uuid;
  final String fcmToken;

  Device({
    required this.platform,
    required this.uuid,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'uuid': uuid,
      'fcmToken': fcmToken,
    };
  }

}
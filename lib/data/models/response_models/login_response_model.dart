class LoginResponse {
  final bool status;
  final String msg;
  final List<UserData> data;

  LoginResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      data: (json['data'] as List?)
              ?.map((e) => UserData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'msg': msg,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class UserData {
  final dynamic username;
  final String userPic;
  final String enWelcomeMsg;
  final String arWelcomeMsg;
  final String userClient;
  final String tokenId;
  final int isSynchronize;
  final String userRole;
  final double versionNumber;
  final String scanAccess;

  UserData({
    required this.username,
    required this.userPic,
    required this.enWelcomeMsg,
    required this.arWelcomeMsg,
    required this.userClient,
    required this.tokenId,
    required this.isSynchronize,
    required this.userRole,
    required this.versionNumber,
    required this.scanAccess,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      userPic: json['user_pic'] ?? '',
      enWelcomeMsg: json['en_welcome_msg'] ?? '',
      arWelcomeMsg: json['ar_welcome_msg'] ?? '',
      userClient: json['user_client'] ?? '',
      tokenId: json['token_id'] ?? '',
      isSynchronize: json['is_synchronize'] ?? 0,
      userRole: json['user_role'] ?? '',
      versionNumber: (json['version_number'] as num?)?.toDouble() ?? 1.0,
      scanAccess: json['scan_access'] ?? 'N',
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'user_pic': userPic,
        'en_welcome_msg': enWelcomeMsg,
        'ar_welcome_msg': arWelcomeMsg,
        'user_client': userClient,
        'token_id': tokenId,
        'is_synchronize': isSynchronize,
        'user_role': userRole,
        'version_number': versionNumber,
        'scan_access': scanAccess,
      };
}

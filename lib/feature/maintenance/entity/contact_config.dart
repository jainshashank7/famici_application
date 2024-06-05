import 'dart:convert';

ContactConfig contactConfigFromJson(String str) =>
    ContactConfig.fromJson(json.decode(str));

String contactConfigToJson(ContactConfig data) => json.encode(data.toJson());

class ContactConfig {
  ContactConfig({
    this.email = '',
    this.mobile = '',
    this.web = '',
    this.tel = '',
  });

  final String email;
  final String mobile;
  final String web;
  final String tel;

  ContactConfig copyWith({
    String? email,
    String? mobile,
    String? web,
    String? tel,
  }) {
    return ContactConfig(
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      web: web ?? this.web,
      tel: tel ?? this.tel,
    );
  }

  factory ContactConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ContactConfig();
    }
    return ContactConfig(
      email: json["email"],
      mobile: json["mobile"],
      web: json["web"],
      tel: json["tel"],
    );
  }
  Map<String, dynamic> toJson() => {
        "email": email,
        "mobile": mobile,
        "web": web,
        "tel": tel,
      };
}

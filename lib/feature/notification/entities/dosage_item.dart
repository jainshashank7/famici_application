import 'dart:convert';

class DosageItem {
  DosageItem({
    String? detail,
    String? id,
    int? quantity,
    String? time,
  })  : detail = detail ?? '',
        id = id ?? '',
        quantity = quantity ?? 0,
        time = time ?? '';

  final String detail;
  final String id;
  final int quantity;
  final String time;

  DosageItem copyWith({
    String? detail,
    String? id,
    int? quantity,
    String? time,
  }) {
    return DosageItem(
      detail: detail ?? this.detail,
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      time: time ?? this.time,
    );
  }

  factory DosageItem.fromRawJson(String? str) {
    if (str == null) {
      return DosageItem();
    }
    return DosageItem.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory DosageItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DosageItem();
    }

    int _quantity = 0;

    if (json["quantity"].runtimeType == int) {
      _quantity = json["quantity"];
    } else {
      _quantity = int.parse(json["quantity"]);
    }

    return DosageItem(
      detail: json["detail"],
      id: json["id"],
      quantity: _quantity,
      time: json["time"],
    );
  }

  Map<String, dynamic> toJson() => {
        "detail": detail,
        "id": id,
        "quantity": quantity,
        "time": time,
      };
}

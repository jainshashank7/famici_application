import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  Address({
    String? businessStatus,
    String? formattedAddress,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    String? placeId,
    PlusCode? plusCode,
    String? reference,
  })  : businessStatus = businessStatus ?? '',
        formattedAddress = formattedAddress ?? '',
        geometry = geometry ?? Geometry(),
        icon = icon ?? '',
        iconBackgroundColor = iconBackgroundColor ?? '',
        iconMaskBaseUri = iconMaskBaseUri ?? '',
        name = name ?? '',
        placeId = placeId ?? '',
        plusCode = plusCode ?? PlusCode(),
        reference = reference ?? '';

  final String businessStatus;
  final String formattedAddress;
  final Geometry geometry;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String name;
  final String placeId;
  final PlusCode plusCode;
  final String reference;

  Address copyWith({
    String? businessStatus,
    String? formattedAddress,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    String? placeId,
    PlusCode? plusCode,
    String? reference,
  }) {
    return Address(
      businessStatus: businessStatus ?? this.businessStatus,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      geometry: geometry ?? this.geometry,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      plusCode: plusCode ?? this.plusCode,
      reference: reference ?? this.reference,
    );
  }

  factory Address.fromRawJson(String? str) {
    if (str == null) {
      return Address();
    }
    return Address.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  bool get isValid => formattedAddress.isNotEmpty;

  Marker toMarker() => Marker(
        markerId: MarkerId(placeId),
        position: geometry.toLatLng(),
      );

  static List<Address> fromJsonList(List<dynamic>? list) {
    if (list == null) {
      return List.empty();
    }
    return list.map<Address>((e) => Address.fromJson(e)).toList();
  }

  factory Address.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Address();
    }
    return Address(
      businessStatus: json["business_status"],
      formattedAddress: json["formatted_address"],
      geometry: Geometry.fromJson(json["geometry"]),
      icon: json["icon"],
      iconBackgroundColor: json["icon_background_color"],
      iconMaskBaseUri: json["icon_mask_base_uri"],
      name: json["name"],
      placeId: json["place_id"],
      plusCode: PlusCode.fromJson(json["plus_code"]),
      reference: json["reference"],
    );
  }

  Map<String, dynamic> toJson() => {
        "business_status": businessStatus,
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "icon": icon,
        "icon_background_color": iconBackgroundColor,
        "icon_mask_base_uri": iconMaskBaseUri,
        "name": name,
        "place_id": placeId,
        "plus_code": plusCode.toJson(),
        "reference": reference,
      };
}

class Geometry {
  Geometry({
    Location? location,
  }) : location = location ?? Location();

  final Location location;

  Geometry copyWith({
    Location? location,
  }) {
    return Geometry(
      location: location ?? this.location,
    );
  }

  factory Geometry.fromRawJson(String? str) {
    if (str == null) {
      return Geometry();
    }
    return Geometry.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  LatLng toLatLng() => LatLng(location.lat, location.lng);

  factory Geometry.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Geometry();
    }
    return Geometry(
      location: Location.fromJson(json["location"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
      };
}

class Location {
  Location({
    double? lat,
    double? lng,
  })  : lat = lat ?? 0.0,
        lng = lng ?? 0.0;

  final double lat;
  final double lng;

  Location copyWith({
    double? lat,
    double? lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory Location.fromRawJson(String? str) {
    if (str == null) {
      return Location();
    }
    return Location.fromJson(json.decode(str));
  }
  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Location();
    }
    return Location(
      lat: json["lat"].toDouble(),
      lng: json["lng"].toDouble(),
    );
  }
  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class PlusCode {
  PlusCode({
    String? compoundCode,
    String? globalCode,
  })  : compoundCode = compoundCode ?? '',
        globalCode = globalCode ?? '';

  final String compoundCode;
  final String globalCode;

  PlusCode copyWith({
    String? compoundCode,
    String? globalCode,
  }) {
    return PlusCode(
      compoundCode: compoundCode ?? this.compoundCode,
      globalCode: globalCode ?? this.globalCode,
    );
  }

  factory PlusCode.fromRawJson(String? str) {
    if (str == null) {
      return PlusCode();
    }
    return PlusCode.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory PlusCode.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PlusCode();
    }
    return PlusCode(
      compoundCode: json["compound_code"],
      globalCode: json["global_code"],
    );
  }

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

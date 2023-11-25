import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NDPModel {
  String ofc;
  String input;
  String quality;
  String packing;
  String embossing;
  String decoration;
  String coating;
  String printing;
  String frosting;
  String hfs;
  String other;
  String moq;
  String annualRequirement;
  String imgUrl;
  String remarks;
  String uid;
  DateTime dateTime;
  NDPModel({
    required this.ofc,
    required this.input,
    required this.quality,
    required this.packing,
    required this.embossing,
    required this.decoration,
    required this.coating,
    required this.printing,
    required this.frosting,
    required this.hfs,
    required this.other,
    required this.moq,
    required this.annualRequirement,
    required this.imgUrl,
    required this.remarks,
    required this.uid,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ofc': ofc,
      'input': input,
      'quality': quality,
      'packing': packing,
      'embossing': embossing,
      'decoration': decoration,
      'coating': coating,
      'printing': printing,
      'frosting': frosting,
      'hfs': hfs,
      'other': other,
      'moq': moq,
      'annualRequirement': annualRequirement,
      'imgUrl': imgUrl,
      'remarks': remarks,
      'uid': uid,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory NDPModel.fromMap(Map<String, dynamic> map) {
    return NDPModel(
      ofc: map['ofc'] as String,
      input: map['input'] as String,
      quality: map['quality'] as String,
      packing: map['packing'] as String,
      embossing: map['embossing'] as String,
      decoration: map['decoration'] as String,
      coating: map['coating'] as String,
      printing: map['printing'] as String,
      frosting: map['frosting'] as String,
      hfs: map['hfs'] as String,
      other: map['other'] as String,
      moq: map['moq'] as String,
      annualRequirement: map['annualRequirement'] as String,
      imgUrl: map['imgUrl'] as String,
      remarks: map['remarks'] as String,
      uid: map['uid'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory NDPModel.fromJson(String source) => NDPModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

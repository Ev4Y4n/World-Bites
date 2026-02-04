import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Country{

  @JsonKey(required: true)
  final String id;
  final String name;
  final String plate;
  final String flag;

  Country(this.id, this.name, this.plate, this.flag);

  Country.fromJson(Map<String, dynamic> json)
    :id = json['id'] as String,
    name = json['name'] as String,
    plate = json['plate'] as String,
    flag = json['flag'] as String;

    Map<String, dynamic> toJson() => {'id': id, 'name': name, 'plate': plate, 'flag':flag};

}
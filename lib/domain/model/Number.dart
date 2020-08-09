import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Number.g.dart';

@HiveType(typeId: 0)
class Number {
  @HiveField(0)
  final int number;
  @HiveField(1)
  final String text;

  Number({
    @required this.number,
    @required this.text,
  });

  factory Number.fromMap(Map<String, dynamic> map) {
    return Number(
      number: map['number'],
      text: map['text'],
    );
  }

  @override
  String toString() {
    return 'Number: $number \nText: $text';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Number && o.number == number && o.text == text;
  }

  @override
  int get hashCode => number.hashCode ^ text.hashCode;
}

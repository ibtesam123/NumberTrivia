// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Number.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NumberAdapter extends TypeAdapter<Number> {
  @override
  final int typeId = 0;

  @override
  Number read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Number(
      number: fields[0] as int,
      text: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Number obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

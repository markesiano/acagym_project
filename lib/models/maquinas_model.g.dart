// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maquinas_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaquinasModelAdapter extends TypeAdapter<MaquinasModel> {
  @override
  final int typeId = 2;

  @override
  MaquinasModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaquinasModel(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
      qr: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MaquinasModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.qr);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaquinasModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

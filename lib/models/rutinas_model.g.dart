// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rutinas_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RutinasModelAdapter extends TypeAdapter<RutinasModel> {
  @override
  final int typeId = 0;

  @override
  RutinasModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RutinasModel(
      id: fields[0] as String,
      name: fields[1] as String,
      ejercicios: (fields[2] as List).cast<EjerciciosModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, RutinasModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ejercicios);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RutinasModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ejercicios_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EjerciciosModelAdapter extends TypeAdapter<EjerciciosModel> {
  @override
  final int typeId = 1;

  @override
  EjerciciosModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EjerciciosModel(
      id: fields[0] as String,
      name: fields[1] as String,
      repeticiones: fields[2] as int,
      series: fields[3] as int,
      peso: fields[4] as int?,
      musculos: (fields[5] as List).cast<String>(),
      maquina: fields[6] as MaquinasModel?,
    );
  }

  @override
  void write(BinaryWriter writer, EjerciciosModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.repeticiones)
      ..writeByte(3)
      ..write(obj.series)
      ..writeByte(4)
      ..write(obj.peso)
      ..writeByte(5)
      ..write(obj.musculos)
      ..writeByte(6)
      ..write(obj.maquina);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EjerciciosModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

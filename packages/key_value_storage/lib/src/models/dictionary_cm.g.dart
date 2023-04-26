// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DictionaryCMAdapter extends TypeAdapter<DictionaryCM> {
  @override
  final int typeId = 0;

  @override
  DictionaryCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DictionaryCM(
      dictionaryName: fields[0] as String,
      indexLanguage: fields[1] as String,
      contentLanguage: fields[2] as String,
      entriesNumber: fields[4] as int,
      active: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DictionaryCM obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dictionaryName)
      ..writeByte(1)
      ..write(obj.indexLanguage)
      ..writeByte(2)
      ..write(obj.contentLanguage)
      ..writeByte(3)
      ..write(obj.active)
      ..writeByte(4)
      ..write(obj.entriesNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DictionaryCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

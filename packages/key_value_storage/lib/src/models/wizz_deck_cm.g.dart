// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wizz_deck_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WizzDeckCMAdapter extends TypeAdapter<WizzDeckCM> {
  @override
  final int typeId = 1;

  @override
  WizzDeckCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WizzDeckCM(
      translateFromLanguage: fields[0] as String,
      translateToLanguage: fields[1] as String,
      cardsList: (fields[2] as List).cast<WizzCardCM>(),
    );
  }

  @override
  void write(BinaryWriter writer, WizzDeckCM obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.translateFromLanguage)
      ..writeByte(1)
      ..write(obj.translateToLanguage)
      ..writeByte(2)
      ..write(obj.cardsList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WizzDeckCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WizzCardCMAdapter extends TypeAdapter<WizzCardCM> {
  @override
  final int typeId = 2;

  @override
  WizzCardCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WizzCardCM(
      headword: fields[0] as String,
      translations: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WizzCardCM obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.headword)
      ..writeByte(1)
      ..write(obj.translations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WizzCardCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

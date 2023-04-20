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
      sessionNumber: fields[4] as int,
      name: fields[0] as String,
      fromLanguage: fields[1] as String,
      toLanguage: fields[2] as String,
      cards: (fields[3] as List).cast<WizzCardCM>(),
    );
  }

  @override
  void write(BinaryWriter writer, WizzDeckCM obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.fromLanguage)
      ..writeByte(2)
      ..write(obj.toLanguage)
      ..writeByte(3)
      ..write(obj.cards)
      ..writeByte(4)
      ..write(obj.sessionNumber);
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
      word: fields[0] as String,
      meaning: fields[1] as String,
      examples: fields[2] as String?,
      fullText: fields[3] as String?,
      level: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WizzCardCM obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.meaning)
      ..writeByte(2)
      ..write(obj.examples)
      ..writeByte(3)
      ..write(obj.fullText)
      ..writeByte(4)
      ..write(obj.level);
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

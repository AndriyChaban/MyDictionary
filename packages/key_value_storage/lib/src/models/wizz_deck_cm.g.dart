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
      name: fields[0] as String,
      fromLanguage: fields[1] as String,
      toLanguage: fields[2] as String,
      cards: (fields[3] as List).cast<WizzCardCM>(),
    );
  }

  @override
  void write(BinaryWriter writer, WizzDeckCM obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.fromLanguage)
      ..writeByte(2)
      ..write(obj.toLanguage)
      ..writeByte(3)
      ..write(obj.cards);
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
      showFrequency: fields[4] as ShowFrequencyCM?,
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
      ..write(obj.showFrequency);
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

class ShowFrequencyCMAdapter extends TypeAdapter<ShowFrequencyCM> {
  @override
  final int typeId = 7;

  @override
  ShowFrequencyCM read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ShowFrequencyCM.low;
      case 1:
        return ShowFrequencyCM.normal;
      case 2:
        return ShowFrequencyCM.high;
      default:
        return ShowFrequencyCM.low;
    }
  }

  @override
  void write(BinaryWriter writer, ShowFrequencyCM obj) {
    switch (obj) {
      case ShowFrequencyCM.low:
        writer.writeByte(0);
        break;
      case ShowFrequencyCM.normal:
        writer.writeByte(1);
        break;
      case ShowFrequencyCM.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowFrequencyCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryDictionaryCMAdapter extends TypeAdapter<HistoryDictionaryCM> {
  @override
  final int typeId = 5;

  @override
  HistoryDictionaryCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryDictionaryCM(
      languageFrom: fields[0] as String,
      languageTo: fields[1] as String,
      cards: (fields[2] as List).cast<HistoryCardCM>(),
    );
  }

  @override
  void write(BinaryWriter writer, HistoryDictionaryCM obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.languageFrom)
      ..writeByte(1)
      ..write(obj.languageTo)
      ..writeByte(2)
      ..write(obj.cards);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryDictionaryCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HistoryCardCMAdapter extends TypeAdapter<HistoryCardCM> {
  @override
  final int typeId = 6;

  @override
  HistoryCardCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryCardCM(
      headword: fields[0] as String,
      text: fields[1] as String,
      dictionaryName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryCardCM obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.headword)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.dictionaryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryCardCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

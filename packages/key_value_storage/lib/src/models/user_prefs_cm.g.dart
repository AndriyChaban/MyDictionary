// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_prefs_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPrefsCMAdapter extends TypeAdapter<UserPrefsCM> {
  @override
  final int typeId = 3;

  @override
  UserPrefsCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPrefsCM(
      translateFromLanguage: fields[0] as String?,
      translateToLanguage: fields[1] as String?,
      darkMode: fields[2] as DarkModeCM,
      appLanguage: fields[3] as AppLanguageCM,
      fontSize: fields[4] as int,
      isPasteFromClipboard: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPrefsCM obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.translateFromLanguage)
      ..writeByte(1)
      ..write(obj.translateToLanguage)
      ..writeByte(2)
      ..write(obj.darkMode)
      ..writeByte(3)
      ..write(obj.appLanguage)
      ..writeByte(4)
      ..write(obj.fontSize)
      ..writeByte(5)
      ..write(obj.isPasteFromClipboard);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPrefsCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DarkModeCMAdapter extends TypeAdapter<DarkModeCM> {
  @override
  final int typeId = 4;

  @override
  DarkModeCM read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DarkModeCM.systemSettings;
      case 1:
        return DarkModeCM.alwaysLight;
      case 2:
        return DarkModeCM.alwaysDark;
      default:
        return DarkModeCM.systemSettings;
    }
  }

  @override
  void write(BinaryWriter writer, DarkModeCM obj) {
    switch (obj) {
      case DarkModeCM.systemSettings:
        writer.writeByte(0);
        break;
      case DarkModeCM.alwaysLight:
        writer.writeByte(1);
        break;
      case DarkModeCM.alwaysDark:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DarkModeCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppLanguageCMAdapter extends TypeAdapter<AppLanguageCM> {
  @override
  final int typeId = 7;

  @override
  AppLanguageCM read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppLanguageCM.english;
      case 1:
        return AppLanguageCM.spanish;
      case 2:
        return AppLanguageCM.french;
      case 3:
        return AppLanguageCM.ukrainian;
      case 4:
        return AppLanguageCM.russian;
      default:
        return AppLanguageCM.english;
    }
  }

  @override
  void write(BinaryWriter writer, AppLanguageCM obj) {
    switch (obj) {
      case AppLanguageCM.english:
        writer.writeByte(0);
        break;
      case AppLanguageCM.spanish:
        writer.writeByte(1);
        break;
      case AppLanguageCM.french:
        writer.writeByte(2);
        break;
      case AppLanguageCM.ukrainian:
        writer.writeByte(3);
        break;
      case AppLanguageCM.russian:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLanguageCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

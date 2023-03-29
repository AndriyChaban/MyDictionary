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
    return UserPrefsCM();
  }

  @override
  void write(BinaryWriter writer, UserPrefsCM obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.translateFromLanguage)
      ..writeByte(1)
      ..write(obj.translateToLanguage)
      ..writeByte(2)
      ..write(obj.darkMode);
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteCharacterAdapter extends TypeAdapter<FavoriteCharacter> {
  @override
  final int typeId = 1;

  @override
  FavoriteCharacter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteCharacter(
      fields[0] as CharacterModel,
      fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteCharacter obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.characterModel)
      ..writeByte(1)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteCharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

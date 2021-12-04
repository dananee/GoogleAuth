// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteAdapter extends TypeAdapter<Favorite> {
  @override
  final int typeId = 0;

  @override
  Favorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorite(
      title: fields[0] as String,
      image: fields[1] as String,
      description: (fields[2] as List).cast<String>(),
      tags: (fields[3] as List).cast<String>(),
      state: fields[5] as String,
      rating: fields[6] as String,
      creator: fields[7] as String,
      author: fields[4] as String,
      release: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Favorite obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.author)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.creator)
      ..writeByte(8)
      ..write(obj.release);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

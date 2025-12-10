// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavItemAdapter extends TypeAdapter<FavItem> {
  @override
  final int typeId = 2;

  @override
  FavItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavItem(
      name: fields[0] as String,
      category: fields[1] as String,
      iconName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.iconName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

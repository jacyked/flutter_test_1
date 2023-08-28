// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wordle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************
//TODO remove
class WordleAdapter extends TypeAdapter<Wordle> {
  @override
  final int typeId = 1;

  @override
  Wordle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wordle(
      word: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Wordle obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.word);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

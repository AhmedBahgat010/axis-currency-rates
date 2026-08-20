// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExchangeRateHiveAdapter extends TypeAdapter<ExchangeRateHive> {
  @override
  final int typeId = 0;

  @override
  ExchangeRateHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExchangeRateHive()
      ..code = fields[0] as String
      ..name = fields[1] as String
      ..flag = fields[2] as String
      ..rate = fields[3] as double
      ..change = fields[4] as double
      ..percentageChange = fields[5] as double
      ..isStrengthening = fields[6] as bool
      ..sparklineData = (fields[7] as List).cast<double>()
      ..lastUpdated = fields[8] as DateTime
      ..cachedAt = fields[9] as DateTime;
  }

  @override
  void write(BinaryWriter writer, ExchangeRateHive obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.flag)
      ..writeByte(3)
      ..write(obj.rate)
      ..writeByte(4)
      ..write(obj.change)
      ..writeByte(5)
      ..write(obj.percentageChange)
      ..writeByte(6)
      ..write(obj.isStrengthening)
      ..writeByte(7)
      ..write(obj.sparklineData)
      ..writeByte(8)
      ..write(obj.lastUpdated)
      ..writeByte(9)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExchangeRateHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

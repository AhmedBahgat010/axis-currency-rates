import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  final int? code;

  ApiErrorModel({required this.message, this.code});
}

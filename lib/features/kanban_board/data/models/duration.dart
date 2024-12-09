import 'package:json_annotation/json_annotation.dart';

part 'duration.g.dart';

@JsonSerializable(createToJson: false)
class DurationData {
  final int? amount;
  final String? unit;

  DurationData({this.amount, this.unit});

  factory DurationData.fromJson(Map<String, dynamic> json) =>
      _$DurationDataFromJson(json);
}

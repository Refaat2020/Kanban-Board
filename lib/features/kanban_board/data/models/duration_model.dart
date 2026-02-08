import 'package:json_annotation/json_annotation.dart';
import 'package:kanban_board/features/kanban_board/domain/entities/duration.dart';

part 'duration_model.g.dart';

@JsonSerializable(createToJson: false)
class DurationDataModel extends DurationData {
  const DurationDataModel({
    super.amount,
    super.unit,
  });

  factory DurationDataModel.fromJson(Map<String, dynamic> json) =>
      _$DurationDataModelFromJson(json);
}

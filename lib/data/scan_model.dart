import 'package:equatable/equatable.dart';
import 'package:missible/common/app_extensions.dart';
import 'package:missible/common/app_typedefs.dart';

class ScanModel extends Equatable {
  final String content;
  final DateTime dateTime;

  const ScanModel({required this.content, required this.dateTime});

  factory ScanModel.fromJson(JsonMap jsonMap) => ScanModel(
        content: jsonMap.getString('content'),
        dateTime: DateTime.parse((jsonMap.getString('dateTime'))),
      );

  @override
  List<Object?> get props => [content, dateTime];

  JsonMap toJson() => {
        'content': content,
        'dateTime': dateTime.toString(),
      };
}

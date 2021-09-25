import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Recipe extends Equatable {
  const Recipe({required this.id, required this.name,  required this.currentTime});
  final String id;
  final String name;
  final DateTime currentTime;

  @override
  List<Object> get props => [id, name, currentTime];

  @override
  bool get stringify => true;

  factory Recipe.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for recipeId: $documentId');
    }
    final name = data['name'] as String?;
    if (name == null) {
      throw StateError('missing name for recipeId: $documentId');
    }
    final ratePerHour = data['ratePerHour'] as int;
    final currentTime = data['currentTime'] as int;
    return Recipe(id: documentId, name: name, currentTime: DateTime.fromMillisecondsSinceEpoch(currentTime));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'currentTime': currentTime.millisecondsSinceEpoch,
    };
  }
}

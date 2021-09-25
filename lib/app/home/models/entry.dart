import 'package:equatable/equatable.dart';

class Entry extends Equatable {
  const Entry({
    required this.id,
    required this.recipeId,
    required this.recipeTime,
    required this.servingNum,
    required this.calories,
    required this.foodName,
  });

  final String id;
  final String recipeId;
  final DateTime recipeTime;
  final double servingNum;
  final double calories;
  final String foodName;

  @override
  List<Object> get props =>
      [id, recipeId, recipeTime, servingNum, calories, foodName];

  @override
  bool get stringify => true;

  factory Entry.fromMap(Map<dynamic, dynamic>? value, String id) {
    if (value == null) {
      throw StateError('missing data for entryId: $id');
    }
    return Entry(
      id: id,
      recipeId: value['recipeId'] as String,
      recipeTime:
          DateTime.fromMillisecondsSinceEpoch(value['recipeTime'] as int),
      servingNum: value['servingNum'] as double,
      calories: value['calories'] as double,
      foodName: value['foodName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recipeId': recipeId,
      'recipeTime': recipeTime.millisecondsSinceEpoch,
      'servingNum': servingNum,
      'calories': calories,
      'foodName': foodName,
    };
  }
}

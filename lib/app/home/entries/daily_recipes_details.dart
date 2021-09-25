import 'package:starter_architecture_flutter_firebase/app/home/entries/entry_recipe.dart';

class RecipeDetails {
  RecipeDetails({
    required this.name,
    required this.calories,
  });
  final String name;
  double calories;
}

class DailyRecipesDetails {
  DailyRecipesDetails({required this.date, required this.recipesDetails});
  final DateTime date;
  final List<RecipeDetails> recipesDetails;

  double get calories => recipesDetails
      .map((recipeDuration) => recipeDuration.calories)
      .reduce((value, element) => value + element);

  /// splits all entries into separate groups by date
  static Map<DateTime, List<EntryRecipe>> _entriesByDate(
      List<EntryRecipe> entries) {
    final Map<DateTime, List<EntryRecipe>> map = {};
    for (final entryRecipe in entries) {
      final entryDayStart = DateTime(entryRecipe.entry.recipeTime.year,
          entryRecipe.entry.recipeTime.month, entryRecipe.entry.recipeTime.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryRecipe];
      } else {
        map[entryDayStart]!.add(entryRecipe);
      }
    }
    return map;
  }

  static List<DailyRecipesDetails> all(List<EntryRecipe> entries) {
    final byDate = _entriesByDate(entries);
    final List<DailyRecipesDetails> list = [];
    for (final pair in byDate.entries) {
      final date = pair.key;
      final entriesByDate = pair.value;
      final byRecipe = _recipesDetails(entriesByDate);
      list.add(DailyRecipesDetails(date: date, recipesDetails: byRecipe));
    }
    return list.toList();
  }

  /// groups entries by recipe
  static List<RecipeDetails> _recipesDetails(List<EntryRecipe> entries) {
    final Map<String, RecipeDetails> recipeDuration = {};
    for (final entryRecipe in entries) {
      final entry = entryRecipe.entry;
      if (recipeDuration[entry.recipeId] == null) {
        recipeDuration[entry.recipeId] = RecipeDetails(
          name: entryRecipe.recipe.name,
          calories: entry.calories,
        );
      } else {
        recipeDuration[entry.recipeId]!.calories += entry.calories;
      }
    }
    return recipeDuration.values.toList();
  }
}

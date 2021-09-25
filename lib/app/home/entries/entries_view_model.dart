import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:starter_architecture_flutter_firebase/app/home/entries/daily_recipes_details.dart';
import 'package:starter_architecture_flutter_firebase/app/home/entries/entries_list_tile.dart';
import 'package:starter_architecture_flutter_firebase/app/home/entries/entry_recipe.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipe_entries/format.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';

class EntriesViewModel {
  EntriesViewModel({required this.database});
  final FirestoreDatabase database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  Stream<List<EntryRecipe>> get _allEntriesStream => CombineLatestStream.combine2(
        database.entriesStream(),
        database.recipesStream(),
        _entriesRecipesCombiner,
      );

  static List<EntryRecipe> _entriesRecipesCombiner(
      List<Entry> entries, List<Recipe> recipes) {
    return entries.map((entry) {
      final recipe = recipes.firstWhere((recipe) => recipe.id == entry.recipeId);
      return EntryRecipe(entry, recipe);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryRecipe> allEntries) {
    if (allEntries.isEmpty) {
      return [];
    }
    final allDailyRecipesDetails = DailyRecipesDetails.all(allEntries);

    // // total duration across all jobs
    // final totalDuration = allDailyRecipesDetails
    //     .map((dateRecipesDuration) => dateRecipesDuration.duration)
    //     .reduce((value, element) => value + element);
    //
    // // total pay across all jobs
    // final totalPay = allDailyRecipesDetails
    //     .map((dateRecipesDuration) => dateRecipesDuration.pay)
    //     .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      // EntriesListTileModel(
      //   leadingText: 'All Entries',
      //   middleText: Format.currency(totalPay),
      //   trailingText: Format.hours(totalDuration),
      // ),
      for (DailyRecipesDetails dailyRecipesDetails in allDailyRecipesDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyRecipesDetails.date),
          // middleText: Format.currency(dailyRecipesDetails.pay),
          trailingText: dailyRecipesDetails.calories.toString()+ " Cal",
        ),
        for (RecipeDetails recipeDuration in dailyRecipesDetails.recipesDetails)
          EntriesListTileModel(
            leadingText: recipeDuration.name,
            // middleText: Format.currency(recipeDuration.pay),
            trailingText: recipeDuration.calories.toString()+ " Cal",
          ),
      ]
    ];
  }
}

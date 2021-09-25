import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipe_entries/recipe_entries_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipes/edit_recipe_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipes/recipe_list_tile.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipes/list_items_builder.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:starter_architecture_flutter_firebase/app/top_level_providers.dart';
import 'package:starter_architecture_flutter_firebase/constants/strings.dart';
import 'package:pedantic/pedantic.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';

final recipesStreamProvider = StreamProvider.autoDispose<List<Recipe>>((ref) {
  final database = ref.watch(databaseProvider)!;
  return database.recipesStream();
});

// watch database
class RecipesPage extends ConsumerWidget {
  Future<void> _delete(
      BuildContext context, WidgetRef ref, Recipe recipe) async {
    try {
      final database = ref.read<FirestoreDatabase?>(databaseProvider)!;
      await database.deleteJob(recipe);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.recipes),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => EditRecipePage.show(context),
          ),
        ],
      ),
      body: _buildContents(context, ref),
    );
  }

  Widget _buildContents(BuildContext context, WidgetRef ref) {
    final recipesAsyncValue = ref.watch(recipesStreamProvider);
    return ListItemsBuilder<Recipe>(
      data: recipesAsyncValue,
      itemBuilder: (context, recipe) => Dismissible(
        key: Key('recipe-${recipe.id}'),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => _delete(context, ref, recipe),
        child: RecipeListTile(
          recipe: recipe,
          onTap: () => RecipeEntriesPage.show(context, recipe),
        ),
      ),
    );
  }
}

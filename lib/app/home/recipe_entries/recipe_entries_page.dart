import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipe_entries/entry_list_item.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipe_entries/entry_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipes/edit_recipe_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipes/list_items_builder.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:starter_architecture_flutter_firebase/app/top_level_providers.dart';
import 'package:starter_architecture_flutter_firebase/routing/cupertino_tab_view_router.dart';
import 'package:pedantic/pedantic.dart';

class RecipeEntriesPage extends StatelessWidget {
  const RecipeEntriesPage({required this.recipe});
  final Recipe recipe;

  static Future<void> show(BuildContext context, Recipe recipe) async {
    await Navigator.of(context).pushNamed(
      CupertinoTabViewRoutes.recipeEntriesPage,
      arguments: recipe,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: RecipeEntriesAppBarTitle(recipe: recipe),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => EditRecipePage.show(
              context,
              recipe: recipe,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => EntryPage.show(
              context: context,
              recipe: recipe,
            ),
          ),
        ],
      ),
      body: RecipeEntriesContents(recipe: recipe),
    );
  }
}

final recipeStreamProvider =
    StreamProvider.autoDispose.family<Recipe, String>((ref, recipeId) {
  final database = ref.watch(databaseProvider)!;
  return database.recipeStream(recipeId: recipeId);
});

class RecipeEntriesAppBarTitle extends ConsumerWidget {
  const RecipeEntriesAppBarTitle({required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsyncValue = ref.watch(recipeStreamProvider(recipe.id));
    return recipeAsyncValue.when(
      data: (recipe) => Text(recipe.name),
      loading: () => Container(),
      error: (_, __) => Container(),
    );
  }
}

final recipeEntriesStreamProvider =
    StreamProvider.autoDispose.family<List<Entry>, Recipe>((ref, recipe) {
  final database = ref.watch(databaseProvider)!;
  return database.entriesStream(recipe: recipe);
});

class RecipeEntriesContents extends ConsumerWidget {
  final Recipe recipe;
  const RecipeEntriesContents({required this.recipe});

  Future<void> _deleteEntry(
      BuildContext context, WidgetRef ref, Entry entry) async {
    try {
      final database = ref.read(databaseProvider)!;
      await database.deleteEntry(entry);
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
    final entriesStream = ref.watch(recipeEntriesStreamProvider(recipe));
    return ListItemsBuilder<Entry>(
      data: entriesStream,
      itemBuilder: (context, entry) {
        return DismissibleEntryListItem(
          dismissibleKey: Key('entry-${entry.id}'),
          entry: entry,
          recipe: recipe,
          onDismissed: () => _deleteEntry(context, ref, entry),
          onTap: () => EntryPage.show(
            context: context,
            recipe: recipe,
            entry: entry,
          ),
        );
      },
    );
  }
}

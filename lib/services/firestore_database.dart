import 'dart:async';

import 'package:firestore_service/firestore_service.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_path.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setRecipe(Recipe recipe) => _service.setData(
        path: FirestorePath.recipe(uid, recipe.id),
        data: recipe.toMap(),
      );

  Future<void> deleteRecipe(Recipe recipe) async {
    final allEntries = await entriesStream(recipe: recipe).first;
    for (final entry in allEntries) {
      if (entry.recipeId == recipe.id) {
        await deleteEntry(entry);
      }
    }
    await _service.deleteData(path: FirestorePath.recipe(uid, recipe.id));
  }

  Stream<Recipe> recipeStream({required String recipeId}) => _service.documentStream(
        path: FirestorePath.recipe(uid, recipeId),
        builder: (data, documentId) => Recipe.fromMap(data, documentId),
      );

  Stream<List<Recipe>> recipesStream() => _service.collectionStream(
        path: FirestorePath.recipes(uid),
        builder: (data, documentId) => Recipe.fromMap(data, documentId),
      );

  Future<void> setEntry(Entry entry) => _service.setData(
        path: FirestorePath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  Future<void> deleteEntry(Entry entry) =>
      _service.deleteData(path: FirestorePath.entry(uid, entry.id));

  Stream<List<Entry>> entriesStream({Recipe? recipe}) =>
      _service.collectionStream<Entry>(
        path: FirestorePath.entries(uid),
        queryBuilder: recipe != null
            ? (query) => query.where('recipeId', isEqualTo: recipe.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        // sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}

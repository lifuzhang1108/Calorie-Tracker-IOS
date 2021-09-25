import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipe_entries/format.dart';

class RecipeListTile extends StatelessWidget {
  const RecipeListTile({Key? key, required this.recipe, this.onTap})
      : super(key: key);
  final Recipe recipe;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(Format.date(recipe.currentTime)+"          "+recipe.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

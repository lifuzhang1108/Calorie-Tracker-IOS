import 'package:flutter/cupertino.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipe_entries/recipe_entries_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';

class CupertinoTabViewRoutes {
  static const recipeEntriesPage = '/recipe-entries-page';
}

class CupertinoTabViewRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CupertinoTabViewRoutes.recipeEntriesPage:
        final recipe = settings.arguments as Recipe;
        return CupertinoPageRoute(
          builder: (_) => RecipeEntriesPage(recipe: recipe),
          settings: settings,
          fullscreenDialog: false,
        );
    }
    return null;
  }
}

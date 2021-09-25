import 'package:email_password_sign_in_ui/email_password_sign_in_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipe_entries/entry_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipes/edit_recipe_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';

class AppRoutes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  static const editRecipePage = '/edit-recipe-page';
  static const entryPage = '/entry-page';
  static const cameraPage = '/camera-page';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.emailPasswordSignInPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPage.withFirebaseAuth(firebaseAuth,
              onSignedIn: args as void Function()),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.editRecipePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditRecipePage(recipe: args as Recipe?),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.entryPage:
        final mapArgs = args as Map<String, dynamic>;
        final recipe = mapArgs['recipe'] as Recipe;
        final entry = mapArgs['entry'] as Entry?;
        return MaterialPageRoute<dynamic>(
          builder: (_) => EntryPage(recipe: recipe, entry: entry),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}

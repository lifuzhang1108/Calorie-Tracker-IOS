class FirestorePath {
  static String recipe(String uid, String recipeId) => 'users/$uid/recipes/$recipeId';
  static String recipes(String uid) => 'users/$uid/recipes';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
}

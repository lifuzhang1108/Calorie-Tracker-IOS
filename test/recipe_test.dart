import 'package:flutter_test/flutter_test.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      expect(
          () => Recipe.fromMap(null, 'abc'), throwsA(isInstanceOf<StateError>()));
    });
    test('recipe with all properties', () {
      final recipe = Recipe.fromMap(const {
        'name': 'Blogging',
        'ratePerHour': 10,
      }, 'abc');
      expect(recipe, const Recipe(id:"id", name: 'Blogging'));
    });

    test('missing name', () {
      expect(
          () => Recipe.fromMap(const {
                'ratePerHour': 10,
              }, 'abc'),
          throwsA(isInstanceOf<StateError>()));
    });
  });

  group('toMap', () {
    test('valid name, ratePerHour', () {
      const recipe = Recipe(name: 'Blogging', ratePerHour: 10, id: 'abc');
      expect(recipe.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
      });
    });
  });

  group('equality', () {
    test('different properties, equality returns false', () {
      const recipe1 = Recipe(name: 'Blogging', ratePerHour: 10, id: 'abc');
      const recipe2 = Recipe(name: 'Blogging', ratePerHour: 5, id: 'abc');
      expect(recipe1 == recipe2, false);
    });
    test('same properties, equality returns true', () {
      const recipe1 = Recipe(name: 'Blogging', ratePerHour: 10, id: 'abc');
      const recipe2 = Recipe(name: 'Blogging', ratePerHour: 10, id: 'abc');
      expect(recipe1 == recipe2, true);
    });
  });
}

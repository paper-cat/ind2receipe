import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/models/ingredient.dart';

class IsarService {
  static Isar? _isar;

  static Future<Isar> getInstance() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [RecipeSchema, IngredientSchema],
      directory: dir.path,
    );

    return _isar!;
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}

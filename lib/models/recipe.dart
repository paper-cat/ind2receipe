import 'package:isar/isar.dart';

part 'recipe.g.dart';

enum DifficultyLevel {
  easy,
  medium,
  hard,
}

enum RecipeCategory {
  korean,    // 한식
  chinese,   // 중식
  japanese,  // 일식
  western,   // 양식
  asian,     // 아시안
  dessert,   // 디저트
  snack,     // 간식
  beverage,  // 음료
  salad,     // 샐러드
  soup,      // 국/찌개/탕
}

extension RecipeCategoryExtension on RecipeCategory {
  String get displayName {
    switch (this) {
      case RecipeCategory.korean:
        return '한식';
      case RecipeCategory.chinese:
        return '중식';
      case RecipeCategory.japanese:
        return '일식';
      case RecipeCategory.western:
        return '양식';
      case RecipeCategory.asian:
        return '아시안';
      case RecipeCategory.dessert:
        return '디저트';
      case RecipeCategory.snack:
        return '간식';
      case RecipeCategory.beverage:
        return '음료';
      case RecipeCategory.salad:
        return '샐러드';
      case RecipeCategory.soup:
        return '국/찌개/탕';
    }
  }
}

@collection
class Recipe {
  Id id = Isar.autoIncrement;

  // 기본 정보
  late String name;
  String? description;

  // 조리 정보
  int? servings;
  int? cookingTimeMinutes;

  @enumerated
  late DifficultyLevel difficulty;

  // 재료 및 조리법
  late List<String> ingredientIds;
  late List<String> ingredientAmounts;
  late List<String> steps;

  // 카테고리 및 태그
  late List<String> categories;
  late List<String> tags;

  // 메타데이터
  late DateTime createdAt;
  late DateTime updatedAt;

  // 검색 인덱스
  @Index()
  late List<String> ingredientIdsIndex;

  @Index()
  late List<String> categoriesIndex;

  @Index()
  late List<String> tagsIndex;

  // 즐겨찾기
  @Index()
  bool isFavorite = false;

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'servings': servings,
      'cookingTimeMinutes': cookingTimeMinutes,
      'difficulty': difficulty.name,
      'ingredientIds': ingredientIds,
      'ingredientAmounts': ingredientAmounts,
      'steps': steps,
      'categories': categories,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  static Recipe fromJson(Map<String, dynamic> json) {
    return Recipe()
      ..id = json['id'] ?? Isar.autoIncrement
      ..name = json['name']
      ..description = json['description']
      ..servings = json['servings']
      ..cookingTimeMinutes = json['cookingTimeMinutes']
      ..difficulty = DifficultyLevel.values.byName(json['difficulty'])
      ..ingredientIds = List<String>.from(json['ingredientIds'])
      ..ingredientAmounts = List<String>.from(json['ingredientAmounts'])
      ..steps = List<String>.from(json['steps'])
      ..categories = List<String>.from(json['categories'])
      ..tags = List<String>.from(json['tags'])
      ..createdAt = DateTime.parse(json['createdAt'])
      ..updatedAt = DateTime.parse(json['updatedAt'])
      ..isFavorite = json['isFavorite'] ?? false
      // 인덱스는 자동 생성
      ..ingredientIdsIndex = List<String>.from(json['ingredientIds'])
      ..categoriesIndex = List<String>.from(json['categories'])
      ..tagsIndex = List<String>.from(json['tags']);
  }
}

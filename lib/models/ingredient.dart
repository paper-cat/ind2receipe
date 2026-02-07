import 'package:isar/isar.dart';

part 'ingredient.g.dart';

@collection
class Ingredient {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String normalizedName;

  late String displayName;

  int usageCount = 0;

  late DateTime createdAt;
  late DateTime updatedAt;

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'normalizedName': normalizedName,
      'displayName': displayName,
      'usageCount': usageCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static Ingredient fromJson(Map<String, dynamic> json) {
    return Ingredient()
      ..id = json['id'] ?? Isar.autoIncrement
      ..normalizedName = json['normalizedName']
      ..displayName = json['displayName']
      ..usageCount = json['usageCount'] ?? 0
      ..createdAt = DateTime.parse(json['createdAt'])
      ..updatedAt = DateTime.parse(json['updatedAt']);
  }
}

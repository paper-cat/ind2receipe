import 'dart:convert';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:idg2recipes/models/recipe.dart';
import 'package:idg2recipes/models/ingredient.dart';

class BackupService {
  final Isar isar;

  BackupService(this.isar);

  // 플랫폼별 최적 저장 디렉토리 결정
  Future<Directory?> _getBackupDirectory() async {
    if (kIsWeb) {
      return null; // 웹은 파일 시스템 접근 불가
    }

    // Desktop 플랫폼: Downloads 폴더
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      try {
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir != null) {
          return downloadsDir;
        }
      } catch (e) {
        print('⚠️ Downloads 폴더 접근 실패: $e');
      }
    }

    // Fallback: Documents 폴더
    return await getApplicationDocumentsDirectory();
  }

  // 데이터 내보내기
  Future<File> exportToJson() async {
    final recipes = await isar.recipes.where().findAll();
    final ingredients = await isar.ingredients.where().findAll();

    final data = {
      'version': '1.0.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'recipesCount': recipes.length,
      'ingredientsCount': ingredients.length,
      'recipes': recipes.map((r) => r.toJson()).toList(),
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'backup_$timestamp.json';

    // 모바일: 임시 디렉토리에 저장 (settings_screen에서 Share로 공유)
    if (Platform.isAndroid || Platform.isIOS) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}${Platform.pathSeparator}$fileName');
      await file.writeAsString(jsonString);
      return file;
    }

    // Desktop: Downloads 폴더에 자동 저장
    final directory = await _getBackupDirectory();
    if (directory == null) {
      throw Exception('저장 위치를 찾을 수 없습니다.');
    }

    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    await file.writeAsString(jsonString);
    return file;
  }

  // 데이터 불러오기 (덮어쓰기)
  Future<ImportResult> importFromJson(File file) async {
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    // 버전 체크
    if (data['version'] != '1.0.0') {
      throw Exception('지원하지 않는 백업 버전입니다: ${data['version']}');
    }

    int recipesImported = 0;
    int ingredientsImported = 0;

    await isar.writeTxn(() async {
      // 기존 데이터 삭제
      await isar.recipes.clear();
      await isar.ingredients.clear();

      // 재료 복원 (먼저 처리)
      for (final json in data['ingredients']) {
        final ingredient = Ingredient.fromJson(json);
        await isar.ingredients.put(ingredient);
        ingredientsImported++;
      }

      // 레시피 복원
      for (final json in data['recipes']) {
        final recipe = Recipe.fromJson(json);
        await isar.recipes.put(recipe);
        recipesImported++;
      }
    });

    return ImportResult(
      recipesImported: recipesImported,
      ingredientsImported: ingredientsImported,
      mode: ImportMode.replace,
    );
  }

  // 데이터 병합 (중복 방지)
  Future<ImportResult> mergeFromJson(File file) async {
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    if (data['version'] != '1.0.0') {
      throw Exception('지원하지 않는 백업 버전입니다: ${data['version']}');
    }

    int recipesImported = 0;
    int ingredientsImported = 0;
    int recipesSkipped = 0;
    int ingredientsSkipped = 0;

    await isar.writeTxn(() async {
      // 재료 병합 (normalizedName 기준 중복 체크)
      for (final json in data['ingredients']) {
        final normalized = json['normalizedName'];
        final existing = await isar.ingredients
            .where()
            .normalizedNameEqualTo(normalized)
            .findFirst();

        if (existing == null) {
          final ingredient = Ingredient.fromJson(json);
          await isar.ingredients.put(ingredient);
          ingredientsImported++;
        } else {
          ingredientsSkipped++;
        }
      }

      // 레시피 병합 (name 기준 중복 체크)
      for (final json in data['recipes']) {
        final name = json['name'];
        final existingRecipes = await isar.recipes.where().findAll();
        final isDuplicate = existingRecipes.any((r) => r.name == name);

        if (!isDuplicate) {
          final recipe = Recipe.fromJson(json);
          await isar.recipes.put(recipe);
          recipesImported++;
        } else {
          recipesSkipped++;
        }
      }
    });

    return ImportResult(
      recipesImported: recipesImported,
      ingredientsImported: ingredientsImported,
      recipesSkipped: recipesSkipped,
      ingredientsSkipped: ingredientsSkipped,
      mode: ImportMode.merge,
    );
  }
}

enum ImportMode { replace, merge }

class ImportResult {
  final int recipesImported;
  final int ingredientsImported;
  final int recipesSkipped;
  final int ingredientsSkipped;
  final ImportMode mode;

  ImportResult({
    required this.recipesImported,
    required this.ingredientsImported,
    this.recipesSkipped = 0,
    this.ingredientsSkipped = 0,
    required this.mode,
  });
}

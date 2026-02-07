import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:idg2recipes/services/backup_service.dart';
import 'package:idg2recipes/providers/database_provider.dart';
import 'dart:io';

part 'backup_provider.g.dart';

@riverpod
BackupService backupService(BackupServiceRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return BackupService(isar);
}

@riverpod
class BackupActions extends _$BackupActions {
  @override
  FutureOr<void> build() {}

  Future<File> exportData() async {
    final service = ref.read(backupServiceProvider);
    return await service.exportToJson();
  }

  Future<ImportResult> importData(File file, {bool merge = false}) async {
    final service = ref.read(backupServiceProvider);
    if (merge) {
      return await service.mergeFromJson(file);
    } else {
      return await service.importFromJson(file);
    }
  }
}

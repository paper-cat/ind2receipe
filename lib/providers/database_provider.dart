import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:idg2recipes/core/database/isar_service.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isar(IsarRef ref) async {
  return await IsarService.getInstance();
}

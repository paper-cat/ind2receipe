// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backupServiceHash() => r'bead3c564defc72deb3fe5e0cc9dc7f2b2ad5ed4';

/// See also [backupService].
@ProviderFor(backupService)
final backupServiceProvider = AutoDisposeProvider<BackupService>.internal(
  backupService,
  name: r'backupServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BackupServiceRef = AutoDisposeProviderRef<BackupService>;
String _$backupActionsHash() => r'd0d8e26ab97c29e40259ec6cf2941692d17064fa';

/// See also [BackupActions].
@ProviderFor(BackupActions)
final backupActionsProvider =
    AutoDisposeAsyncNotifierProvider<BackupActions, void>.internal(
  BackupActions.new,
  name: r'backupActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackupActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

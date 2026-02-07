// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recipeRepositoryHash() => r'6d9e9bfabf5601b8149dc6aa4bf13207494b0750';

/// See also [recipeRepository].
@ProviderFor(recipeRepository)
final recipeRepositoryProvider = AutoDisposeProvider<RecipeRepository>.internal(
  recipeRepository,
  name: r'recipeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recipeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RecipeRepositoryRef = AutoDisposeProviderRef<RecipeRepository>;
String _$allRecipesHash() => r'df0dbf6c99a10e2526d6669978e7483fdfe31cf5';

/// See also [allRecipes].
@ProviderFor(allRecipes)
final allRecipesProvider = AutoDisposeStreamProvider<List<Recipe>>.internal(
  allRecipes,
  name: r'allRecipesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allRecipesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllRecipesRef = AutoDisposeStreamProviderRef<List<Recipe>>;
String _$recipeDetailHash() => r'20eccc9a13e2d3c72880a6baf56f66cd57979dcc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recipeDetail].
@ProviderFor(recipeDetail)
const recipeDetailProvider = RecipeDetailFamily();

/// See also [recipeDetail].
class RecipeDetailFamily extends Family<AsyncValue<Recipe?>> {
  /// See also [recipeDetail].
  const RecipeDetailFamily();

  /// See also [recipeDetail].
  RecipeDetailProvider call(
    int id,
  ) {
    return RecipeDetailProvider(
      id,
    );
  }

  @override
  RecipeDetailProvider getProviderOverride(
    covariant RecipeDetailProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recipeDetailProvider';
}

/// See also [recipeDetail].
class RecipeDetailProvider extends AutoDisposeFutureProvider<Recipe?> {
  /// See also [recipeDetail].
  RecipeDetailProvider(
    int id,
  ) : this._internal(
          (ref) => recipeDetail(
            ref as RecipeDetailRef,
            id,
          ),
          from: recipeDetailProvider,
          name: r'recipeDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recipeDetailHash,
          dependencies: RecipeDetailFamily._dependencies,
          allTransitiveDependencies:
              RecipeDetailFamily._allTransitiveDependencies,
          id: id,
        );

  RecipeDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Recipe?> Function(RecipeDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecipeDetailProvider._internal(
        (ref) => create(ref as RecipeDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Recipe?> createElement() {
    return _RecipeDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RecipeDetailRef on AutoDisposeFutureProviderRef<Recipe?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RecipeDetailProviderElement
    extends AutoDisposeFutureProviderElement<Recipe?> with RecipeDetailRef {
  _RecipeDetailProviderElement(super.provider);

  @override
  int get id => (origin as RecipeDetailProvider).id;
}

String _$filteredRecipesHash() => r'ae1d179c04f235052d1606df6b7301c91d76c1d5';

/// See also [filteredRecipes].
@ProviderFor(filteredRecipes)
final filteredRecipesProvider =
    AutoDisposeStreamProvider<List<Recipe>>.internal(
  filteredRecipes,
  name: r'filteredRecipesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredRecipesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredRecipesRef = AutoDisposeStreamProviderRef<List<Recipe>>;
String _$recipeActionsHash() => r'969018a8c8c65edbce5c5efe13fa2ba53fbf3047';

/// See also [RecipeActions].
@ProviderFor(RecipeActions)
final recipeActionsProvider =
    AutoDisposeAsyncNotifierProvider<RecipeActions, void>.internal(
  RecipeActions.new,
  name: r'recipeActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recipeActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecipeActions = AutoDisposeAsyncNotifier<void>;
String _$selectedRecipesHash() => r'0584c0ca47727a6855875f7af975efa6fb3ecb25';

/// See also [SelectedRecipes].
@ProviderFor(SelectedRecipes)
final selectedRecipesProvider =
    AutoDisposeNotifierProvider<SelectedRecipes, Set<int>>.internal(
  SelectedRecipes.new,
  name: r'selectedRecipesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedRecipesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedRecipes = AutoDisposeNotifier<Set<int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

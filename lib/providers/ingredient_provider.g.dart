// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ingredientRepositoryHash() =>
    r'cf31dfb0f76ebfabbd901fb9bf2884231fa68d4c';

/// See also [ingredientRepository].
@ProviderFor(ingredientRepository)
final ingredientRepositoryProvider =
    AutoDisposeFutureProvider<IngredientRepository>.internal(
  ingredientRepository,
  name: r'ingredientRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ingredientRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IngredientRepositoryRef
    = AutoDisposeFutureProviderRef<IngredientRepository>;
String _$searchIngredientsHash() => r'fa91b4afb70d17a98ed5d4db01c0fa245b062f9a';

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

/// See also [searchIngredients].
@ProviderFor(searchIngredients)
const searchIngredientsProvider = SearchIngredientsFamily();

/// See also [searchIngredients].
class SearchIngredientsFamily extends Family<AsyncValue<List<Ingredient>>> {
  /// See also [searchIngredients].
  const SearchIngredientsFamily();

  /// See also [searchIngredients].
  SearchIngredientsProvider call(
    String query,
  ) {
    return SearchIngredientsProvider(
      query,
    );
  }

  @override
  SearchIngredientsProvider getProviderOverride(
    covariant SearchIngredientsProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchIngredientsProvider';
}

/// See also [searchIngredients].
class SearchIngredientsProvider
    extends AutoDisposeFutureProvider<List<Ingredient>> {
  /// See also [searchIngredients].
  SearchIngredientsProvider(
    String query,
  ) : this._internal(
          (ref) => searchIngredients(
            ref as SearchIngredientsRef,
            query,
          ),
          from: searchIngredientsProvider,
          name: r'searchIngredientsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchIngredientsHash,
          dependencies: SearchIngredientsFamily._dependencies,
          allTransitiveDependencies:
              SearchIngredientsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchIngredientsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Ingredient>> Function(SearchIngredientsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchIngredientsProvider._internal(
        (ref) => create(ref as SearchIngredientsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Ingredient>> createElement() {
    return _SearchIngredientsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchIngredientsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchIngredientsRef on AutoDisposeFutureProviderRef<List<Ingredient>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchIngredientsProviderElement
    extends AutoDisposeFutureProviderElement<List<Ingredient>>
    with SearchIngredientsRef {
  _SearchIngredientsProviderElement(super.provider);

  @override
  String get query => (origin as SearchIngredientsProvider).query;
}

String _$recipesBySelectedIngredientHash() =>
    r'f2383115be9eef7ff7badbada20378bfc627da8c';

/// See also [recipesBySelectedIngredient].
@ProviderFor(recipesBySelectedIngredient)
final recipesBySelectedIngredientProvider =
    AutoDisposeFutureProvider<List<Recipe>>.internal(
  recipesBySelectedIngredient,
  name: r'recipesBySelectedIngredientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recipesBySelectedIngredientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RecipesBySelectedIngredientRef
    = AutoDisposeFutureProviderRef<List<Recipe>>;
String _$recipesByIngredientsHash() =>
    r'9102c17ac37167838760891e970d119105eca192';

/// See also [recipesByIngredients].
@ProviderFor(recipesByIngredients)
const recipesByIngredientsProvider = RecipesByIngredientsFamily();

/// See also [recipesByIngredients].
class RecipesByIngredientsFamily extends Family<AsyncValue<List<Recipe>>> {
  /// See also [recipesByIngredients].
  const RecipesByIngredientsFamily();

  /// See also [recipesByIngredients].
  RecipesByIngredientsProvider call(
    List<String> ingredientIds,
  ) {
    return RecipesByIngredientsProvider(
      ingredientIds,
    );
  }

  @override
  RecipesByIngredientsProvider getProviderOverride(
    covariant RecipesByIngredientsProvider provider,
  ) {
    return call(
      provider.ingredientIds,
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
  String? get name => r'recipesByIngredientsProvider';
}

/// See also [recipesByIngredients].
class RecipesByIngredientsProvider
    extends AutoDisposeFutureProvider<List<Recipe>> {
  /// See also [recipesByIngredients].
  RecipesByIngredientsProvider(
    List<String> ingredientIds,
  ) : this._internal(
          (ref) => recipesByIngredients(
            ref as RecipesByIngredientsRef,
            ingredientIds,
          ),
          from: recipesByIngredientsProvider,
          name: r'recipesByIngredientsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recipesByIngredientsHash,
          dependencies: RecipesByIngredientsFamily._dependencies,
          allTransitiveDependencies:
              RecipesByIngredientsFamily._allTransitiveDependencies,
          ingredientIds: ingredientIds,
        );

  RecipesByIngredientsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ingredientIds,
  }) : super.internal();

  final List<String> ingredientIds;

  @override
  Override overrideWith(
    FutureOr<List<Recipe>> Function(RecipesByIngredientsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecipesByIngredientsProvider._internal(
        (ref) => create(ref as RecipesByIngredientsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ingredientIds: ingredientIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Recipe>> createElement() {
    return _RecipesByIngredientsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipesByIngredientsProvider &&
        other.ingredientIds == ingredientIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ingredientIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RecipesByIngredientsRef on AutoDisposeFutureProviderRef<List<Recipe>> {
  /// The parameter `ingredientIds` of this provider.
  List<String> get ingredientIds;
}

class _RecipesByIngredientsProviderElement
    extends AutoDisposeFutureProviderElement<List<Recipe>>
    with RecipesByIngredientsRef {
  _RecipesByIngredientsProviderElement(super.provider);

  @override
  List<String> get ingredientIds =>
      (origin as RecipesByIngredientsProvider).ingredientIds;
}

String _$allIngredientsHash() => r'b54728b7e2ff671c2671ad7a23bc76737c4431d9';

/// See also [allIngredients].
@ProviderFor(allIngredients)
final allIngredientsProvider =
    AutoDisposeStreamProvider<List<Ingredient>>.internal(
  allIngredients,
  name: r'allIngredientsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allIngredientsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllIngredientsRef = AutoDisposeStreamProviderRef<List<Ingredient>>;
String _$selectedIngredientsHash() =>
    r'692285197e75bd658dfaf21d32ec86652decff63';

/// See also [SelectedIngredients].
@ProviderFor(SelectedIngredients)
final selectedIngredientsProvider =
    AutoDisposeNotifierProvider<SelectedIngredients, List<String>>.internal(
  SelectedIngredients.new,
  name: r'selectedIngredientsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedIngredientsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedIngredients = AutoDisposeNotifier<List<String>>;
String _$selectedIngredientHash() =>
    r'4bcd68a79496724358f5587ce90967442665dbb4';

/// See also [SelectedIngredient].
@ProviderFor(SelectedIngredient)
final selectedIngredientProvider =
    AutoDisposeNotifierProvider<SelectedIngredient, String?>.internal(
  SelectedIngredient.new,
  name: r'selectedIngredientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedIngredientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedIngredient = AutoDisposeNotifier<String?>;
String _$selectedIngredientIdsHash() =>
    r'4526b45e8d1792606ed83dc1d8bb0642c5270bba';

/// See also [SelectedIngredientIds].
@ProviderFor(SelectedIngredientIds)
final selectedIngredientIdsProvider =
    AutoDisposeNotifierProvider<SelectedIngredientIds, Set<int>>.internal(
  SelectedIngredientIds.new,
  name: r'selectedIngredientIdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedIngredientIdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedIngredientIds = AutoDisposeNotifier<Set<int>>;
String _$ingredientActionsHash() => r'9eea1124915cb4f8443da3c750f53f15aa8721d1';

/// See also [IngredientActions].
@ProviderFor(IngredientActions)
final ingredientActionsProvider =
    AutoDisposeAsyncNotifierProvider<IngredientActions, void>.internal(
  IngredientActions.new,
  name: r'ingredientActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ingredientActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IngredientActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wishlistRepositoryHash() =>
    r'cac1f34468ad82a98fcb57c8cb669f1aa16d910a';

/// See also [wishlistRepository].
@ProviderFor(wishlistRepository)
final wishlistRepositoryProviderGenerated = Provider<WishlistRepository>.internal(
  wishlistRepository,
  name: r'wishlistRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wishlistRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WishlistRepositoryRef = ProviderRef<WishlistRepository>;
String _$userWishlistStreamHash() =>
    r'6925127d8915de47f32ae15b9dff3307358e2423';

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

/// See also [userWishlistStream].
@ProviderFor(userWishlistStream)
const userWishlistStreamProvider = UserWishlistStreamFamily();

/// See also [userWishlistStream].
class UserWishlistStreamFamily extends Family<AsyncValue<List<WishlistItem>>> {
  /// See also [userWishlistStream].
  const UserWishlistStreamFamily();

  /// See also [userWishlistStream].
  UserWishlistStreamProvider call(
    String userId,
  ) {
    return UserWishlistStreamProvider(
      userId,
    );
  }

  @override
  UserWishlistStreamProvider getProviderOverride(
    covariant UserWishlistStreamProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userWishlistStreamProvider';
}

/// See also [userWishlistStream].
class UserWishlistStreamProvider
    extends AutoDisposeStreamProvider<List<WishlistItem>> {
  /// See also [userWishlistStream].
  UserWishlistStreamProvider(
    String userId,
  ) : this._internal(
          (ref) => userWishlistStream(
            ref as UserWishlistStreamRef,
            userId,
          ),
          from: userWishlistStreamProvider,
          name: r'userWishlistStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userWishlistStreamHash,
          dependencies: UserWishlistStreamFamily._dependencies,
          allTransitiveDependencies:
              UserWishlistStreamFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserWishlistStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<WishlistItem>> Function(UserWishlistStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserWishlistStreamProvider._internal(
        (ref) => create(ref as UserWishlistStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<WishlistItem>> createElement() {
    return _UserWishlistStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserWishlistStreamProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserWishlistStreamRef
    on AutoDisposeStreamProviderRef<List<WishlistItem>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserWishlistStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<WishlistItem>>
    with UserWishlistStreamRef {
  _UserWishlistStreamProviderElement(super.provider);

  @override
  String get userId => (origin as UserWishlistStreamProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

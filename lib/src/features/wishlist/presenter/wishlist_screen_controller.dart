import 'package:pro_ecommerce/src/features/wishlist/data/wishlist_repository.dart';
import 'package:pro_ecommerce/src/features/wishlist/domain/wishlist_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_screen_controller.g.dart';

@riverpod
class WishlistController extends _$WishlistController {
  late final WishlistRepository _wishlistRepository;

  @override
  FutureOr<void> build() {
    _wishlistRepository = ref.read(wishlistRepositoryProvider);
  }

  /// Add a product to the user's wishlist
  Future<void> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _wishlistRepository.addWishlistItem(
          userId: userId, productId: productId);
    });
  }

  /// Remove a product from the user's wishlist
  Future<void> removeFromWishlist({
    required String userId,
    required String wishlistItemId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _wishlistRepository.removeWishlistItem(
          userId: userId, productId: wishlistItemId);
    });
  }

  /// Fetch the user's wishlist items
  Stream<List<WishlistItem>> watchWishlist(String userId) {
    return _wishlistRepository.watchUserWishlist(userId);
  }
}

import 'package:pro_ecommerce/src/features/cart/data/cart_repository.dart';
import 'package:pro_ecommerce/src/features/cart/domain/cart_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_screen_controller.g.dart';

@riverpod
class CartScreenController extends _$CartScreenController {
  late final CartRepository _cartRepository;

  @override
  FutureOr<void> build() {
    _cartRepository = ref.read(cartRepositoryProvider);
  }

  /// Add a product to the user's cart
  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _cartRepository.addCartItem(
        userId: userId,
        productId: productId,
        quantity: quantity,
      );
    });
  }

  /// Remove a product from the user's cart
  Future<void> removeFromCart({
    required String userId,
    required String cartItemId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _cartRepository.removeCartItem(
        cartItemId,
        userId: userId,
        cartItemId: cartItemId,
      );
    });
  }

  /// Fetch the user's cart items as a stream
  Stream<List<CartItem>> watchCart(String userId) {
    return _cartRepository.watchUserCart(userId);
  }

  Future<void> updateQuantity(
      String userId, CartItem cartItem, int newQuantity) async {
    if (newQuantity > 0) {
      await _cartRepository.updateCartItemQuantity(
          userId: userId, cartItemId: cartItem.id, newQuantity: newQuantity);
    } else {
      await _cartRepository.removeCartItem(cartItem.id,
          userId: '', cartItemId: '');
    }
  }
}

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_ecommerce/src/common_widgets/shared_scaffold.dart';
import 'package:pro_ecommerce/src/features/authentication/domain/app_user.dart';
import 'package:pro_ecommerce/src/features/cart/data/cart_repository.dart';
import 'package:pro_ecommerce/src/features/cart/domain/cart_item.dart';
import 'package:pro_ecommerce/src/features/cart/presenter/cart/cart_screen_controller.dart';
import 'package:pro_ecommerce/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:pro_ecommerce/src/utils/async_value_ui.dart';
import 'package:pro_ecommerce/src/features/products/data/products_repository.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current user
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      return const Center(child: Text('Please log in to view your cart.'));
    }

    final userId = user.uid;

    print('\n\n\nUser ID: $userId \n\n\n\n');

    // Watch the cart items stream
    final cartStream =
        ref.read(cartScreenControllerProvider.notifier).watchCart(userId);

    return SharedScaffold(
        title: 'Cart',
        body: Expanded(child: _buildProductList(context, userId)));
  }

  Widget _buildProductList(BuildContext context, String userId) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen<AsyncValue>(
          cartScreenControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
        );
        final cartStream =
            ref.watch(cartRepositoryProvider).watchUserCart(userId);
        return LayoutBuilder(
          builder: (context, constraints) {
            debugPrint('Parent constraints: $constraints');
            return SizedBox(
              height: constraints.maxHeight > 0 ? constraints.maxHeight : 300,
              child: StreamBuilder<List<CartItem>>(
                stream: cartStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];

                      return CartItemTile(
                        cartItem: product,
                        userId: userId,
                        // onRemove: () {
                        //   ref
                        //       .read(cartScreenControllerProvider.notifier)
                        //       .removeFromCart(
                        //         userId: userId,
                        //         cartItemId: product.id,
                        //       );
                        // },
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class CartItemTile extends ConsumerWidget {
  final CartItem cartItem;
  final String userId;

  const CartItemTile({Key? key, required this.cartItem, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsyncValue =
        ref.watch(productStreamProvider(cartItem.productId));

    return productAsyncValue.when(
      data: (product) {
        bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  ),
                  child: product.productImages.isNotEmpty
                      ? Image.network(product.productImages[0].url,
                          fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Text("Color: Black",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),

                          // Quantity Selector
                          Row(
                            children: [
                              _quantityButton(Icons.remove, () {
                                ref
                                    .read(cartScreenControllerProvider.notifier)
                                    .updateQuantity(userId, cartItem,
                                        cartItem.quantity - 1);
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(cartItem.quantity.toString(),
                                    style: const TextStyle(fontSize: 16)),
                              ),
                              _quantityButton(Icons.add, () {
                                ref
                                    .read(cartScreenControllerProvider.notifier)
                                    .updateQuantity(userId, cartItem,
                                        cartItem.quantity + 1);
                              }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
      ),
    );
  }
}

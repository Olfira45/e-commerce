import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_ecommerce/src/common_widgets/product_card.dart';

import 'package:pro_ecommerce/src/common_widgets/shared_scaffold.dart';
import 'package:pro_ecommerce/src/constants/strings.dart';
import 'package:pro_ecommerce/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:pro_ecommerce/src/features/products/data/products_repository.dart';
import 'package:pro_ecommerce/src/features/products/domain/product.dart';
import 'package:pro_ecommerce/src/features/wishlist/data/wishlist_repository.dart';
import 'package:pro_ecommerce/src/features/wishlist/presenter/wishlist_screen_controller.dart';

import 'package:pro_ecommerce/src/utils/async_value_ui.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      title: Strings.wishlist,
      body: Column(
        children: [
          Expanded(child: _buildWishlist(context)),
        ],
      ),
    );
  }

  Widget _buildWishlist(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen<AsyncValue>(
          wishlistControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
        );

        // ✅ Fetch the current user's ID
        final user = ref.read(authRepositoryProvider).currentUser;
        if (user == null) {
          return const Center(
            child: Text('Please log in to view your wishlist'),
          );
        }
        final userId = user.uid;

        // ✅ Get the wishlist stream (Now using `wishlistStreamProvider`)
        final wishlistStream = ref.watch(wishlistStreamProvider(userId));

        return LayoutBuilder(
          builder: (context, constraints) {
            debugPrint('Parent constraints: $constraints');
            return SizedBox(
              height: constraints.maxHeight > 0 ? constraints.maxHeight : 300,
              child: wishlistStream.when(
                data: (wishlistProductIds) {
                  if (wishlistProductIds.isEmpty) {
                    return const Center(
                        child: Text('No items in your wishlist'));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 8.0, // Space between columns
                      mainAxisSpacing: 8.0, // Space between rows
                      childAspectRatio: 0.75, // Aspect ratio of each item
                    ),
                    itemCount: wishlistProductIds.length,
                    itemBuilder: (context, index) {
                      final productId = wishlistProductIds[index];

                      // ✅ Fetch product details using a FutureProvider
                      final productFuture = ref
                          .watch(productsRepositoryProvider)
                          .getProduct(productId);

                      return FutureBuilder<Product?>(
                        future: productFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                                child: Text('Product not found'));
                          }

                          final product = snapshot.data!;

                          return ProductCard(
                            productId: product.id,
                            name: product.name,
                            price: product.price,
                            oldPrice: product.price,
                            stock: product.stock,
                            rating: product.stock.toDouble(),
                            imageUrl: product.productImages.first.url,
                            onTap: () async {
                              try {
                                final user = ref
                                    .read(authRepositoryProvider)
                                    .currentUser;
                                if (user == null) {
                                  throw Exception('User not logged in');
                                }
                                final userId = user.uid;

                                // ✅ Toggle wishlist item (Add/Remove)
                                final wishlist = await ref.read(
                                    wishlistStreamProvider(userId).future);
                                if (wishlist.contains(product.id)) {
                                  await ref
                                      .read(wishlistRepositoryProvider)
                                      .removeWishlistItem(
                                        userId: userId,
                                        productId: product.id,
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${product.name} removed from wishlist')),
                                  );
                                } else {
                                  await ref
                                      .read(wishlistRepositoryProvider)
                                      .addWishlistItem(
                                        userId: userId,
                                        productId: product.id,
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${product.name} added to wishlist')),
                                  );
                                }
                              } catch (e) {
                                print("❌ Wishlist Error: ${e.toString()}");
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: ${error.toString()}'),
                ),
              ),
            );
          },
        );
      },
    );
  }

/*
  Widget _buildWishlist(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen<AsyncValue>(
          wishlistControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
        );

        // Fetch the current user's ID
        final user = ref.read(authRepositoryProvider).currentUser;
        if (user == null) {
          return const Center(
            child: Text('Please log in to view your wishlist'),
          );
        }
        final userId = user.uid;

        // Get the wishlist query
        final wishlistStream = ref.watch(userWishlistStreamProvider(userId));

        return LayoutBuilder(
          builder: (context, constraints) {
            debugPrint('Parent constraints: $constraints');
            return SizedBox(
              height: constraints.maxHeight > 0 ? constraints.maxHeight : 300,
              child: wishlistStream.when(
                data: (wishlistItems) {
                  if (wishlistItems.isEmpty) {
                    return const Center(
                        child: Text('No items in your wishlist'));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 8.0, // Space between columns
                      mainAxisSpacing: 8.0, // Space between rows
                      childAspectRatio: 0.75, // Aspect ratio of each item
                    ),
                    itemCount: wishlistItems.length,
                    itemBuilder: (context, index) {
                      final wishlistItem = wishlistItems[index];

                      return FutureBuilder<Product>(
                        future: ref
                            .read(productsRepositoryProvider)
                            .fetchProducts()
                            .then((products) => products.firstWhere(
                                  (product) =>
                                      product.id == wishlistItem.productId,
                                )),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                                child: Text('Product not found'));
                          }

                          final product = snapshot.data!;

                          return ProductCard(
                            productId: product.id,
                            name: product.name,
                            price: product.price,
                            oldPrice: product.price,
                            stock: product.stock,
                            rating: product.stock.toDouble(),
                            imageUrl: product.productImages.first.url,
                            onTap: () {
                              try {
                                final user = ref
                                    .read(authRepositoryProvider)
                                    .currentUser;
                                if (user == null) {
                                  throw Exception('User not logged in');
                                }
                                final userId = user.uid;
                                ref
                                    .read(wishlistRepositoryProvider)
                                    .addWishlistItem(
                                      userId: userId,
                                      productId: product.name,
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '${product.name} added to wishlist')),
                                );
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: ${error.toString()}'),
                ),
              ),
            );
          },
        );
      },
    );
  }*/
}

class WishlistItemCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final VoidCallback onRemove;

  const WishlistItemCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wishlist Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            // Wishlist Item Name
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Price Section
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const Spacer(),
            // Remove Button
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

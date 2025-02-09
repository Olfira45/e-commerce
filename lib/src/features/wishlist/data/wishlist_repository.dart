/*
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pro_ecommerce/src/features/wishlist/domain/wishlist_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'wishlist_repository.g.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository(FirebaseFirestore.instance);
});

class WishlistRepository {
  final FirebaseFirestore _firestore;

  WishlistRepository(this._firestore);

  // Collection paths
  static String wishlistPath(String userId) =>
      'wishlists/$userId/wishlistItems';
  static String wishlistItemPath(String userId, String wishlistItemId) =>
      'wishlists/$userId/wishlistItems/$wishlistItemId';

  // ✅ Create or Add Wishlist Item
  Future<void> addWishlistItem({
    required String userId,
    required String productId,
  }) async {
    try {
      final wishlistRef = _firestore.collection('wishlists').doc(userId);

      // Ensure the document exists before updating it
      await wishlistRef.set({'productIds': []}, SetOptions(merge: true));

      await wishlistRef.update({
        'productIds': FieldValue.arrayUnion([productId])
      });

      print("✅ Product $productId added to wishlist for user $userId");
    } catch (e) {
      print("❌ Error adding wishlist item: $e");
    }
  }

  // ✅ Remove Wishlist Item
  Future<void> removeWishlistItem({
    required String userId,
    required String productId,
  }) async {
    try {
      final wishlistRef = _firestore.collection('wishlists').doc(userId);

      await wishlistRef.update({
        'productIds': FieldValue.arrayRemove([productId])
      });

      print("✅ Product $productId removed from wishlist for user $userId");
    } catch (e) {
      print("❌ Error removing wishlist item: $e");
    }
  }

  // ✅ Read: Stream User's Wishlist as List of WishlistItem Objects
  Stream<List<WishlistItem>> watchUserWishlist(String userId) {
    return _firestore
        .collection(wishlistPath(userId))
        .withConverter<WishlistItem>(
          fromFirestore: (snapshot, _) =>
              WishlistItem.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (item, _) => item.toMap(),
        )
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs.map((doc) => doc.data()).toList();
      print("📥 Streamed Wishlist Items: $items");
      return items;
    });
  }

  // ✅ Fetch User's Wishlist as List of WishlistItem Objects (One-time)
  Future<List<WishlistItem>> fetchUserWishlist(String userId) async {
    try {
      final wishlistSnapshot = await _firestore
          .collection(wishlistPath(userId))
          .withConverter<WishlistItem>(
            fromFirestore: (snapshot, _) =>
                WishlistItem.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (item, _) => item.toMap(),
          )
          .get();

      final wishlist = wishlistSnapshot.docs.map((doc) => doc.data()).toList();
      print("🔄 Fetched Wishlist Items: $wishlist");
      return wishlist;
    } catch (e) {
      print("❌ Error fetching wishlist: $e");
      return [];
    }
  }

  // ✅ Stream Wishlist as List of Product IDs
  Stream<List<String>> watchWishlist(String userId) {
    return _firestore
        .collection('wishlists')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        final productIds = (data?['productIds'] ?? []).cast<String>();
        print("🔄 Streamed Wishlist Product IDs: $productIds");
        return productIds;
      } else {
        print("⚠️ No Wishlist Found for User: $userId");
        return [];
      }
    }).handleError((error) {
      print("❌ Error streaming wishlist: $error");
      return [];
    }) as Stream<List<String>>;
  }
}

// ✅ Riverpod Providers
@Riverpod(keepAlive: true)
WishlistRepository wishlistRepository(Ref ref) {
  return WishlistRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<WishlistItem>> userWishlistStream(Ref ref, String userId) {
  final repository = ref.watch(wishlistRepositoryProvider);
  return repository.watchUserWishlist(userId);
}

final wishlistStreamProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  final repository = ref.watch(wishlistRepositoryProvider);
  return repository.watchWishlist(userId);
});

*/

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pro_ecommerce/src/features/wishlist/domain/wishlist_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'wishlist_repository.g.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository(FirebaseFirestore.instance);
});

class WishlistRepository {
  final FirebaseFirestore _firestore;

  WishlistRepository(this._firestore);

  // Collection paths
  static String wishlistPath(String userId) =>
      'wishlists/$userId/wishlistItems';
  static String wishlistItemPath(String userId, String wishlistItemId) =>
      'wishlists/$userId/wishlistItems/$wishlistItemId';

  // Create
  Future<void> addWishlistItem({
    required String userId,
    required String productId,
  }) async {
    final wishlistRef = _firestore.collection('wishlists').doc(userId);
    await wishlistRef.update({
      'productIds': FieldValue.arrayUnion([productId])
    });
  }

  // Delete
  Future<void> removeWishlistItem({
    required String userId,
    required String productId,
  }) async {
    final wishlistRef = _firestore.collection('wishlists').doc(userId);
    await wishlistRef.update({
      'productIds': FieldValue.arrayRemove([productId])
    });
  }

  // Read: User's Wishlist
  Stream<List<WishlistItem>> watchUserWishlist(String userId) => _firestore
      .collection(wishlistPath(userId))
      .withConverter<WishlistItem>(
        fromFirestore: (snapshot, _) =>
            WishlistItem.fromMap(snapshot.data()!, snapshot.id),
        toFirestore: (item, _) => item.toMap(),
      )
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Future<List<WishlistItem>> fetchUserWishlist(String userId) async {
    final wishlistSnapshot = await _firestore
        .collection(wishlistPath(userId))
        .withConverter<WishlistItem>(
          fromFirestore: (snapshot, _) =>
              WishlistItem.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (item, _) => item.toMap(),
        )
        .get();
    return wishlistSnapshot.docs.map((doc) => doc.data()).toList();
  }

  Stream<List<String>> watchWishlist(String userId) {
    return _firestore
        .collection('wishlists')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        print(snapshot.data());
        return List<String>.from(snapshot.data()?['productIds'] ?? []);
      } else {
        return [];
      }
    });
  }
}

@Riverpod(keepAlive: true)
WishlistRepository wishlistRepository(Ref ref) {
  return WishlistRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<WishlistItem>> userWishlistStream(Ref ref, String userId) {
  final repository = ref.watch(wishlistRepositoryProvider);
  return repository.watchUserWishlist(userId);
}

final wishlistStreamProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  final repository = ref.watch(wishlistRepositoryProvider);
  return repository.watchWishlist(userId);
});

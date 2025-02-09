class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String sellerId;
  final String status;
  final List<String> categories;
  final List<String> tags;
  final List<ProductImage> productImages;
  //final DateTime expiresOn;
  final Map<String, dynamic> metadata;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.sellerId,
    required this.status,
    required this.categories,
    required this.tags,
    required this.productImages,
    //required this.expiresOn,
    required this.metadata,
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      price: (data['price'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      sellerId: data['seller_id']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      categories: List<String>.from(data['categories'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      productImages: (data['images'] as List<dynamic>?)
              ?.map(
                  (publicId) => ProductImage.fromPublicId(publicId.toString()))
              .toList() ??
          [],
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'seller_id': sellerId,
      'status': status,
      'categories': categories,
      'tags': tags,
      'images': productImages.map((img) => img.publicId).toList(),
      //'expires_on': expiresOn.toIso8601String(),
      'metadata': metadata,
    };
  }
}

class ProductImage {
  final String publicId;
  final String url;

  ProductImage({required this.publicId, required this.url});

  factory ProductImage.fromPublicId(String publicId) {
    const String cloudName =
        'dul7hg6so'; // Replace with your actual Cloudinary cloud name
    return ProductImage(
      publicId: publicId,
      url: 'https://res.cloudinary.com/$cloudName/image/upload/$publicId',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'public_id': publicId,
    };
  }
}

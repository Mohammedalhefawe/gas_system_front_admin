import 'package:gas_admin_app/core/extensions/prefix_url_image_extension.dart';

class ProductModel {
  final int productId;
  final String productName;
  final String description;
  final bool isAvailable;
  final String categoryId;
  final double price;
  final String? imageUrl;
  final String? specialNotes;
  final String? createdAt;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.description,
    required this.isAvailable,
    required this.categoryId,
    required this.price,
    this.imageUrl,
    this.specialNotes,
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      description: json['description'] ?? '',
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
      categoryId: json['category_id']?.toString() ?? "0",
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: (json['image_url'] as String?)?.withImagePrefix,
      specialNotes: json['special_notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'description': description,
      'is_available': isAvailable ? "1" : "0",
      'category_id': categoryId,
      'price': price.toStringAsFixed(0),
      if (specialNotes != null) 'special_notes': specialNotes,
    };
  }

  ProductModel copyWith({
    int? productId,
    String? productName,
    String? description,
    bool? isAvailable,
    String? categoryId,
    double? price,
    String? imageUrl,
    String? specialNotes,
    String? createdAt,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      specialNotes: specialNotes ?? this.specialNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

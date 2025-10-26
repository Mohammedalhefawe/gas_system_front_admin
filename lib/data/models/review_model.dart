import 'package:gas_admin_app/data/models/customer_model.dart';
import 'package:gas_admin_app/data/models/product_model.dart';

class ReviewModel {
  final int reviewId;
  final int productId;
  final int customerId;
  final int rating;
  final String review;
  final String createdAt;
  final CustomerModel customer;

  ReviewModel({
    required this.reviewId,
    required this.productId,
    required this.customerId,
    required this.rating,
    required this.review,
    required this.createdAt,
    required this.customer,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['review_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      createdAt: json['created_at'] ?? '',
      customer: CustomerModel.fromJson(json['customer'] ?? {}),
    );
  }
}

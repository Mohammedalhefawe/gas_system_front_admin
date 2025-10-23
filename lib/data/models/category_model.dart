class CategoryModel {
  final String categoryId;
  final String categoryName;
  final String description;
  final bool isActive;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id']?.toString() ?? "0",
      categoryName: json['category_name'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'description': description,
      'is_active': isActive ? 1 : 0,
    };
  }

  CategoryModel copyWith({
    String? categoryId,
    String? categoryName,
    String? description,
    bool? isActive,
  }) {
    return CategoryModel(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}

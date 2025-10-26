class CustomerModel {
  final int customerId;
  final int userId;
  final String fullName;
  final bool blocked;

  final User? user;

  CustomerModel({
    this.customerId = 0,
    this.userId = 0,
    this.fullName = "",
    this.user,
    this.blocked = false,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customer_id'] ?? 0,
      blocked: ((json['blocked'] == 1 || json['blocked'] == true)
          ? true
          : false),
      userId: json['user_id'] ?? 0,
      fullName: json['full_name'] ?? "",
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  CustomerModel copyWith({
    int? customerId,
    int? userId,
    String? fullName,
    User? user,
    bool? blocked,
  }) {
    return CustomerModel(
      customerId: customerId ?? this.customerId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      user: user ?? this.user,
      blocked: blocked ?? this.blocked,
    );
  }
}

class User {
  final int userId;
  final String phoneNumber;

  User({required this.userId, required this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as int,
      phoneNumber: json['phone_number'] as String,
    );
  }
}

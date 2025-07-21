class SubscriptionModel {
  final SubscriptionProduct subscriptionProduct;
  final String subscriptionPlan;
  final String subscriptionId;
  final String status;
  final String platform;

  SubscriptionModel({
    required this.subscriptionProduct,
    required this.subscriptionPlan,
    required this.subscriptionId,
    required this.status,
    required this.platform,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      subscriptionProduct:
          SubscriptionProduct.fromJson(json['subscriptionProduct']),
      subscriptionPlan: json['subscription_plan'] ?? '',
      subscriptionId: json['subscription_id'] ?? '',
      status: json['status'] ?? '',
      platform: json['platform'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptionProduct': subscriptionProduct.toJson(),
      'subscription_plan': subscriptionPlan,
      'subscription_id': subscriptionId,
      'status': status,
      'platform': platform,
    };
  }

  SubscriptionModel copyWith({
    SubscriptionProduct? subscriptionProduct,
    String? subscriptionPlan,
    String? subscriptionId,
    String? status,
    String? platform,
  }) {
    return SubscriptionModel(
      subscriptionProduct: subscriptionProduct ?? this.subscriptionProduct,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      status: status ?? this.status,
      platform: platform ?? this.platform,
    );
  }
}

class SubscriptionProduct {
  final String id;
  final String stripeProductId;
  final String stripePriceId;
  final String productName;
  final Map<String, String> description;
  final String productType;
  final double price;
  final String subscriptionDuration;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionProduct({
    required this.id,
    required this.stripeProductId,
    required this.stripePriceId,
    required this.productName,
    required this.description,
    required this.productType,
    required this.price,
    required this.subscriptionDuration,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionProduct.fromJson(Map<String, dynamic> json) {
    return SubscriptionProduct(
      id: json['_id'] ?? '',
      stripeProductId: json['stripe_product_id'] ?? '',
      stripePriceId: json['stripe_price_id'] ?? '',
      productName: json['product_name'] ?? '',
      description: (json['description'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toString())),
      productType: json['product_type'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      subscriptionDuration: json['subscription_duration'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'stripe_product_id': stripeProductId,
      'stripe_price_id': stripePriceId,
      'product_name': productName,
      'description': description,
      'product_type': productType,
      'price': price,
      'subscription_duration': subscriptionDuration,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SubscriptionProduct copyWith({
    String? id,
    String? stripeProductId,
    String? stripePriceId,
    String? productName,
    Map<String, String>? description,
    String? productType,
    double? price,
    String? subscriptionDuration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionProduct(
      id: id ?? this.id,
      stripeProductId: stripeProductId ?? this.stripeProductId,
      stripePriceId: stripePriceId ?? this.stripePriceId,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      productType: productType ?? this.productType,
      price: price ?? this.price,
      subscriptionDuration: subscriptionDuration ?? this.subscriptionDuration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

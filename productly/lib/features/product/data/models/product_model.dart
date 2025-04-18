import 'package:productly/features/product/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] is int) 
          ? (json['price'] as int).toDouble() 
          : json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: ProductRatingModel.fromJson(json['rating']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': (rating as ProductRatingModel).toJson(),
    };
  }
}

class ProductRatingModel extends ProductRating {
  const ProductRatingModel({
    required super.rate,
    required super.count,
  });

  factory ProductRatingModel.fromJson(Map<String, dynamic> json) {
    return ProductRatingModel(
      rate: (json['rate'] is int) 
          ? (json['rate'] as int).toDouble() 
          : json['rate'].toDouble(),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
} 
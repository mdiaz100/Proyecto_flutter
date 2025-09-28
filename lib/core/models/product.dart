import 'package:ecommerce_games/domain/entities/product_entity.dart';

class Product extends ProductEntity {
  Product({
    super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.brand,
    required super.category,
    required super.thumbnail,
    super.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'price': price,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
    };
    if (images != null && images!.isNotEmpty) {
      map['images'] = images;
    }
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Map<String, dynamic> toJsonForCreate() {
    final map = {
      'title': title,
      'description': description,
      'price': price,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
    };
    if (images != null && images!.isNotEmpty) {
      map['images'] = 'images'; 
    }
    return map;
  }
}


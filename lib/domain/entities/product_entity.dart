class ProductEntity {
  final int? id;
  final String title;
  final String description;
  final double price;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String>? images;

  ProductEntity({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.brand,
    required this.category,
    required this.thumbnail,
    this.images,
  });

  ProductEntity copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? brand,
    String? category,
    String? thumbnail,
    List<String>? images,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
    );
  }
}


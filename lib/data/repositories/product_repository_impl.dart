import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../../core/models/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;

  ProductRepositoryImpl({ required this.remote });

  @override
  Future<List<ProductEntity>> getProducts({ int skip = 0, int limit = 100 }) {
    return remote.fetchProductList(skip: skip, limit: limit);
  }

  @override
  Future<ProductEntity> getProductById(int id) {
    return remote.fetchProductById(id);
  }

  @override
  Future<ProductEntity> addProduct(ProductEntity product) {
    return remote.createProduct(Product(
      id: product.id,
      title: product.title,
      description: product.description,
      price: product.price,
      brand: product.brand,
      category: product.category,
      thumbnail: product.thumbnail,
      images: product.images,
    ));
  }

  @override
  Future<ProductEntity> editProduct(ProductEntity product) {
    return remote.updateProduct(Product(
      id: product.id,
      title: product.title,
      description: product.description,
      price: product.price,
      brand: product.brand,
      category: product.category,
      thumbnail: product.thumbnail,
      images: product.images,
    ));
  }

  @override
  Future<void> removeProduct(int id) {
    return remote.deleteProduct(id);
  }

  @override
  Future<List<ProductEntity>> search(String query) {
    return remote.searchProducts(query);
  }
}

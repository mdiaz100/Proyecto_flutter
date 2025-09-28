import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({ int skip, int limit });
  Future<ProductEntity> getProductById(int id);
  Future<ProductEntity> addProduct(ProductEntity product);
  Future<ProductEntity> editProduct(ProductEntity product);
  Future<void> removeProduct(int id);
  Future<List<ProductEntity>> search(String query);
}

import '../../core/models/product.dart';
import '../../core/network/api_client.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> fetchProductList({int skip, int limit});
  Future<Product> fetchProductById(int id);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(int id);
  Future<List<Product>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Product>> fetchProductList({int skip = 0, int limit = 10}) async {
    final resp = await client.get(
      '/products',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final data = resp.data as Map<String, dynamic>;
    final List<dynamic> list = data['products'];
    return list.map((e) => Product.fromJson(e)).toList();
  }

  @override
  Future<Product> fetchProductById(int id) async {
    final resp = await client.get('/products/$id');
    return Product.fromJson(resp.data);
  }

  @override
Future<Product> createProduct(Product product) async {
  final resp = await client.post('/products/add', product.toJsonForCreate());
  return Product.fromJson(resp.data);
}


  @override
  Future<Product> updateProduct(Product product) async {
    if (product.id == null) {
      throw Exception("Product id is null");
    }

    final body = {
    'title': product.title,
    'description': product.description,
    'price': product.price,
    'brand': product.brand,
    'category': product.category,
    'thumbnail': product.thumbnail, 
    'images': product.images,       
  };

    final resp = await client.patch('/products/${product.id}', body);
    return Product.fromJson(resp.data);
  }

  @override
  Future<void> deleteProduct(int id) async {
    final resp = await client.delete('/products/$id');
    print("Deleted product: ${resp.data}");
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final resp = await client.get(
      '/products/search',
      queryParameters: {'q': query},
    );
    final data = resp.data as Map<String, dynamic>;
    final List<dynamic> list = data['products'];
    return list.map((e) => Product.fromJson(e)).toList();
  }
}

import 'package:flutter/foundation.dart';
import '../domain/entities/product_entity.dart';
import '../domain/repositories/product_repository.dart';

enum ProductState { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider({required this.repository});

  ProductState _state = ProductState.initial;
  ProductState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ProductEntity> _products = [];
  List<ProductEntity> get products => _products;

  ProductEntity? _selected;
  ProductEntity? get selected => _selected;

  int _localIdCounter = -1;

  Future<void> loadProducts({int skip = 0, int limit = 10}) async {
    if (skip == 0) {
      _products = [];
      _state = ProductState.loading;
      notifyListeners();
    }

    try {
      final list = await repository.getProducts(skip: skip, limit: limit);

      if (list.isNotEmpty) {
        _products.addAll(list);
      }
      _state = ProductState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProductState.error;
    }

    notifyListeners();
  }

  Future<void> loadProductDetail(int id) async {
    _state = ProductState.loading;
    notifyListeners();
    try {
      final prod = await repository.getProductById(id);
      _selected = prod;
      _state = ProductState.loaded;
    } catch (e) {
      _selected = _products.firstWhere(
        (p) => p.id == id,
        orElse: () => ProductEntity(
          id: id,
          title: "Desconocido",
          description: "",
          price: 0,
          brand: "",
          category: "",
          thumbnail: "",
        ),
      );
      _errorMessage = e.toString();
      _state = ProductState.error;
    }
    notifyListeners();
  }

  Future<bool> addProduct(ProductEntity product) async {
    _state = ProductState.loading;
    notifyListeners();
    try {
      final newProd = await repository.addProduct(product);
      _products.add(newProd);
      _state = ProductState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      final localProd = product.copyWith(id: _localIdCounter--);
      _products.add(localProd);
      _state = ProductState.loaded;
      notifyListeners();
      return true;
    }
  }

  Future<bool> updateProduct(ProductEntity product) async {
    _state = ProductState.loading;
    notifyListeners();
    try {
      final updated = await repository.editProduct(product);
      int idx = _products.indexWhere((p) => p.id == updated.id);
      if (idx >= 0) {
        _products[idx] = updated;
      }
      _state = ProductState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      int idx = _products.indexWhere((p) => p.id == product.id);
      if (idx >= 0) {
        _products[idx] = product;
      }
      _state = ProductState.loaded;
      notifyListeners();
      return true;
    }
  }

  Future<bool> deleteProduct(int id) async {
    _state = ProductState.loading;
    notifyListeners();
    try {
      await repository.removeProduct(id);
      _products.removeWhere((p) => p.id == id);
      _state = ProductState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _products.removeWhere((p) => p.id == id);
      _state = ProductState.loaded;
      notifyListeners();
      return true;
    }
  }

  Future<void> searchProducts(String query) async {
    _state = ProductState.loading;
    notifyListeners();
    try {
      final list = await repository.search(query);
      _products = list;
      _state = ProductState.loaded;
    } catch (e) {
      _products = _products
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _errorMessage = e.toString();
      _state = ProductState.error;
    }
    notifyListeners();
  }
}

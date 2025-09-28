import 'package:ecommerce_games/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  int skip = 0;
  final int limit = 30;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<ProductProvider>(context, listen: false);
      skip = 0;
      prov.loadProducts(skip: skip, limit: limit);

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 100 &&
            !_isLoadingMore) {
          _loadMoreProducts();
        }
      });
    });
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });

    final prov = Provider.of<ProductProvider>(context, listen: false);
    skip += limit;
    await prov.loadProducts(skip: skip, limit: limit);

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catálogo"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, prov, _) {
          if (prov.state == ProductState.loading && prov.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
              ),
            );
          } else if (prov.state == ProductState.error && prov.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "Error: ${prov.errorMessage}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      skip = 0;
                      prov.loadProducts(skip: skip, limit: limit);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reintentar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: prov.products.length,
                  itemBuilder: (context, index) {
                    final prod = prov.products[index];
                    return _ProductCard(product: prod);
                  },
                ),
              ),
              if (_isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductEntity product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  height: 90,
                  color: Colors.grey[100],
                  child: product.thumbnail.isNotEmpty
                      ? Image.network(
                          product.thumbnail,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.shopping_bag,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(
                            Icons.shopping_bag,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        "\$${product.price}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final ScrollController _searchScrollController = ScrollController();
  int _searchSkip = 0;
  final int _searchLimit = 30;
  bool _isSearchLoadingMore = false;
  String _currentQuery = '';

  @override
  String get searchFieldLabel => "Buscar productos...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            final prov = Provider.of<ProductProvider>(context, listen: false);
            prov.loadProducts(skip: 0, limit: 30);
            close(context, null);
          } else {
            query = "";
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        final prov = Provider.of<ProductProvider>(context, listen: false);
        prov.loadProducts(skip: 0, limit: 30);
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Inicializar el scroll controller y resetear variables cuando cambia la query
    if (_currentQuery != query) {
      _currentQuery = query;
      _searchSkip = 0;
      _isSearchLoadingMore = false;
      
      final prov = Provider.of<ProductProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        prov.searchProducts(query);
      });
    }

    // Configurar el listener para infinite scroll en búsqueda
    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels >=
              _searchScrollController.position.maxScrollExtent - 100 &&
          !_isSearchLoadingMore) {
        _loadMoreSearchResults(context);
      }
    });

    return Consumer<ProductProvider>(
      builder: (context, prov, _) {
        if (prov.state == ProductState.loading && prov.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
            ),
          );
        } else if (prov.state == ProductState.error && prov.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "Error: ${prov.errorMessage}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (prov.products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No se encontraron productos",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _searchScrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: prov.products.length,
                itemBuilder: (context, index) {
                  final prod = prov.products[index];
                  return _ProductCard(product: prod);
                },
              ),
            ),
            if (_isSearchLoadingMore)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _loadMoreSearchResults(BuildContext context) async {
    if (_isSearchLoadingMore) return;
    
    _isSearchLoadingMore = true;
    
    final prov = Provider.of<ProductProvider>(context, listen: false);
    _searchSkip += _searchLimit;
    
    // Para la búsqueda, necesitamos cargar más productos y luego filtrar
    // o implementar una búsqueda paginada en tu repository
    await prov.loadProducts(skip: _searchSkip, limit: _searchLimit);
    
    _isSearchLoadingMore = false;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Escribe para buscar productos...",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchScrollController.dispose();
    super.dispose();
  }
}
import 'package:ecommerce_games/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'product_form_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailScreen({required this.product, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductEntity product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: product.thumbnail.isNotEmpty
                      ? Image.network(
                          product.thumbnail,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 220,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.shopping_bag,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 220,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.shopping_bag,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Información del producto
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          Chip(
                            label: Text(
                              product.category,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.indigo,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.business, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            product.brand,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "edit",
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            elevation: 4,
            child: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push<ProductEntity?>(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductFormScreen(product: product),
                ),
              );
              if (updated != null) {
                setState(() => product = updated);
              }
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "delete",
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 4,
            child: const Icon(Icons.delete),
            onPressed: () async {
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Eliminar Producto"),
                  content: const Text("¿Estás seguro de que quieres eliminar este producto?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text("Eliminar"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                bool ok = await prov.deleteProduct(product.id!);
                if (ok) {
                  if (!mounted) return;
                  Navigator.pop(context);
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("No se pudo eliminar"),
                      backgroundColor: Colors.red[400],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}


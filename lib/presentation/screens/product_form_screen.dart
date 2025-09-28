import 'package:ecommerce_games/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductEntity? product;
  const ProductFormScreen({this.product, super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String description;
  late String priceStr;
  late String brand;
  late String category;
  late String thumbnail;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    title = p?.title ?? "";
    description = p?.description ?? "";
    priceStr = p != null ? p.price.toString() : "";
    brand = p?.brand ?? "";
    category = p?.category ?? "";
    thumbnail = p?.thumbnail ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? "Nuevo producto" : "Editar producto"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildField("Título", title, (v) => title = v!),
                    const SizedBox(height: 16),
                    _buildField("Descripción", description, (v) => description = v!, maxLines: 3),
                    const SizedBox(height: 16),
                    _buildField("Precio", priceStr, (v) => priceStr = v!,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Requerido";
                          if (double.tryParse(v) == null) return "Debe ser número";
                          return null;
                        }),
                    const SizedBox(height: 16),
                    _buildField("Marca", brand, (v) => brand = v!),
                    const SizedBox(height: 16),
                    _buildField("Categoría", category, (v) => category = v!),
                    const SizedBox(height: 16),
                    _buildField("URL Imagen", thumbnail, (v) => thumbnail = v!),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(widget.product == null ? "Crear Producto" : "Guardar Cambios"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          double price = double.parse(priceStr);

                          final p = ProductEntity(
                            id: widget.product?.id,
                            title: title,
                            description: description,
                            price: price,
                            brand: brand,
                            category: category,
                            thumbnail: thumbnail,
                          );

                          bool ok;
                          if (widget.product == null) {
                            ok = await prov.addProduct(p);
                            if (ok) Navigator.pop(context, p);
                          } else {
                            ok = await prov.updateProduct(p);
                            if (ok) Navigator.pop(context, p);
                          }

                          if (!ok) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Error al guardar"),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    String initial,
    FormFieldSetter<String> onSaved, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initial,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator ?? (v) => v == null || v.isEmpty ? "Requerido" : null,
      onSaved: onSaved,
    );
  }
}


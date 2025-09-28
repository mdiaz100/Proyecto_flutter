import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'providers/product_provider.dart';
import 'presentation/screens/product_list_screen.dart';
import 'themes/app_theme.dart';

void main() {
  final apiClient = ApiClient();
  final remote = ProductRemoteDataSourceImpl(client: apiClient);
  final repo = ProductRepositoryImpl(remote: remote);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(repository: repo),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD DummyJSON Demo',
      theme: AppTheme.light,
      home: ProductListScreen(),
    );
  }
}

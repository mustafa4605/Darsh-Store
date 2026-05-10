import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/providers/api_provider.dart';

final productProvider = FutureProvider<List<Product>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchProducts();
});

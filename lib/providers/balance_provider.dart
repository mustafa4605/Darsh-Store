import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/api_provider.dart';

final balanceProvider = FutureProvider<double>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchBalance();
});

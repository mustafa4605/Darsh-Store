import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/models/product.dart';

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Use the official Base URL provided
  static const String _baseUrl = 'https://8080-98eff0d3-e622-43d1-8364-369ea69de8fa.preview.reflex-hq.com';

  ApiService() : _dio = Dio(BaseOptions(baseUrl: _baseUrl)) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle errors globally if needed
        print('Dio Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  // Corresponds to /api/login
  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post('/api/login', data: {
        'username': username,
        'password': password,
      });
      if (response.data != null && response.data['token'] != null) {
        final token = response.data['token'];
        await _secureStorage.write(key: 'auth_token', value: token);
        return token;
      } else {
        throw Exception('Login failed: Token not found in response');
      }
    } catch (e) {
      print('Login Error: $e');
      throw Exception('Failed to login');
    }
  }

  // Corresponds to /api/register
  Future<void> signUp(String username, String password) async {
    try {
      await _dio.post('/api/register', data: {
        'username': username,
        'password': password,
      });
    } catch (e) {
      print('SignUp Error: $e');
      throw Exception('Failed to sign up');
    }
  }

  // Corresponds to /api/google-auth
  Future<String> googleSignIn(String idToken) async {
    try {
      final response = await _dio.post('/api/google-auth', data: {
        'token': idToken,
      });
       if (response.data != null && response.data['token'] != null) {
        final token = response.data['token'];
        await _secureStorage.write(key: 'auth_token', value: token);
        return token;
      } else {
        throw Exception('Google Sign-In failed: Token not found');
      }
    } catch (e) {
      print('Google SignIn Error: $e');
      throw Exception('Failed to sign in with Google');
    }
  }

  // Corresponds to /api/products
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('/api/products');
      final List<dynamic> productList = response.data;
      return productList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Fetch Products Error: $e');
      throw Exception('Failed to fetch products');
    }
  }

  // Corresponds to /api/get_balance
  Future<double> fetchBalance() async {
    try {
      final response = await _dio.get('/api/get_balance');
      if (response.data != null && response.data['balance'] != null) {
        return (response.data['balance'] as num).toDouble();
      } else {
        throw Exception('Failed to parse balance');
      }
    } catch (e) {
      print('Fetch Balance Error: $e');
      throw Exception('Failed to fetch balance');
    }
  }

  // Placeholder for /api/orders
  Future<dynamic> fetchOrders() async {
     try {
      final response = await _dio.get('/api/orders');
      return response.data;
    } catch (e) {
      print('Fetch Orders Error: $e');
      throw Exception('Failed to fetch orders');
    }
  }

  // Placeholder for /api/transactions
  Future<dynamic> fetchTransactions() async {
     try {
      final response = await _dio.get('/api/transactions');
      return response.data;
    } catch (e) {
      print('Fetch Transactions Error: $e');
      throw Exception('Failed to fetch transactions');
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/product_page.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ProductApi {
  ProductApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _host = 'dummyjson.com';

  // GET /products?limit=20&skip=0
  Future<ProductPage> getProducts({int limit = 20, int skip = 0}) async {
    final uri = Uri.https(_host, '/products', {'limit': '$limit', 'skip': '$skip'});
    return ProductPage.fromJson(await _get(uri));
  }

  // GET /products/1
  Future<Product> getProduct(int id) async {
    final uri = Uri.https(_host, '/products/$id');
    return Product.fromJson(await _get(uri));
  }

  // GET /products/search?q=phone
  Future<ProductPage> search(String query) async {
    final uri = Uri.https(_host, '/products/search', {'q': query});
    return ProductPage.fromJson(await _get(uri));
  }

  // The ONLY place that talks HTTP and decodes JSON
  Future<Map<String, dynamic>> _get(Uri uri) async {
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('The server is taking too long. Please try again.');
    } on http.ClientException {
      throw const ApiException('No internet connection. Check your network and try again.');
    }

    if (response.statusCode == 404) {
      throw const ApiException('We could not find that product.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Server error (${response.statusCode}). Please try again later.');
    }

    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw const ApiException('The server sent data we could not read.');
    }
  }
}
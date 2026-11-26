import 'dart:convert';
import 'dart:io';

import 'package:api_catalog/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Product.fromJson parses the saved fixture', () {
    final json = jsonDecode(File('test/fixtures/product.json').readAsStringSync())
        as Map<String, dynamic>;
    final product = Product.fromJson(json);

    expect(product.title, 'Essence Mascara Lash Princess');
    expect(product.price, isA<double>());
    expect(product.price, 9.99);
    expect(product.tags, ['beauty', 'mascara']);
    expect(product.reviews, hasLength(3));
  });

  test('missing brand and tags do not crash', () {
    final product = Product.fromJson({
      'id': 99,
      'title': 'No brand product',
      'price': 10, // int on purpose: must still become a double
      'rating': 4,
      'thumbnail': 'x.png',
      'dimensions': {'width': 1, 'height': 2, 'depth': 3},
    });

    expect(product.brand, isNull);
    expect(product.tags, isEmpty); // our decision: empty list
    expect(product.price, 10.0);
  });
}
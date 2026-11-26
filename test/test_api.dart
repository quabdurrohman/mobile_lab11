import 'dart:io';

import 'package:api_catalog/data/product_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final productJson = File('test/fixtures/product.json').readAsStringSync();
  const jsonHeaders = {'content-type': 'application/json; charset=utf-8'};

  test('getProducts returns a page with one product', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/products');
      return http.Response(
        '{"products": [$productJson], "total": 1, "skip": 0, "limit": 20}',
        200,
        headers: jsonHeaders,
      );
    });

    final page = await ProductApi(client: client).getProducts();

    expect(page.products, hasLength(1));
    expect(page.products.first.title, 'Essence Mascara Lash Princess');
    expect(page.total, 1);
  });

  test('getProduct throws ApiException on 404', () async {
    final client = MockClient(
      (_) async => http.Response('{"message": "not found"}', 404, headers: jsonHeaders),
    );

    await expectLater(
      ProductApi(client: client).getProduct(0),
      throwsA(isA<ApiException>()),
    );
  });
}
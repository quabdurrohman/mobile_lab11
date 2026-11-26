import 'dart:io';

import 'package:api_catalog/bloc/search_bloc.dart';
import 'package:api_catalog/bloc/search_event.dart';
import 'package:api_catalog/bloc/search_state.dart';
import 'package:api_catalog/data/product_api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final productJson = File('test/fixtures/product.json').readAsStringSync();
  const headers = {'content-type': 'application/json; charset=utf-8'};

  ProductApi fakeApi() => ProductApi(
        client: MockClient((_) async => http.Response(
              '{"products": [$productJson], "total": 1, "skip": 0, "limit": 30}',
              200,
              headers: headers,
            )),
      );

  blocTest<SearchBloc, SearchState>(
    'phone gives Loading then Results',
    build: () => SearchBloc(fakeApi()),
    act: (bloc) => bloc.add(const SearchSubmitted('phone')),
    expect: () => [isA<SearchLoading>(), isA<SearchResults>()],
  );

  blocTest<SearchBloc, SearchState>(
    'blank query gives only Idle',
    build: () => SearchBloc(fakeApi()),
    act: (bloc) => bloc.add(const SearchSubmitted('   ')),
    expect: () => [isA<SearchIdle>()],
  );
}
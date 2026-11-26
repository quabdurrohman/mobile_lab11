import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/products_cubit.dart';
import 'data/product_api.dart';
import 'screens/products_screen.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ProductApi(), // one API for the whole app
      child: MaterialApp(
        title: 'API Catalog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        // lets you pull-to-refresh with the mouse in the browser
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        home: BlocProvider(
          create: (c) => ProductsCubit(c.read<ProductApi>())..load(),
          child: const ProductsScreen(),
        ),
      ),
    );
  }
}
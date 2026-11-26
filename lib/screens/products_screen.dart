import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/details_cubit.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../data/product_api.dart';
import '../models/product.dart';
import '../widgets/product_tile.dart';
import 'details_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  void _openDetails(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (c) => DetailsCubit(c.read<ProductApi>(), product.id)..load(),
          child: const DetailsScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {}, // wired to the search screen in Part 5
          ),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) => switch (state) {
          ProductsLoading() => const Center(child: CircularProgressIndicator()),
          ProductsError(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48),
                    const SizedBox(height: 12),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.read<ProductsCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          final ProductsLoaded loaded => RefreshIndicator(
              onRefresh: () => context.read<ProductsCubit>().refresh(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                // one extra row at the end for "Load more", only while hasMore
                itemCount: loaded.products.length + (loaded.hasMore ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == loaded.products.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: loaded.isLoadingMore
                            ? const CircularProgressIndicator()
                            : OutlinedButton(
                                onPressed: () => context.read<ProductsCubit>().loadMore(),
                                child: Text(
                                  'Load more (${loaded.products.length} of ${loaded.total})',
                                ),
                              ),
                      ),
                    );
                  }
                  final product = loaded.products[i];
                  return ProductTile(product, onTap: () => _openDetails(context, product));
                },
              ),
            ),
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../cubit/details_cubit.dart';
import '../data/product_api.dart';
import '../models/product.dart';
import '../widgets/product_tile.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDetails(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (c) => DetailsCubit(c.read<ProductApi>(), product.id)..load(),
          child: const DetailsScreen(),
        ),
      ),
    );
  }

  Widget _message(IconData icon, String text) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(text, textAlign: TextAlign.center),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search products…',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                context.read<SearchBloc>().add(const SearchCleared());
              },
            ),
          ),
          onSubmitted: (text) => context.read<SearchBloc>().add(SearchSubmitted(text)),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => switch (state) {
          SearchIdle() => _message(Icons.search, 'Type a product name and press Enter'),
          SearchLoading() => const Center(child: CircularProgressIndicator()),
          SearchEmpty(:final query) => _message(Icons.search_off, 'No products match "$query"'),
          SearchError(:final message) => _message(Icons.cloud_off, message),
          SearchResults(:final products) => ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, i) =>
                  ProductTile(products[i], onTap: () => _openDetails(products[i])),
            ),
        },
      ),
    );
  }
}
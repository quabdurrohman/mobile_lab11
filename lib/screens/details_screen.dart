import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/details_cubit.dart';
import '../cubit/details_state.dart';
import '../models/product.dart';
import '../models/review.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, state) => switch (state) {
          DetailsLoading() => const Center(child: CircularProgressIndicator()),
          DetailsError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<DetailsCubit>().load(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          DetailsLoaded(:final product) => _DetailsBody(product),
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final d = product.dimensions;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Images: horizontal scroll
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: product.images.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.images[i],
                width: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(width: 220, child: Icon(Icons.image_not_supported, size: 48)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(product.title, style: text.headlineSmall),
        const SizedBox(height: 4),
        Text(
          '\$${product.price.toStringAsFixed(2)} · ★ ${product.rating.toStringAsFixed(1)}'
          '${product.brand != null ? ' · ${product.brand}' : ''}',
          style: text.titleMedium,
        ),
        const SizedBox(height: 16),
        Text(product.description),
        const SizedBox(height: 16),
        Text('Dimensions', style: text.titleMedium),
        Text('${d.width} × ${d.height} × ${d.depth} cm'),
        const SizedBox(height: 16),
        Text('Reviews (${product.reviews.length})', style: text.titleMedium),
        const SizedBox(height: 8),
        for (final review in product.reviews) _ReviewCard(review),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard(this.review);
  final Review review;

  @override
  Widget build(BuildContext context) {
    final date = review.date.toLocal().toString().split(' ').first; // 2025-04-30
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (var i = 0; i < 5; i++)
                  Icon(i < review.rating ? Icons.star : Icons.star_border,
                      size: 18, color: Colors.amber),
                const Spacer(),
                Text(date, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 4),
            Text(review.reviewerName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(review.comment),
          ],
        ),
      ),
    );
  }
}
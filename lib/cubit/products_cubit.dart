import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_api.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._api) : super(const ProductsLoading());
  final ProductApi _api;

  Future<void> load() async {
    emit(const ProductsLoading());
    await _fetchFirstPage();
  }

  // Pull-to-refresh: keep the list on screen while reloading (no spinner flash)
  Future<void> refresh() => _fetchFirstPage();

  Future<void> _fetchFirstPage() async {
    try {
      final page = await _api.getProducts();
      if (isClosed) return;
      emit(ProductsLoaded(page.products, total: page.total));
    } on ApiException catch (e) {
      if (!isClosed) emit(ProductsError(e.message));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    // Guard: only when loaded, more exists, and not already loading (T11)
    if (current is! ProductsLoaded || current.isLoadingMore || !current.hasMore) return;

    emit(ProductsLoaded(current.products, total: current.total, isLoadingMore: true));
    try {
      final page = await _api.getProducts(skip: current.products.length);
      if (isClosed) return;
      emit(ProductsLoaded([...current.products, ...page.products], total: page.total));
    } on ApiException {
      // Keep what we had; the button comes back so the user can tap again
      if (!isClosed) emit(ProductsLoaded(current.products, total: current.total));
    }
  }
} 
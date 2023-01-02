part of 'product_search_bloc.dart';

abstract class ProductSearchState extends Equatable {
  const ProductSearchState();

  @override
  List<Object> get props => [];
}

class ProductSearchLoading extends ProductSearchState {}

class ProductSearchLoaded extends ProductSearchState {
  final List<Product> products;

  const ProductSearchLoaded(this.products);
  @override
  List<Object> get props => [products];
}

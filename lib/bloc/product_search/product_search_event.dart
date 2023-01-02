part of 'product_search_bloc.dart';

abstract class ProductSearchEvent extends Equatable {
  const ProductSearchEvent();

  @override
  List<Object> get props => [];
}

class UpdateProduct extends ProductSearchEvent {
  final List<Product> products;

  const UpdateProduct(this.products);
  @override
  List<Object> get props => [products];
}

class SearchProduct extends ProductSearchEvent {
  final String keyword;

  const SearchProduct(this.keyword);
  @override
  List<Object> get props => [keyword];
}

class GetAllOutOfStock extends ProductSearchEvent {}

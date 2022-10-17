part of 'product_category_bloc.dart';

abstract class ProductCategoryState extends Equatable {
  const ProductCategoryState();

  @override
  List<Object> get props => [];
}

class ProductCategoryLoading extends ProductCategoryState {}

class ProductCategoryLoaded extends ProductCategoryState {
  final List<Product> coffee;
  final List<Product> milktea;
  final List<Product> dimsum;

  const ProductCategoryLoaded(
      {this.coffee = const <Product>[],
      this.milktea = const <Product>[],
      this.dimsum = const <Product>[]});

  @override
  List<Object> get props => [coffee, milktea, dimsum];
}

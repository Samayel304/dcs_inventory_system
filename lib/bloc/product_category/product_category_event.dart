part of 'product_category_bloc.dart';

abstract class ProductCategoryEvent extends Equatable {
  const ProductCategoryEvent();

  @override
  List<Object> get props => [];
}

class UpdateProductCategory extends ProductCategoryEvent {
  final List<Product> products;

  const UpdateProductCategory({this.products = const <Product>[]});

  @override
  List<Object> get props => [products];
}

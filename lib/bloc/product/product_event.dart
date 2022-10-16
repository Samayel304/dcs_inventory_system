part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class UpdateProducts extends ProductEvent {
  final List<Product> products;

  const UpdateProducts({
    this.products = const <Product>[],
  });

  @override
  List<Object> get props => [products];
}

class AddProduct extends ProductEvent {
  final Product product;

  const AddProduct(
    this.product,
  );

  @override
  List<Object> get props => [product];
}

class DeductProductQuantity extends ProductEvent {
  final Product product;

  const DeductProductQuantity(
    this.product,
  );

  @override
  List<Object> get props => [product];
}

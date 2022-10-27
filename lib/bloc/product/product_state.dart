part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductsLoaded({
    this.products = const <Product>[],
  });

  @override
  List<Object> get props => [products];
}

class Success extends ProductState {
  final String successMessage;
  const Success({this.successMessage = ""});
  @override
  List<Object> get props => [successMessage];
}

class Error extends ProductState {
  final String errorMessage;
  const Error({this.errorMessage = ""});
  @override
  List<Object> get props => [errorMessage];
}

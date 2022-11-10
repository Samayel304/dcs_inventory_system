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
  final int deductedQuantity;

  const DeductProductQuantity(this.product, this.deductedQuantity);

  @override
  List<Object> get props => [product, deductedQuantity];
}

class EditProduct extends ProductEvent {
  final Product product;

  const EditProduct(
    this.product,
  );

  @override
  List<Object> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final Product product;

  const DeleteProduct(
    this.product,
  );

  @override
  List<Object> get props => [product];
}

class SearchProducts extends ProductEvent {
  final String keyword;

  const SearchProducts(this.keyword);

  @override
  List<Object> get props => [keyword];
}

class ExportToExcel extends ProductEvent {}

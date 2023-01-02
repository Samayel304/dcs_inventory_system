part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
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
  final File image;
  final BuildContext context;

  const AddProduct(
    this.product,
    this.image,
    this.context,
  );

  @override
  List<Object> get props => [product, context, image];
}

class DeductProductQuantity extends ProductEvent {
  final Product product;
  final int deductedQuantity;
  final BuildContext context;
  const DeductProductQuantity(
      this.product, this.deductedQuantity, this.context);

  @override
  List<Object> get props => [product, deductedQuantity, context];
}

class EditProduct extends ProductEvent {
  final Product product;
  final File? image;
  final BuildContext context;
  const EditProduct(this.product, this.image, this.context);

  @override
  List<Object?> get props => [product, image, context];
}

class DeleteProduct extends ProductEvent {
  final Product product;
  final BuildContext context;
  const DeleteProduct(this.product, this.context);

  @override
  List<Object> get props => [product, context];
}

class SearchProducts extends ProductEvent {
  final String keyword;

  const SearchProducts(this.keyword);

  @override
  List<Object> get props => [keyword];
}

class ExportItems extends ProductEvent {
  final BuildContext context;
  const ExportItems(this.context);
  @override
  List<Object> get props => [context];
}

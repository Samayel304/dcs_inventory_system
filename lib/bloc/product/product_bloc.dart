import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';
import '../../repositories/product/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription? _productSubscription;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductsLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<UpdateProducts>(_onUpdateProducts);
    on<AddProduct>(_onAddProduct);
    on<DeductProductQuantity>(_onDeductProductQuantity);
    on<EditProduct>(_onEditProduct);
  }

  void _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
          (products) => add(
            UpdateProducts(products: products),
          ),
        );

    //emit(ProductsLoaded(products: products));
  }

  void _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    if (state is ProductsLoaded) {
      try {
        await _productRepository.createProduct(event.product);

        //       emit(ProductsLoaded(
        //       products: List.from((state as ProductsLoaded).products)
        //       ..add(event.product),
        //  ));
      } catch (_) {}
    }
  }

  void _onDeductProductQuantity(
      DeductProductQuantity event, Emitter<ProductState> emit) async {
    if (state is ProductsLoaded) {
      try {
        await _productRepository.deductProductQuantity(event.product);
        //List<Product> productList = List.of((state as ProductsLoaded).products);
        //productList.contains(event.product)
        //  ? productList[productList
        //        .indexWhere((product) => product == event.product)]
        //  .copyWith(quantity: event.product.quantity)
        //: productList;

        // emit(ProductsLoaded(products: productList));
      } catch (_) {}
    }
  }

  void _onEditProduct(EditProduct event, Emitter<ProductState> emit) async {
    if (state is ProductsLoaded) {
      try {
        await _productRepository.editProductDetails(event.product);
      } catch (_) {}
    }
  }

  void _onUpdateProducts(UpdateProducts event, Emitter<ProductState> emit) {
    emit(ProductsLoaded(products: event.products));
  }

  @override
  Future<void> close() async {
    _productSubscription?.cancel();
    super.close();
  }
}

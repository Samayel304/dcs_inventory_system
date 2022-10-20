import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/utils/constant.dart';
import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';

part 'product_category_event.dart';
part 'product_category_state.dart';

class ProductCategoryBloc
    extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  final ProductBloc _productBloc;
  late StreamSubscription _productSubscription;

  ProductCategoryBloc({required ProductBloc productBloc})
      : _productBloc = productBloc,
        super(ProductCategoryLoading()) {
    on<UpdateProductCategory>(_onUpdateProductCategory);
    _productSubscription = _productBloc.stream.listen((state) {
      if (state is ProductsLoaded) {
        add(UpdateProductCategory(products: state.products));
      }
    });
  }

  _onUpdateProductCategory(
      UpdateProductCategory event, Emitter<ProductCategoryState> emit) {
    List<Product> coffee = event.products
        .where((product) => product.category == ProductCategory.coffee.name)
        .toList();
    List<Product> milktea = event.products
        .where((product) => product.category == ProductCategory.milktea.name)
        .toList();
    List<Product> dimsum = event.products
        .where((product) => product.category == ProductCategory.dimsum.name)
        .toList();

    emit(ProductCategoryLoaded(
        coffee: coffee, milktea: milktea, dimsum: dimsum));
  }

  @override
  Future<void> close() {
    _productSubscription.cancel();
    return super.close();
  }
}

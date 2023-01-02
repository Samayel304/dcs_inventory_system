import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:equatable/equatable.dart';

part 'product_search_event.dart';
part 'product_search_state.dart';

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  final ProductBloc _productBloc;
  late StreamSubscription _productBlocSteamSubscription;
  ProductSearchBloc({required ProductBloc productBloc})
      : _productBloc = productBloc,
        super(productBloc.state is ProductsLoaded
            ? ProductSearchLoaded(
                (productBloc.state as ProductsLoaded).products)
            : ProductSearchLoading()) {
    on<UpdateProduct>(_onUpdateProduct);
    on<SearchProduct>(_onSearchProduct);
    on<GetAllOutOfStock>(_onGetAllOutOfStock);

    _productBlocSteamSubscription = _productBloc.stream.listen((state) {
      if (state is ProductsLoaded) {
        add(UpdateProduct(state.products));
      }
    });
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<ProductSearchState> emit) {
    emit(ProductSearchLoaded(event.products));
  }

  void _onSearchProduct(SearchProduct event, Emitter<ProductSearchState> emit) {
    List<Product> products = (_productBloc.state as ProductsLoaded).products;
    if (event.keyword.isEmpty) {
      add(UpdateProduct(products));
    } else {
      List<Product> result = products
          .where((product) => product.productName.contains(event.keyword))
          .toList();
      add(UpdateProduct(result));
    }
  }

  void _onGetAllOutOfStock(
      GetAllOutOfStock event, Emitter<ProductSearchState> emit) {
    List<Product> products = (_productBloc.state as ProductsLoaded).products;
    List<Product> outOfStockProducts = products
        .where((product) => product.isNew == false && product.quantity == 0)
        .toList();
    add(UpdateProduct(outOfStockProducts));
  }

  @override
  Future<void> close() async {
    _productBlocSteamSubscription.cancel();
    super.close();
    ;
  }
}

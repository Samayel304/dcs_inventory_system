import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/activity_log/activity_log_bloc.dart';
import 'package:dcs_inventory_system/bloc/auth/auth_bloc.dart';
import 'package:dcs_inventory_system/utils/constant.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/model.dart';

import '../../repositories/repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AuthBloc _authBloc;
  final ProductRepository _productRepository;
  final ActivityLogBloc _activityLogBloc;
  StreamSubscription? _productSubscription;

  ProductBloc(
      {required ProductRepository productRepository,
      required ActivityLogBloc activityLogBloc,
      required AuthBloc authBloc})
      : _productRepository = productRepository,
        _activityLogBloc = activityLogBloc,
        _authBloc = authBloc,
        super(ProductsLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<UpdateProducts>(_onUpdateProducts);
    on<AddProduct>(_onAddProduct);
    on<DeductProductQuantity>(_onDeductProductQuantity);
    on<EditProduct>(_onEditProduct);
    on<SearchProducts>(_onSearchProducts);
    on<ExportToExcel>(_onExportToExcel);
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
  }

  void _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    final state = this.state;
    if (state is ProductsLoaded) {
      try {
        emit(ProductsLoading());
        if (state.products
            .where((product) =>
                product.productName.toLowerCase() ==
                event.product.productName.toLowerCase())
            .isNotEmpty) {
          emit(const Error(
              errorMessage: "The product with the same name already exist."));
          emit(ProductsLoaded(products: state.products));
        } else {
          emit(const Success(successMessage: "Successfully Added"));
          await _productRepository.createProduct(event.product);

          User user = _authBloc.state.user!;
          String userFullname =
              '${user.firstName} ${user.middleName} ${user.lastName}';
          ActivityLog activityLog = ActivityLog(
              dateCreated: Timestamp.now().toDate(),
              user: user,
              activity: user.role == UserRole.admin.name
                  ? 'You created a product named ${event.product.productName}'
                  : '$userFullname created a product named ${event.product.productName}');
          _activityLogBloc.add(AddActivityLog(activityLog: activityLog));
        }
      } catch (_) {}
    }
  }

  void _onDeductProductQuantity(
      DeductProductQuantity event, Emitter<ProductState> emit) async {
    if (state is ProductsLoaded) {
      try {
        emit(const Success(successMessage: "Success"));
        await _productRepository.editProductDetails(event.product);
        User user = _authBloc.state.user!;
        String userFullname =
            '${user.firstName} ${user.middleName} ${user.lastName}';
        ActivityLog activityLog = ActivityLog(
            dateCreated: Timestamp.now().toDate(),
            user: user,
            activity: user.role == UserRole.admin.name
                ? 'You deducted ${event.product.productName}\'s quantity by ${event.deductedQuantity}'
                : '$userFullname deducted ${event.product.productName}\'s quantity by ${event.deductedQuantity}');
        _activityLogBloc.add(AddActivityLog(activityLog: activityLog));
      } catch (_) {}
    }
  }

  void _onEditProduct(EditProduct event, Emitter<ProductState> emit) async {
    if (state is ProductsLoaded) {
      try {
        emit(const Success(successMessage: "Edited Successfully"));
        await _productRepository.editProductDetails(event.product);
      } catch (_) {}
    }
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    final state = this.state;
    if (state is ProductsLoaded) {
      if (event.keyword.isEmpty) {
        add(LoadProducts());
      } else {
        emit(ProductsLoaded(
            products: state.products
                .where((product) => product.productName
                    .toLowerCase()
                    .contains(event.keyword.toLowerCase()))
                .toList()));
      }
    }
  }

  void _onUpdateProducts(UpdateProducts event, Emitter<ProductState> emit) {
    emit(ProductsLoaded(products: event.products.reversed.toList()));
  }

  void _onExportToExcel(ExportToExcel event, Emitter<ProductState> emit) async {
    final state = this.state;
    if (state is ProductsLoaded) {
      final excel = Excel.createExcel();
      final sheet = excel.sheets[excel.getDefaultSheet() as String];
      sheet!.setColWidth(2, 50);
      sheet.setColAutoFit(3);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 3))
          .value = 'Text string';

      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 4))
              .value =
          'Text string Text string Text string Text string Text string Text string Text string Text string';

      var fileBytes = excel.save();
      var directory = await getApplicationDocumentsDirectory();

      /* File(("$directory/output_file_name.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!); */
      print(directory);
    }
  }

  @override
  Future<void> close() async {
    _productSubscription?.cancel();
    super.close();
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  final ProductRepository _productRepository;
  final SupplierRepository _supplierRepository;
  StreamSubscription? _streamSubscription;
  CategoryBloc(
      {required CategoryRepository categoryRepository,
      required ProductRepository productRepository,
      required SupplierRepository supplierRepository})
      : _categoryRepository = categoryRepository,
        _productRepository = productRepository,
        _supplierRepository = supplierRepository,
        super(CategoryLoading()) {
    on<LoadCategory>(_onLoadCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<EditCategory>(_onEditCategory);
  }
  void _onLoadCategory(LoadCategory event, Emitter<CategoryState> emit) {
    _streamSubscription?.cancel();
    _streamSubscription =
        _categoryRepository.getAllCategory().listen((categories) {
      add(UpdateCategory(categories: categories));
    });
  }

  void _onUpdateCategory(UpdateCategory event, Emitter<CategoryState> emit) {
    emit(CategoryLoaded(event.categories));
  }

  void _onAddCategory(AddCategory event, Emitter<CategoryState> emit) async {
    final state = this.state;
    if (state is CategoryLoaded) {
      final res = await _categoryRepository.createCategory(event.category);
      res.fold((l) {
        showErrorSnackBar(event.context, l.message);
        Navigator.of(event.context).pop();
      }, (r) {
        showSuccessSnackBar(event.context, 'Category added successfully!');
        Navigator.of(event.context).pop();
      });
    }
  }

  void _onDeleteCategory(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    final state = this.state;
    if (state is CategoryLoaded) {
      final res = await _categoryRepository.deleteCategory(event.category);

      res.fold((l) {
        showErrorSnackBar(event.context, l.message);
      }, (r) {
        _productRepository.deleteProductByCategory(event.category.categoryName);
        _supplierRepository
            .deleteSupplierByCategory(event.category.categoryName);
        showSuccessSnackBar(event.context, 'Category deleted successfully!');
      });
    }
  }

  void _onEditCategory(EditCategory event, Emitter<CategoryState> emit) async {
    final state = this.state;
    if (state is CategoryLoaded) {
      final res = await _categoryRepository.editCategory(event.category);

      res.fold((l) {
        showErrorSnackBar(event.context, l.message);
        Navigator.of(event.context).pop();
      }, (r) {
        _productRepository.updateProductCategory(
            event.oldCategory, event.category.categoryName);
        showSuccessSnackBar(event.context, 'Category updated successfully!');
        Navigator.of(event.context).pop();
      });
    }
  }

  @override
  Future<void> close() async {
    _streamSubscription?.cancel();
    super.close();
  }
}

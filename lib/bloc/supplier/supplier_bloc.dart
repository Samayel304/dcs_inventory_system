import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/supplier_model.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final SupplierRepository _supplierRepository;
  StreamSubscription? _supplierSubscription;
  SupplierBloc({required SupplierRepository supplierRepository})
      : _supplierRepository = supplierRepository,
        super(SupplierLoading()) {
    on<LoadSuppliers>(_onLoadSuppliers);
    on<UpdateSuppliers>(_onUpdateSuppliers);
    on<AddSupplier>(_onAddSupplier);
    on<EditSupplier>(_onEditSupplier);
    on<DeleteSupplier>(_onDeleteSupplier);
  }

  void _onLoadSuppliers(LoadSuppliers event, Emitter<SupplierState> emit) {
    try {
      _supplierSubscription?.cancel();
      _supplierSubscription =
          _supplierRepository.getAllSuppliers().listen((suppliers) {
        add(UpdateSuppliers(suppliers: suppliers));
      });
    } catch (_) {}
  }

  void _onUpdateSuppliers(UpdateSuppliers event, Emitter<SupplierState> emit) {
    emit(SupplierLoaded(suppliers: event.suppliers.reversed.toList()));
  }

  void _onAddSupplier(AddSupplier event, Emitter<SupplierState> emit) async {
    final res = await _supplierRepository.addSupplier(event.supplier);
    res.fold((l) {
      showErrorSnackBar(event.context, l.message);
      Navigator.of(event.context).pop();
    }, (r) {
      showSuccessSnackBar(event.context, 'Supplier added successfully!');
      Navigator.of(event.context).pop();
    });
  }

  void _onEditSupplier(EditSupplier event, Emitter<SupplierState> emit) async {
    final res = await _supplierRepository.editSupplier(event.supplier);
    res.fold((l) {
      showErrorSnackBar(event.context, l.message);
      Navigator.of(event.context).pop();
    }, (r) {
      showSuccessSnackBar(event.context, 'Supplier edited successfully!');
      Navigator.of(event.context).pop();
    });
  }

  void _onDeleteSupplier(
      DeleteSupplier event, Emitter<SupplierState> emit) async {
    final res = await _supplierRepository.deleteSupplier(event.supplier);
    res.fold((l) {
      showErrorSnackBar(event.context, l.message);
      Navigator.of(event.context).pop();
    }, (r) {
      showSuccessSnackBar(event.context, 'Supplier deleted successfully!');
      Navigator.of(event.context).pop();
    });
  }

  @override
  Future<void> close() async {
    _supplierSubscription?.cancel();
    super.close();
  }
}

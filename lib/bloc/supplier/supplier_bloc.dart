import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:equatable/equatable.dart';

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
    emit(SupplierLoaded(suppliers: event.suppliers));
  }

  void _onAddSupplier(AddSupplier event, Emitter<SupplierState> emit) async {
    try {
      await _supplierRepository.addSupplier(event.supplier);
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    _supplierSubscription?.cancel();
    super.close();
  }
}

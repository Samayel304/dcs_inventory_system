import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:to_csv/to_csv.dart' as exportcsv;

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
    on<ExportSupplier>(_onExportToExcel);
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
    }, (r) {
      showSuccessSnackBar(event.context, 'Supplier deleted successfully!');
    });
  }

  void _onExportToExcel(
      ExportSupplier event, Emitter<SupplierState> emit) async {
    try {
      final state = this.state;
      if (state is SupplierLoaded) {
        List<String> header = [];

        header.add('Supplier Name');
        header.add('Supply Type');
        header.add('Contact Person');
        header.add('Contact Number');
        header.add('Address');

        List<List<String>> listOfLists = [];
        listOfLists.add(header);
        for (var item in state.suppliers) {
          List<String> data = [];
          data.add(item.supplierName.toTitleCase());
          data.add(item.category.toTitleCase());
          data.add(item.contactPerson.toTitleCase());
          data.add(item.contactNumber);
          data.add(item.address);
          listOfLists.add(data);
        }

        await exportcsv.myCSV(header, listOfLists);
        showSuccessSnackBar(event.context, 'Exported successfully');
      }
    } catch (e) {
      showErrorSnackBar(event.context, e.toString());
    }
  }

  @override
  Future<void> close() async {
    _supplierSubscription?.cancel();
    super.close();
  }
}

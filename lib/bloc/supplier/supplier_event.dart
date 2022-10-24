part of 'supplier_bloc.dart';

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object> get props => [];
}

class LoadSuppliers extends SupplierEvent {}

class UpdateSuppliers extends SupplierEvent {
  final List<Supplier> suppliers;
  const UpdateSuppliers({this.suppliers = const <Supplier>[]});
  @override
  List<Object> get props => [suppliers];
}

class AddSupplier extends SupplierEvent {
  final Supplier supplier;
  const AddSupplier(this.supplier);
  @override
  List<Object> get props => [supplier];
}

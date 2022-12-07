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
  final BuildContext context;
  const AddSupplier(this.supplier, this.context);

  @override
  List<Object> get props => [supplier, context];
}

class EditSupplier extends SupplierEvent {
  final Supplier supplier;
  final BuildContext context;
  const EditSupplier(this.supplier, this.context);
  @override
  List<Object> get props => [supplier, context];
}

class DeleteSupplier extends SupplierEvent {
  final Supplier supplier;
  final BuildContext context;
  const DeleteSupplier(this.supplier, this.context);
  @override
  List<Object> get props => [supplier, context];
}

class ExportSupplier extends SupplierEvent {
  final BuildContext context;

  const ExportSupplier(this.context);
  @override
  List<Object> get props => [context];
}

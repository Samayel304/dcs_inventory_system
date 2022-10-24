part of 'supplier_bloc.dart';

abstract class SupplierState extends Equatable {
  const SupplierState();

  @override
  List<Object> get props => [];
}

class SupplierLoading extends SupplierState {}

class SupplierLoaded extends SupplierState {
  final List<Supplier> suppliers;

  const SupplierLoaded({this.suppliers = const <Supplier>[]});

  @override
  List<Object> get props => [suppliers];
}

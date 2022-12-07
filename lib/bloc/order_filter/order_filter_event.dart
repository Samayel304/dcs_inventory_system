part of 'order_filter_bloc.dart';

abstract class OrderFilterEvent extends Equatable {
  const OrderFilterEvent();

  @override
  List<Object> get props => [];
}

class LoadSupplierFilter extends OrderFilterEvent {}

class UpdateSupplierFilter extends OrderFilterEvent {
  final List<SupplierFilter> supplierFilters;
  final OrderDateFilter orderDateFilter;

  const UpdateSupplierFilter(
      {required this.supplierFilters, required this.orderDateFilter});
  @override
  List<Object> get props => [supplierFilters, orderDateFilter];
}

class UpdateOrderDateFilter extends OrderFilterEvent {
  final OrderDateFilter orderDateFilter;
  final List<SupplierFilter> supplierFilters;

  const UpdateOrderDateFilter(
      {required this.orderDateFilter, required this.supplierFilters});
  @override
  List<Object> get props => [orderDateFilter, supplierFilters];
}

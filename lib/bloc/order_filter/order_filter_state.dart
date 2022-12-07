part of 'order_filter_bloc.dart';

abstract class OrderFilterState extends Equatable {
  const OrderFilterState();

  @override
  List<Object> get props => [];
}

class OrderFilterLoading extends OrderFilterState {}

class OrderFilterLoaded extends OrderFilterState {
  final List<SupplierFilter> selectedSuppliers;
  final OrderDateFilter orderDateFilter;
  final List<OrderModel> filteredOrders;

  const OrderFilterLoaded(
      {this.selectedSuppliers = const <SupplierFilter>[],
      required this.orderDateFilter,
      required this.filteredOrders});
  @override
  List<Object> get props =>
      [selectedSuppliers, orderDateFilter, filteredOrders];
}

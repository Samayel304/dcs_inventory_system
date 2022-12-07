import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:equatable/equatable.dart';

part 'order_filter_event.dart';
part 'order_filter_state.dart';

class OrderFilterBloc extends Bloc<OrderFilterEvent, OrderFilterState> {
  final SupplierRepository _supplierRepository;
  final OrderBloc _orderBloc;
  late StreamSubscription _supplierSubscription;
  OrderFilterBloc(
      {required SupplierRepository supplierRepository,
      required OrderBloc orderBloc})
      : _supplierRepository = supplierRepository,
        _orderBloc = orderBloc,
        super(OrderFilterLoading()) {
    on<LoadSupplierFilter>(_onLoadFilter);
    on<UpdateOrderDateFilter>(_onUpdateOrderDateFilter);
  }

  void _onLoadFilter(
      LoadSupplierFilter event, Emitter<OrderFilterState> emit) async {
    List<SupplierFilter> supplierFilters = [];
    _supplierSubscription =
        _supplierRepository.getAllSuppliers().listen((event) {
      for (var supply in event) {
        supplierFilters.add(SupplierFilter(supplierName: supply.supplierName));
      }
    });

    OrderDateFilter orderDateFilter = OrderDateFilter(
        startDate: DateTime.now(), endDate: DateTime(2021, 1, 1));
    List<OrderModel> filteredOrders = (_orderBloc.state as OrdersLoaded).orders;
    emit(OrderFilterLoaded(
        selectedSuppliers: supplierFilters,
        orderDateFilter: orderDateFilter,
        filteredOrders: filteredOrders));
  }

  void _onUpdateOrderDateFilter(
      UpdateOrderDateFilter event, Emitter<OrderFilterState> emit) {
    final state = this.state;
    if (state is OrderFilterLoaded) {}
  }

  List<OrderModel> _getOrders(
      List<SupplierFilter> supplierFilters, OrderDateFilter orderDateFilter) {
    List<OrderModel> filteredOrders = [];
    List<OrderModel> orders = (_orderBloc.state as OrdersLoaded).orders;
    for (var order in orders) {
      if (order.orderedDate.compareTo(orderDateFilter.startDate) >= 0 &&
          order.orderedDate.compareTo(orderDateFilter.endDate) <= 0) {
        filteredOrders.add(order);
      }
    }

    return filteredOrders
        .where((order) => supplierFilters.any((filter) =>
            order.supplier.supplierName.contains(filter.supplierName)))
        .toList();
  }

  @override
  Future<void> close() async {
    _supplierSubscription.cancel();

    super.close();
  }
}

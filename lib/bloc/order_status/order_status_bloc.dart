import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/utils/constant.dart';
import 'package:equatable/equatable.dart';

import '../../models/order_model.dart';

part 'order_status_event.dart';
part 'order_status_state.dart';

class OrderStatusBloc extends Bloc<OrderStatusEvent, OrderStatusState> {
  final OrderBloc _orderBloc;
  late StreamSubscription _orderSubscription;
  OrderStatusBloc({required OrderBloc orderBloc})
      : _orderBloc = orderBloc,
        super(OrderStatusLoading()) {
    on<UpdateOrdersStatus>(_onUpdateOrderStatus);

    _orderSubscription = _orderBloc.stream.listen((state) {
      if (state is OrdersLoaded) {
        add(UpdateOrdersStatus(orders: state.orders));
      }
    });
  }

  void _onUpdateOrderStatus(
      UpdateOrdersStatus event, Emitter<OrderStatusState> emit) {
    List<Order> all = event.orders.toList();
    List<Order> pending = event.orders
        .where((order) => order.status == OrderStatus.pending.name)
        .toList();
    List<Order> received = event.orders
        .where((order) => order.status == OrderStatus.received.name)
        .toList();
    List<Order> cancelled = event.orders
        .where((order) => order.status == OrderStatus.cancelled.name)
        .toList();
    emit(OrderStatusLoaded(
        all: all,
        pendingOrders: pending,
        receivedOrders: received,
        cancelledOrders: cancelled));
  }

  @override
  Future<void> close() {
    _orderSubscription.cancel();
    return super.close();
  }
}

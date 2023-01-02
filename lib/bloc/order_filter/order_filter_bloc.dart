import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'order_filter_event.dart';
part 'order_filter_state.dart';

class OrderFilterBloc extends Bloc<OrderFilterEvent, OrderFilterState> {
  final OrderBloc _orderBloc;
  late StreamSubscription _orderStreamSubscription;
  OrderFilterBloc({required OrderBloc orderBloc})
      : _orderBloc = orderBloc,
        super(orderBloc.state is OrdersLoaded
            ? OrderFilterLoaded(
                (orderBloc.state as OrdersLoaded).orders, null, null)
            : OrderFilterLoading()) {
    on<UpdateOrder>(_onUpdateOrder);
    on<SetDateRange>(_onSetDateRange);

    _orderStreamSubscription = _orderBloc.stream.listen((state) {
      if (state is OrdersLoaded) {
        add(UpdateOrder(state.orders, null, null));
      }
    });
  }

  void _onUpdateOrder(UpdateOrder event, Emitter<OrderFilterState> emit) {
    emit(OrderFilterLoaded(event.orders, event.start, event.end));
  }

  void _onSetDateRange(SetDateRange event, Emitter<OrderFilterState> emit) {
    try {
      DateTime? start = event.start;
      DateTime? end = event.end;
      List<OrderModel> orders = (_orderBloc.state as OrdersLoaded).orders;
      if (start == null || end == null) {
        add(UpdateOrder(orders, start, end));
        showSuccessSnackBar(event.context, 'Filter Cleared!');
        Navigator.of(event.context).pop();
      } else {
        List<OrderModel> filteredOrders = orders
            .where((order) =>
                DateTime.utc(order.orderedDate.year, order.orderedDate.month,
                            order.orderedDate.day)
                        .difference(
                            DateTime.utc(start.year, start.month, start.day)) >=
                    const Duration(days: 0) &&
                DateTime.utc(order.orderedDate.year, order.orderedDate.month,
                            order.orderedDate.day)
                        .difference(
                            DateTime.utc(end.year, end.month, end.day)) <=
                    const Duration(days: 0))
            .toList();
        add(UpdateOrder(filteredOrders, start, end));
        showSuccessSnackBar(event.context, 'Filter Added!');
        Navigator.of(event.context).pop();
      }
    } catch (e) {
      showErrorSnackBar(event.context, e.toString());
      Navigator.of(event.context).pop();
    }
  }

  @override
  Future<void> close() async {
    _orderStreamSubscription.cancel();

    super.close();
  }
}

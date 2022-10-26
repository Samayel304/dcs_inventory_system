import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/repositories/order/order_repository.dart';
import 'package:dcs_inventory_system/repositories/product/product_repository.dart';
import 'package:equatable/equatable.dart';

import '../../models/order_model.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;
  StreamSubscription? _orderSubscription;

  OrderBloc(
      {required OrderRepository orderRepository,
      required ProductRepository productRepository})
      : _orderRepository = orderRepository,
        _productRepository = productRepository,
        super(OrdersLoading()) {
    on<LoadOrders>(_onLoadOrders);
    on<UpdateOrders>(_onUpdateOrders);
    on<AddOrder>(_onAddOrder);
    on<ReceiveOrder>(_onReceiveOrder);
    on<CancelOrder>(_onCancelOrder);
  }
  void _onLoadOrders(
    LoadOrders event,
    Emitter<OrderState> emit,
  ) {
    _orderSubscription?.cancel();
    _orderSubscription = _orderRepository.getAllOrders().listen(
          (orders) => add(
            UpdateOrders(orders: orders),
          ),
        );
  }

  void _onUpdateOrders(UpdateOrders event, Emitter<OrderState> emit) {
    emit(OrdersLoaded(orders: event.orders.reversed.toList()));
  }

  void _onAddOrder(AddOrder event, Emitter<OrderState> emit) async {
    try {
      await _orderRepository.addOrder(event.order);
    } catch (_) {}
  }

  void _onReceiveOrder(ReceiveOrder event, Emitter<OrderState> emit) async {
    try {
      await _orderRepository.editOrderDetails(event.order);
      await _productRepository.editProductDetails(event.product);
    } catch (_) {}
  }

  void _onCancelOrder(CancelOrder event, Emitter<OrderState> emit) async {
    try {
      await _orderRepository.editOrderDetails(event.order);
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    _orderSubscription?.cancel();
    super.close();
  }
}

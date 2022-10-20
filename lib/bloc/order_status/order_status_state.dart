part of 'order_status_bloc.dart';

abstract class OrderStatusState extends Equatable {
  const OrderStatusState();

  @override
  List<Object> get props => [];
}

class OrderStatusLoading extends OrderStatusState {}

class OrderStatusLoaded extends OrderStatusState {
  final List<Order> pendingOrders;
  final List<Order> receivedOrders;
  final List<Order> cancelledOrders;
  final List<Order> all;

  const OrderStatusLoaded(
      {this.receivedOrders = const <Order>[],
      this.cancelledOrders = const <Order>[],
      this.pendingOrders = const <Order>[],
      this.all = const <Order>[]});

  @override
  List<Object> get props =>
      [pendingOrders, receivedOrders, cancelledOrders, all];
}

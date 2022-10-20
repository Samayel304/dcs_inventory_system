part of 'order_status_bloc.dart';

abstract class OrderStatusEvent extends Equatable {
  const OrderStatusEvent();

  @override
  List<Object> get props => [];
}

class UpdateOrdersStatus extends OrderStatusEvent {
  final List<Order> orders;
  const UpdateOrdersStatus({this.orders = const <Order>[]});
  @override
  List<Object> get props => [orders];
}

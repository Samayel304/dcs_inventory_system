part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderEvent {}

class UpdateOrders extends OrderEvent {
  final List<Order> orders;

  const UpdateOrders({
    this.orders = const <Order>[],
  });

  @override
  List<Object> get props => [orders];
}

class AddOrder extends OrderEvent {
  final Order order;

  const AddOrder(
    this.order,
  );

  @override
  List<Object> get props => [order];
}

class ReceiveOrder extends OrderEvent {
  final Order order;
  final Product product;

  const ReceiveOrder(
    this.product,
    this.order,
  );

  @override
  List<Object> get props => [order, product];
}

class CancelOrder extends OrderEvent {
  final Order order;

  const CancelOrder(
    this.order,
  );

  @override
  List<Object> get props => [order];
}

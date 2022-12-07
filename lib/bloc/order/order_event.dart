part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderEvent {}

class UpdateOrders extends OrderEvent {
  final List<OrderModel> orders;

  const UpdateOrders({
    this.orders = const <OrderModel>[],
  });

  @override
  List<Object> get props => [orders];
}

class AddOrder extends OrderEvent {
  final OrderModel order;
  final BuildContext context;
  const AddOrder(this.order, this.context);

  @override
  List<Object> get props => [order, context];
}

class ReceiveOrder extends OrderEvent {
  final OrderModel order;
  final Product product;
  final BuildContext context;

  const ReceiveOrder(this.product, this.order, this.context);

  @override
  List<Object> get props => [order, product, context];
}

class CancelOrder extends OrderEvent {
  final OrderModel order;
  final BuildContext context;

  const CancelOrder(this.order, this.context);

  @override
  List<Object> get props => [order, context];
}

class ExportOrders extends OrderEvent {
  final BuildContext context;

  const ExportOrders(this.context);

  @override
  List<Object> get props => [context];
}

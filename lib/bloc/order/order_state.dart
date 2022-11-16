part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrdersLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  const OrdersLoaded({this.orders = const <OrderModel>[]});

  @override
  List<Object> get props => [orders];
}

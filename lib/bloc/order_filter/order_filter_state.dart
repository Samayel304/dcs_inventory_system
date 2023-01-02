part of 'order_filter_bloc.dart';

abstract class OrderFilterState extends Equatable {
  const OrderFilterState();

  @override
  List<Object?> get props => [];
}

class OrderFilterLoading extends OrderFilterState {}

class OrderFilterLoaded extends OrderFilterState {
  final List<OrderModel> orders;
  final DateTime? start;
  final DateTime? end;

  const OrderFilterLoaded(this.orders, this.start, this.end);
  @override
  List<Object?> get props => [orders, start, end];
}

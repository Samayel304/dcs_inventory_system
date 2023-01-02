part of 'order_filter_bloc.dart';

abstract class OrderFilterEvent extends Equatable {
  const OrderFilterEvent();

  @override
  List<Object?> get props => [];
}

class UpdateOrder extends OrderFilterEvent {
  final List<OrderModel> orders;
  final DateTime? start;
  final DateTime? end;
  const UpdateOrder(this.orders, this.start, this.end);
  @override
  List<Object?> get props => [orders, start, end];
}

class SetDateRange extends OrderFilterEvent {
  final DateTime? start;
  final DateTime? end;
  final BuildContext context;

  const SetDateRange(this.start, this.end, this.context);
  @override
  List<Object?> get props => [start, end, context];
}

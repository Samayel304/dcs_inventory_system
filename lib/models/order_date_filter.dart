import 'package:equatable/equatable.dart';

class OrderDateFilter extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const OrderDateFilter({required this.startDate, required this.endDate});

  OrderDateFilter copyWith({DateTime? startDate, DateTime? endDate}) {
    return OrderDateFilter(
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [startDate, endDate];
}

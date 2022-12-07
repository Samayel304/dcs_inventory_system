import 'package:equatable/equatable.dart';

class SupplierFilter extends Equatable {
  final String supplierName;
  final bool isSelected;

  const SupplierFilter({required this.supplierName, this.isSelected = false});

  SupplierFilter copyWith({String? supplierName, bool? isSelected}) {
    return SupplierFilter(
        supplierName: supplierName ?? this.supplierName,
        isSelected: isSelected ?? this.isSelected);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [supplierName, isSelected];
}

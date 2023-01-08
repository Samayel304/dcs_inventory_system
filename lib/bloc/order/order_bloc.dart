import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/repositories/order/order_repository.dart';
import 'package:dcs_inventory_system/repositories/product/product_repository.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:to_csv/to_csv.dart' as exportcsv;

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
    on<ExportOrders>(_onExportToExcel);
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
    final res = await _orderRepository.addOrder(event.order);
    res.fold((l) {
      showErrorSnackBar(event.context, l.message);
      Navigator.of(event.context).pop();
    }, (r) {
      showSuccessSnackBar(event.context, 'Ordered successfully!');
      Navigator.of(event.context).pop();
    });
  }

  void _onReceiveOrder(ReceiveOrder event, Emitter<OrderState> emit) async {
    double totalCost = event.order.product.unitPrice * event.order.quantity;
    print(event.order.product.unitPrice);
    print(event.order.quantity);
    OrderModel order = event.order.copyWith(totalCost: totalCost);
    final res = await _orderRepository.editOrderDetails(order);
    res.fold((l) {
      showErrorSnackBar(event.context, l.message);
    }, (r) async {
      final res = await _productRepository.addProductQuantity(event.product);
      res.fold((l) {
        showErrorSnackBar(event.context, l.message);
      }, (r) {
        showSuccessSnackBar(event.context, 'Order recieved!');
      });
    });
  }

  void _onCancelOrder(CancelOrder event, Emitter<OrderState> emit) async {
    final res = await _orderRepository.editOrderDetails(event.order);
    res.fold((l) {
      showErrorSnackBar(event.context, l.message);
    }, (r) {
      showSuccessSnackBar(event.context, 'Order cancelled!');
    });
  }

  void _onExportToExcel(ExportOrders event, Emitter<OrderState> emit) async {
    try {
      final state = this.state;
      if (state is OrdersLoaded) {
        List<String> header = [];

        header.add('Order Id');
        header.add('Item Name');
        header.add('Quantity');
        header.add('Supplier Name');
        header.add('Date Ordered');
        header.add('Date Received/Cancelled');
        header.add('Status');

        List<List<String>> listOfLists = [];
        listOfLists.add(header);
        for (var item in state.orders) {
          List<String> data = [];
          data.add(item.orderId.toString());
          data.add(item.product.productName.toTitleCase());
          data.add(item.quantity.toString());
          data.add(item.supplier.supplierName);
          data.add(item.orderedDate.formatDate());
          switch (item.status) {
            case 'received':
              data.add(item.dateReceived.formatDate());
              break;
            case 'cancelled':
              data.add(item.dateCancelled.formatDate());
              break;
            case 'pending':
              data.add('');
          }
          data.add(item.status);
          listOfLists.add(data);
        }

        await exportcsv.myCSV(header, listOfLists);
        showSuccessSnackBar(event.context, 'Exported Successfully');
      }
    } catch (e) {
      showErrorSnackBar(event.context, e.toString());
    }
  }

  @override
  Future<void> close() async {
    _orderSubscription?.cancel();
    super.close();
  }
}

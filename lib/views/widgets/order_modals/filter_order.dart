import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterOrder extends StatefulWidget {
  const FilterOrder({
    Key? key,
    this.startDate,
    this.endDate,
  }) : super(key: key);
  final DateTime? startDate;
  final DateTime? endDate;
  @override
  State<FilterOrder> createState() => _FilterOrderState();
}

class _FilterOrderState extends State<FilterOrder> {
  TextEditingController startDateTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();
  //final _formKey = GlobalKey<FormState>();
  Product? selectedProduct;
  Supplier? selectedSupplier;
  DateTime? start;
  DateTime? end;
  bool _canSave = false;

  @override
  void initState() {
    start = widget.startDate;
    end = widget.endDate;

    startDateTextController.text = start != null ? start!.formatDate() : '';
    endDateTextController.text = end != null ? end!.formatDate() : '';
    super.initState();
  }

  @override
  void dispose() {
    startDateTextController.dispose();
    endDateTextController.dispose();
    super.dispose();
  }

  void saveFilter(BuildContext context) {
    BlocProvider.of<OrderFilterBloc>(context)
        .add(SetDateRange(start, end, context));
  }

  void setCanSave() {
    if (startDateTextController.text.isNotEmpty &&
        endDateTextController.text.isNotEmpty) {
      setState(() {
        _canSave = true;
      });
    } else {
      setState(() {
        _canSave = false;
      });
    }
  }

  void picStartDate() async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: end != null
            ? DateTime(end!.year, end!.month, end!.day - 1)
            : currentDate, //get today's date
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: end != null
            ? DateTime(end!.year, end!.month, end!.day - 1)
            : currentDate);
    if (pickedDate != null) {
      String startDate = pickedDate.formatDate();
      setState(() {
        startDateTextController.text = startDate;
        start = pickedDate;
        setCanSave();
      });
    }
  }

  void pickEndDate() async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate, //get today's date
        firstDate: DateTime(
            start!.year,
            start!.month,
            start!.day +
                1), //DateTime.now() - not to allow to choose before today.
        lastDate: currentDate);
    if (pickedDate != null) {
      String endDate = pickedDate.formatDate();
      setState(() {
        endDateTextController.text = endDate;
        end = pickedDate;
        setCanSave();
      });
    }
  }

  void clearFilter(BuildContext context) {
    BlocProvider.of<OrderFilterBloc>(context)
        .add(SetDateRange(null, null, context));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          // key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Filter",
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Text("Clear Filter",
                          style: Theme.of(context).textTheme.headline4),
                      onTap: () {
                        clearFilter(context);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Enter Start Date',
                readOnly: true,
                onTap: picStartDate,
                controller: startDateTextController,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                hintText: 'Enter End Date',
                readOnly: true,
                onTap: pickEndDate,
                controller: endDateTextController,
                enabled: startDateTextController.text.isNotEmpty,
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(
                  isDisable: !_canSave,
                  text: "Save Filter",
                  fontColor: Colors.white,
                  backgroundColor: Colors.black,
                  onPressed: () {
                    saveFilter(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

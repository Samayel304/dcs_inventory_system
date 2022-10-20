import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {Key? key,
      required this.onChange,
      required this.listItem,
      required this.hint,
      this.validator,
      this.value})
      : super(key: key);

  final void Function(dynamic) onChange;
  final List<DropdownMenuItem> listItem;
  final Widget hint;
  final String? Function(dynamic)? validator;
  final dynamic value;
  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
        validator: widget.validator,
        dropdownMaxHeight: 150,
        isExpanded: true,
        hint: widget.hint,
        value: widget.value,
        buttonPadding: const EdgeInsets.only(left: 10),
        //icon: const Icon(Icons.arrow_downward),
        //elevation: 10,
        buttonHeight: 60,
        decoration: InputDecoration(
          //Add isDense true and zero Padding.
          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          //Add more decoration as you want here
          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
        ),
        onChanged: widget.onChange,
        items: widget.listItem);
  }
}

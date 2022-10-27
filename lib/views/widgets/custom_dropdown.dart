import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    this.itemAsString,
    required this.items,
    this.onChanged,
    this.selectedItem,
    required this.hint,
    this.validator,
  }) : super(key: key);

  final String Function(dynamic)? itemAsString;
  final List<dynamic> items;
  final void Function(dynamic)? onChanged;
  final dynamic selectedItem;
  final String hint;
  final String? Function(dynamic)? validator;
  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch(
      validator: widget.validator,
      popupProps: PopupProps.menu(
          showSearchBox: true,
          menuProps: const MenuProps(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                  hintText: "Search",
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                          color: Color(0xFFD9D9D9), width: 2.0))))),
      itemAsString: widget.itemAsString,
      items: widget.items,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      onChanged: widget.onChanged,
      selectedItem: widget.selectedItem,
    );
  }
}

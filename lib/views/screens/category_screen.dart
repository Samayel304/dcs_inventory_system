import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/views/widgets/category_modals/edit_category_modal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/model.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late ScrollController _scrollController;
  bool _onTop = true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // if (_scrollController.position.atEdge) {
      setState(() {
        _onTop = _scrollController.position.pixels == 0;
      });
      //}
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const BackAppBar(),
        floatingActionButton: Visibility(
          visible: _onTop,
          child: FloatingActionButton(
            onPressed: () {
              showBottomModal(context, const AddCategoryModal());
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: Header.categoryHeaders
                        .map(
                          (header) => Expanded(
                              flex: header.flex,
                              child: Text(
                                header.title,
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const Loader();
                      }
                      if (state is CategoryLoaded) {
                        return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: state.categories.length,
                            itemBuilder: ((context, index) {
                              Category category = state.categories[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xEEEBE6E6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      _detailText(
                                        context,
                                        (index + 1).toString(),
                                      ),
                                      _detailText(
                                        context,
                                        category.categoryName.toTitleCase(),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: PopupMenuButton(
                                            onSelected: (value) {
                                              switch (value) {
                                                case 0:
                                                  showBottomModal(
                                                      context,
                                                      EditCategoryModel(
                                                        selectedCategory:
                                                            category,
                                                      ));
                                                  break;
                                                case 1:
                                                  showAlertDialog(
                                                      context: context,
                                                      title: 'Delete Category',
                                                      content:
                                                          'All of the supplies and supplier under this category will also be deleted. Are you sure do you to delete this category?',
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        BlocProvider.of<
                                                                    CategoryBloc>(
                                                                context)
                                                            .add(DeleteCategory(
                                                                category,
                                                                context));
                                                      });
                                                  break;
                                              }
                                            },
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder: (context) {
                                              return [
                                                const PopupMenuItem(
                                                    value: 0,
                                                    child: Text("Edit")),
                                                const PopupMenuItem(
                                                    value: 1,
                                                    child: Text("Delete"))
                                              ];
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }));
                      } else {
                        return const Text("Something went wrong.");
                      }
                    },
                  ),
                ),
              ],
            )));
  }
}

Widget _detailText(BuildContext context, String text,
    {int flex = 1, TextAlign textAlign = TextAlign.start}) {
  return Expanded(
      flex: flex,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline5,
        textAlign: textAlign,
      ));
}

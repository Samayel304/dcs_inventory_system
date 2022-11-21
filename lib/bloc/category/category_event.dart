part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategory extends CategoryEvent {}

class UpdateCategory extends CategoryEvent {
  final List<Category> categories;

  const UpdateCategory({this.categories = const <Category>[]});
  @override
  List<Object> get props => [categories];
}

class AddCategory extends CategoryEvent {
  final Category category;
  final BuildContext context;

  const AddCategory(this.category, this.context);
  @override
  List<Object> get props => [category, context];
}

class DeleteCategory extends CategoryEvent {
  final Category category;
  final BuildContext context;

  const DeleteCategory(this.category, this.context);
  @override
  List<Object> get props => [category, context];
}

class EditCategory extends CategoryEvent {
  final Category category;
  final String oldCategory;
  final BuildContext context;

  const EditCategory(this.category, this.context, this.oldCategory);
  @override
  List<Object> get props => [category, context, oldCategory];
}

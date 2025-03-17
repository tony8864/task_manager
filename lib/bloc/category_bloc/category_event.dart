part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

final class AddCategoryEvent extends CategoryEvent {
  final Map<String, dynamic> categoryMap;

  const AddCategoryEvent({required this.categoryMap});

  @override
  List<Object> get props => [categoryMap];
}

final class DeleteCategoryEvent extends CategoryEvent {
  final String cid;

  const DeleteCategoryEvent({required this.cid});

  @override
  List<Object> get props => [cid];
}

final class UpdateCategoryEvent extends CategoryEvent {
  final CategoryModel categoryModel;

  const UpdateCategoryEvent({required this.categoryModel});

  @override
  List<Object> get props => [categoryModel];
}

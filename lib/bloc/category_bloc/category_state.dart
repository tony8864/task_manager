part of 'category_bloc.dart';

sealed class CategoryState {
  const CategoryState();
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {}

final class CategoryFailure extends CategoryState {}

final class CategoriesFetched extends CategoryState {
  final List<CategoryModel> categories;

  const CategoriesFetched({required this.categories});
}

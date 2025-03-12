import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/data/repository/category_repository.dart/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc({required categoryRepository})
    : _categoryRepository = categoryRepository,
      super(CategoryInitial()) {
    on<CategorySubscriptionEvent>(_onCategorySubscription);
    on<AddCategoryEvent>(_onAddCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
  }

  Future<void> _onCategorySubscription(
    CategorySubscriptionEvent event,
    Emitter<CategoryState> emit,
  ) async {
    await emit.forEach(
      _categoryRepository.getCategories(),
      onData: (categories) {
        return CategoriesFetched(categories: categories);
      },
    );
  }

  Future<void> _onAddCategory(AddCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());
      await _categoryRepository.addCategory(event.categoryMap);
      emit(CategorySuccess());
    } on Exception {
      emit(CategoryFailure());
    }
  }

  Future<void> _onDeleteCategory(DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());
      await _categoryRepository.deleteCategory(event.cid);
      emit(CategorySuccess());
    } on Exception {
      emit(CategoryFailure());
    }
  }

  Future<void> _onUpdateCategory(UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());
      await _categoryRepository.updateCategory(event.categoryModel);
      emit(CategorySuccess());
    } on Exception {
      emit(CategoryFailure());
    }
  }
}

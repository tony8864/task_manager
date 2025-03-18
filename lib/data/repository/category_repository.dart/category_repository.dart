import 'package:task_manager/data/model/category_model.dart';

abstract class CategoryRepository {
  Future<Map<String, dynamic>> findById(String id);
  Future<String> addCategory(Map<String, dynamic> map);
  Future<void> deleteCategory(String cid);
  Future<void> updateCategory(CategoryModel collection);
}
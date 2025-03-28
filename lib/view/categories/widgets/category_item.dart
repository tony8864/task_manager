import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/core/colors/app_colors.dart';
import 'package:task_manager/data/model/category_model.dart';
import 'package:task_manager/view/categories/widgets/category_pop_menu.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryItem({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/categories/${categoryModel.id}/todos');
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.only(bottom: 40),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
          color: AppColors.darkBlueGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_categoryName(Colors.white), CategoryPopMenu(categoryModel: categoryModel)],
        ),
      ),
    );
  }

  Widget _categoryName(Color color) {
    return Text(categoryModel.name, style: GoogleFonts.merriweather(fontSize: 20, color: color));
  }
}

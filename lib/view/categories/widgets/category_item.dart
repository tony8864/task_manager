import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/data/model/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel categoryModel;
  final Function(String cid) onDelete;

  const CategoryItem({super.key, required this.categoryModel, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final categoryJsonString = jsonEncode(categoryModel.toMap());
        context.go('/categories/todo/$categoryJsonString');
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_categoryName(), _popupMenuButton(context)],
        ),
      ),
    );
  }

  Widget _categoryName() {
    return Text(categoryModel.name, style: GoogleFonts.merriweather(fontSize: 20));
  }

  Widget _popupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          onDelete(categoryModel.id);
        }
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Delete"),
                ],
              ),
            ),
          ],
      icon: const Icon(Icons.dehaze, size: 24),
    );
  }
}

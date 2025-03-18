import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/category_bloc/category_bloc.dart';
import 'package:task_manager/shared/widgets/nav_widget.dart';
import 'package:task_manager/view/categories/widgets/categories_list_widget.dart';
import 'package:task_manager/view/categories/widgets/categories_title_widget.dart';
import 'package:task_manager/view/categories/widgets/category_form_widget.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  void _onCreateCategory(BuildContext context) async {
    final categoryName = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CategoryFormWidget(),
    );

    if (!context.mounted) {
      return;
    }

    if (categoryName != null) {
      context.read<CategoryBloc>().add(AddCategoryEvent(categoryMap: {'name': categoryName}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: EdgeInsets.only(top: 70),
        width: double.infinity,
        child: Column(
          children: [
            CategoriesTitleWidget(),
            const SizedBox(height: 20),
            _horizontalLine(Theme.of(context).colorScheme.secondary),
            const CategoriesListWidget(),
            _navbar(context),
          ],
        ),
      ),
    );
  }

  Widget _horizontalLine(Color color) {
    return Divider(color: color, thickness: 1, indent: 20, endIndent: 20);
  }

  Widget _navbar(BuildContext context) {
    return NavWidget(
      isHomeActive: true,
      onPressed: () {
        _onCreateCategory(context);
      },
    );
  }
}

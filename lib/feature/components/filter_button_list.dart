import '../../utils/constant.dart';
import 'package:flutter/material.dart';

import '../../utils/helper.dart';



class FilterButtonList extends StatefulWidget {
  final List<ArticleCategory> categories;
  final Function(ArticleCategory?) onCategorySelected;
  final ArticleCategory? selectedCategory; // Add this variable

  const FilterButtonList({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    required this.selectedCategory, // Pass selectedCategory from the parent
  });

  @override
  _FilterButtonListState createState() => _FilterButtonListState();
}

class _FilterButtonListState extends State<FilterButtonList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          ArticleCategory category = widget.categories[index];
          bool isSelected = category == widget.selectedCategory;

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // Toggle selection
                      widget.onCategorySelected(isSelected ? null : category);
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? ArticleCategoryHelper.colorManage(category)
                          : ArticleCategoryHelper.colorManage(category)?.withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: ArticleCategoryHelper.iconManager(category),
                      ),
                    ),
                  ),
                ),
                Text(
                  category.toString().split('.').last,
                  style: isSelected
                      ? AppTextStyle().textExtraSmallDarkTextStyle(context)
                      : AppTextStyle().textExtraSmallTextStyle(context),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

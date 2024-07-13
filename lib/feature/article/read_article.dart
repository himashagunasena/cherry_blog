import '../../utils/constant.dart';
import '../../utils/extensions.dart';
import '../../utils/helper.dart';
import 'package:flutter/material.dart';

import '../../data/details_model.dart';


class ReadArticleScreen extends StatelessWidget {
  final Article article;

  const ReadArticleScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    article.category == null || article.category == ""
        ? article.category = "Other"
        : article.category;
    final ArticleCategory category =
        article.category != null && article.category is String
            ? ArticleCategoryExtension.fromString(article.category ?? "Other")
            : ArticleCategory.Other;
    return Scaffold(
      backgroundColor: colorTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 22,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 4),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: ArticleCategoryHelper.colorManage(category)),
                    child: Text(
                      article.category!,
                      style: AppTextStyle().textExtraSmallWhiteTextStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    article.title!.capitalizeFirst(),
                    style: AppTextStyle().textHeading1BoldStyle(
                        context, ArticleCategoryHelper.colorManage(category)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        article.author ?? "Anonymous",
                        style: AppTextStyle().textSmallTextStyle(context),
                      ),
                      Text(
                        "   |   ${getDateFormat(article.date)}",
                        style: AppTextStyle().textSmallTextStyle(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                                image: NetworkImage(
                                  article.image ?? Constant.initialURL,
                                ),
                                fit: BoxFit.cover))),
                    const SizedBox(height: 16.0),
                    article.quotes == "" || article.quotes == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "\" ${article.quotes!} \"",
                              style: AppTextStyle().textQuotesStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                    const SizedBox(height: 8),
                    Text(
                      article.description!,
                      style: AppTextStyle().textBodyStyle,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

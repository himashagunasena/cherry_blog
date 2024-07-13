import '../../utils/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/details_model.dart';
import '../../service/firestore_service.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../article/edit_article.dart';
import '../article/read_article.dart';

class AllArticles extends StatelessWidget {
  final FireStoreService fireStoreService = FireStoreService();
  final String searchQuery;
  final String uid;
  final String? selectedFilter;
  final ArticleCategory? selectedCategory;
  final bool isLoading;

  AllArticles({
    super.key,
    required this.searchQuery,
    required this.uid,
    this.selectedFilter,
    required this.isLoading,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: selectedCategory != null || selectedFilter == "MA"
                ? fireStoreService.getCategoryArticlesStream(
                    selectedCategory, selectedFilter, uid)
                : fireStoreService.getAllArticlesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    selectedFilter == 'MA'
                        ? 'You have not written any articles yet.'
                        : 'No articles found.',
                    style: AppTextStyle().textNotFoundStyle(context),
                  ),
                );
              }

              var allArticles = snapshot.data!.docs;
              Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>
                  remainingArticles;

              if (selectedFilter == "MA" || selectedCategory != null) {
                remainingArticles = allArticles;
              } else {
                remainingArticles = allArticles.skip(6);
              }

              if (searchQuery.isNotEmpty) {
                remainingArticles = allArticles
                    .where((article) =>
                        article['title']
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()) ||
                        article['description']
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                    .toList();
              }

              return remainingArticles.isEmpty || !snapshot.hasData
                  ? selectedFilter == "MA" ||
                          (allArticles.isNotEmpty && allArticles.length > 6) ||
                          (searchQuery.isNotEmpty && allArticles.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              "Not Found Result",
                              style: AppTextStyle().textNotFoundStyle(context),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Articles",
                          style: AppTextStyle().textHeading1Style,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: remainingArticles.length,
                          itemBuilder: (context, index) {
                            var article = Article.fromMap(
                                remainingArticles.elementAt(index).data());
                            var documentId =
                                remainingArticles.elementAt(index).id;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReadArticleScreen(article: article),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: articleCard(
                                  article.image,
                                  article.title,
                                  article.description,
                                  article.author,
                                  article.date,
                                  article.category,
                                  selectedFilter == "MA",
                                  article,
                                  documentId,
                                  context,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
            },
          );
  }

  Widget articleCard(
    String? image,
    String? title,
    String? des,
    String? author,
    Timestamp? dateTime,
    String? category,
    bool myArticle,
    Article article,
    String? id,
    BuildContext context,
  ) {
    final colorTheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorTheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(image ?? Constant.initialURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category ?? "Other",
                        style: AppTextStyle().textMiniTextStyle(context),
                      ),
                      Text(
                        title!.capitalizeFirst(),
                        style: AppTextStyle().textSubHeadingBoldStyle(context),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        des ?? "",
                        maxLines: 3,
                        style: AppTextStyle().textSmallTextStyle(context),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Wrap(
                        children: [
                          Text(
                            "By ${author ?? "Anonymous"}",
                            maxLines: 3,
                            style:
                                AppTextStyle().textExtraSmallTextStyle(context),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "  |  ",
                            maxLines: 3,
                            style:
                                AppTextStyle().textExtraSmallTextStyle(context),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            getDateFormat(dateTime).toString(),
                            maxLines: 3,
                            style:
                                AppTextStyle().textExtraSmallTextStyle(context),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        myArticle
            ? Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditArticleScreen(
                          article: article,
                          id: id,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_note),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

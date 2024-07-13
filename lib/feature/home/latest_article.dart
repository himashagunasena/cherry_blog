import '../../utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/details_model.dart';
import '../../service/firestore_service.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../article/read_article.dart';

class LatestArticles extends StatelessWidget {
  final FireStoreService fireStoreService = FireStoreService();
  final String searchQuery;
  final ArticleCategory? selectedCategory;
  final bool isLoading;

  LatestArticles(
      {super.key,
      required this.searchQuery,
      required this.isLoading,
      this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.white24,
            highlightColor: Colors.white,
            child: Container(
              width: 500,
            ))
        : StreamBuilder(
            stream: fireStoreService.getLatestArticlesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SizedBox.shrink();
              }

              var articles = snapshot.data?.docs;
              dynamic valueOfArticle;
              if (articles != null) {
                for (var a in articles) {
                  valueOfArticle = a["uid"];
                }
              }

              return searchQuery.isNotEmpty || selectedCategory != null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Latest Post",
                            style: AppTextStyle().textHeading1Style,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            height: MediaQuery.of(context).size.height / 2.8,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: articles?.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                var article = Article.fromMap(
                                    articles?[index].data() ?? {});
                                article.category ??= "Other";
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReadArticleScreen(
                                                  article: article),
                                        ));
                                  },
                                  child:
                                      article.title == "" || article.uid == ""
                                          ? const SizedBox.shrink()
                                          : latestArticleCard(
                                              article.image,
                                              article.title
                                                  .toString()
                                                  .capitalizeFirst(),
                                              article.author
                                                  .toString()
                                                  .capitalizeByWord(),
                                              article.category,
                                              context,
                                            ),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.34,
                                mainAxisSpacing: 10,
                                crossAxisCount: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          );
  }
}

Widget latestArticleCard(String? image, String? title, String? author,
    String? category, BuildContext context) {
  return Container(
    width: 500,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: CachedNetworkImageProvider(image ?? Constant.initialURL),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        category == "" || category == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white.withOpacity(0.3)),
                  child: Text(
                    category,
                    style: AppTextStyle().textExtraSmallWhiteTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
        const Spacer(),
        Text(
          title ?? "",
          style: AppTextStyle().textHeading2WhiteStyle,
        ),
        Text(author ?? "", style: AppTextStyle().textExtraSmallWhiteTextStyle),
        const SizedBox(height: 16),
      ],
    ),
  );
}

import '../../feature/home/profile.dart';
import '../../service/firestore_service.dart';
import '../../utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../article/add_article.dart';
import '../components/common_list_button.dart';
import '../components/filter_button_list.dart';
import 'articles.dart';
import 'display_profile.dart';
import 'latest_article.dart';

class HomeScreen extends StatefulWidget {
  final String? username;
  final String uid;

  const HomeScreen({Key? key, this.username, required this.uid})
      : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedFilter;
  ArticleCategory? _selectedCategory;
  FocusNode focusNode = FocusNode();
  bool isLoading = true;
  bool isAllArticleClick = true;
  bool isMyArticleClick = false;
  final FireStoreService fireStoreService = FireStoreService();
  @override
  void initState() {
    if (mounted) {
      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          isLoading = false;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          if (_selectedCategory != null) {
            _selectedCategory = null;
          }
        });
      },
      child: Scaffold(
        backgroundColor: colorTheme.background,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Welcome, ',
                                    style: AppTextStyle()
                                        .textBodyLightStyle(context),
                                  ),
                                  Text(
                                    widget.username
                                            ?.split(" ")[0]
                                            .toString()
                                            .capitalizeFirst() ??
                                        "Anonymous",
                                    style: AppTextStyle()
                                        .textBodyLightBoldStyle(context),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 4),
                                width: 200,
                                child: Text(
                                  "Explore Today's",
                                  style: AppTextStyle().textHeading1BoldStyle(
                                      context,
                                      !isDarkMode(context)
                                          ? colorTheme.tertiary
                                          : Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  username: widget.username ?? "Anonymous",
                                  uid: widget.uid,
                                ),
                              ),
                            );
                          },
                          child: UserProfileImage(
                              uid: widget.uid,
                              username: widget.username ?? "Anonymous"),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                        focusNode: focusNode,
                        cursorColor: isDarkMode(context)
                            ? Colors.white.withOpacity(0.6)
                            : Colors.black45,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isDarkMode(context)
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.grey,
                                width: 0.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isDarkMode(context)
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.black,
                                width: 0.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Search Articles or category',
                          suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: _searchController.text.isNotEmpty
                                ? Icon(
                                    Icons.clear,
                                    color: isDarkMode(context)
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.black45,
                                    size: 22,
                                  )
                                : Icon(
                                    Icons.search,
                                    color: isDarkMode(context)
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.black45,
                                    size: 22,
                                  ),
                            onPressed: () {
                              focusNode.unfocus();
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          CommonListButton(
                            click: () {
                              _searchController.clear();
                              setState(() {
                                isAllArticleClick = true;
                                isMyArticleClick = false;
                                _searchQuery = '';
                                _selectedCategory = null;
                                _selectedFilter = 'All Articles';
                              });
                            },
                            name: 'All Articles',
                            isClick: isAllArticleClick,
                          ),
                          const SizedBox(width: 8),
                          CommonListButton(
                            click: () {
                              _searchController.clear();
                              setState(() {
                                isMyArticleClick = true;
                                isAllArticleClick = false;

                                _searchQuery = '';
                                _selectedFilter = 'MA';
                              });
                            },
                            name: 'My Articles',
                            isClick: isMyArticleClick,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          :  ListView(
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: FilterButtonList(
                                    categories: ArticleCategory.values,
                                    onCategorySelected: (ArticleCategory? selectedCategory) {
                                      setState(() {
                                        _selectedCategory = selectedCategory;
                                      });
                                    },
                                    selectedCategory: _selectedCategory,
                                  ),
                                ),
                                _selectedFilter == "MA"
                                    ? const SizedBox.shrink()
                                    : LatestArticles(
                                        searchQuery: _searchQuery,
                                        selectedCategory: _selectedCategory,
                                        isLoading: isLoading,
                                      ),
                                AllArticles(
                                  uid: widget.uid,
                                  selectedFilter: _selectedFilter,
                                  searchQuery: _searchQuery,
                                  selectedCategory: _selectedCategory,
                                  isLoading: isLoading,
                                ),
                                const SizedBox(height: 60),
                              ],
                            ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 24,
                right: 16,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddArticleScreen(
                          username: widget.username ?? "Anonymous",
                          uid: widget.uid,
                        ),
                      ),
                    );
                  },
                  child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: colorTheme.primary),
                      child: const Center(
                        child:
                            Icon(Icons.article, color: Colors.white, size: 20),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}

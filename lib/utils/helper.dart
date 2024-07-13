import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ArticleCategory {
  Tech,
  Beauty,
  Story,
  Myth,
  Craft,
  Education,
  Fashion,
  Nature,
  Other,
}

extension ArticleCategoryExtension on ArticleCategory {
  static ArticleCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return ArticleCategory.Tech;
      case 'beauty':
        return ArticleCategory.Beauty;
      case 'story':
        return ArticleCategory.Story;
      case 'myth':
        return ArticleCategory.Myth;
      case 'craft':
        return ArticleCategory.Craft;
      case 'education':
        return ArticleCategory.Education;
      case 'fashion':
        return ArticleCategory.Fashion;
      case 'nature':
        return ArticleCategory.Nature;
      case 'other':
        return ArticleCategory.Other;
      default:
        throw ArgumentError('Invalid category string: $category');
    }
  }
}

class ArticleCategoryHelper {
  static const List<Color> _categoriesColor = [
    Color(0xff74abd7),
    Color(0xffa591fc),
    Color(0xff8658cc),
    Color(0xffab58b2),
    Color(0xfcbe72b4),
    Color(0xff9f3f64),
    Color(0xffbe6b58),
    Color(0xff71b247),
    Color(0xff4b9445),
  ];  static const List<Color> _categoriesDarkColor = [
    Color(0xff2f4657),
    Color(0xff433e59),
    Color(0xff392c4d),
    Color(0xff613064),
    Color(0xfc70466b),
    Color(0xff542134),
    Color(0xff41261f),
    Color(0xff304b1e),
    Color(0xff234620),
  ];


  static Color? colorManage(ArticleCategory category) {
    switch (category) {
      case ArticleCategory.Tech:
        return _categoriesColor[0];
      case ArticleCategory.Beauty:
        return _categoriesColor[1];
      case ArticleCategory.Story:
        return _categoriesColor[2];
      case ArticleCategory.Myth:
        return _categoriesColor[3];
      case ArticleCategory.Craft:
        return _categoriesColor[4];
      case ArticleCategory.Education:
        return _categoriesColor[5];
      case ArticleCategory.Fashion:
        return _categoriesColor[6];
      case ArticleCategory.Nature:
        return _categoriesColor[7];
      case ArticleCategory.Other:
        return _categoriesColor[8];
    }
  }
  static Color? darkColorManage(ArticleCategory category) {
    switch (category) {
      case ArticleCategory.Tech:
        return _categoriesDarkColor[0];
      case ArticleCategory.Beauty:
        return _categoriesDarkColor[1];
      case ArticleCategory.Story:
        return _categoriesDarkColor[2];
      case ArticleCategory.Myth:
        return _categoriesDarkColor[3];
      case ArticleCategory.Craft:
        return _categoriesDarkColor[4];
      case ArticleCategory.Education:
        return _categoriesDarkColor[5];
      case ArticleCategory.Fashion:
        return _categoriesDarkColor[6];
      case ArticleCategory.Nature:
        return _categoriesDarkColor[7];
      case ArticleCategory.Other:
        return _categoriesDarkColor[8];
    }
  }
  static Image? iconManager(ArticleCategory category) {
    switch (category) {
      case ArticleCategory.Tech:
        return const Image(image:AssetImage( "assets/images/tech.png"),color: Colors.white,width: 22);
      case ArticleCategory.Beauty:
        return const Image(image:AssetImage( "assets/images/beauty.png"),color: Colors.white,);
      case ArticleCategory.Story:
        return const Image(image:AssetImage( "assets/images/story.png"),color: Colors.white,);
      case ArticleCategory.Myth:
        return const Image(image:AssetImage( "assets/images/myth.png"),color: Colors.white,);
      case ArticleCategory.Craft:
        return const Image(image:AssetImage( "assets/images/craft.png"),color: Colors.white,);
      case ArticleCategory.Education:
        return const Image(image:AssetImage( "assets/images/education.png"),color: Colors.white,width: 22,);
      case ArticleCategory.Fashion:
        return const Image(image:AssetImage( "assets/images/fashion.png"),color: Colors.white,);
      case ArticleCategory.Nature:
        return const Image(image:AssetImage( "assets/images/nature.png"),color: Colors.white,);
      case ArticleCategory.Other:
        return const Image(image:AssetImage( "assets/images/other.png"),color: Colors.white,width: 18,);
    }
}}

// Example of how to use the enum and function
bool isDarkMode(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark;
}
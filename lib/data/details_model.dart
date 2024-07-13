import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String? image;
  String? title;
  String? description;
  String? author;
  Timestamp? date;
  String? category;
  String? quotes;
  String? uid;

  Article({
    this.image,
    this.title,
    this.description,
    this.author,
    this.date,
    this.category,
    this.quotes,
    required this.uid,
  });

  // Create a factory method to convert Firebase data to the model
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      image: map['image'],
      title: map['title'],
      description: map['description'],
      author: map['author'],
      date: map['date'],
      category: map['category'],
      quotes: map['quotes'], uid: map['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'description': description,
      'author': author,
      'date': date,
      'category': category,
      'quotes': quotes,
      'uid':uid,
    };
  }
}

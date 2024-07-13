import '../../utils/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/helper.dart';

class FireStoreService{

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllArticlesStream() {
    return _fireStore
        .collection('articles')
        .orderBy('date', descending: true)
        .snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getLatestArticlesStream() {
    return _fireStore
        .collection('articles')
        .orderBy('date', descending: true)
        .limit(6)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoryArticlesStream(
      ArticleCategory? category, String? selectedFilter, String? uid) {
    return _fireStore
        .collection('articles')
        .orderBy('date', descending: true)
        .where('uid', isEqualTo: selectedFilter == 'MA' ? uid : null)
        .where('category',
        isEqualTo: category.toString().isEmpty || selectedFilter == 'MA'
            ? null
            : category
            .toString()
            .split('.')
            .last
            .capitalizeFirst())
        .snapshots();
  }

  Future<void> updateArticle(String id, Map<String, dynamic> data) async {
    await _fireStore
        .collection('articles')
        .doc(id)
        .update(data);
  }

  Future<void> addArticle(Map<String, dynamic> data) async {
    await _fireStore.collection('articles').add(data);
  }

  Future<void> deleteArticle(String articleId) async {
    try {
      await _fireStore.collection('articles').doc(articleId).delete();
    } catch (e) {
      throw Exception('Error deleting article: $e');
    }
  }
}
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import '../../feature/components/common_textfield.dart';
import '../../service/firestore_service.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/common_fill_button.dart';
import '../home/home_screen.dart';

class AddArticleScreen extends StatefulWidget {
  final String username;
  final String uid;

  const AddArticleScreen({Key? key, required this.username, required this.uid})
      : super(key: key);

  @override
  AddArticleScreenState createState() => AddArticleScreenState();
}

class AddArticleScreenState extends State<AddArticleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quotesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FireStoreService fireStoreService = FireStoreService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _selectedImage;
  String message = "";
  bool isLoading = false;
  bool validate = true;
  bool isSelect = false;
  int _selectedCategoryIndex = 0;
  User? user;

  Widget snackBar(String message) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(message, style: AppTextStyle().textWarningStyle),
    );
  }

  bool validation() {
    if (_titleController.text.isEmpty) {
      message = "Please give a title for your Article";
      validate = false;
    } else if (_descriptionController.text.isEmpty) {
      message = "Your Content is empty. Please write something";
      validate = false;
    } else {
      validate = true;
    }
    return validate;
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (_selectedImage != null) {
        final DateTime now = DateTime.now();
        String? imagePath = 'article_images/${now.microsecondsSinceEpoch}.jpg';
        final Reference storageReference = _storage.ref().child(imagePath);
        await storageReference.putFile(_selectedImage!);
        final String downloadURL = await storageReference.getDownloadURL();
        await _saveArticleToFirestore(downloadURL);
        if (downloadURL.isNotEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(uid: user?.uid ?? "")));
        }
      } else {
        await _saveArticleToFirestore(null);
      }
    } on FirebaseException catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  Future<void> _saveArticleToFirestore(String? imageUrl) async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    String? quotes = _quotesController.text.trim();
    final String author = widget.username;
    final String uid = widget.uid;
    final Timestamp date = Timestamp.now();

    try {
      if (validation()) {
        setState(() {
          isLoading = true;
        });
        await Future.delayed(const Duration(seconds: 2)).then((value) async {
          await fireStoreService.addArticle({
            'title': title,
            'description': description,
            'quotes': quotes,
            'author': author,
            'uid': uid,
            'image': imageUrl,
            'date': date,
            'category': ArticleCategory.values[_selectedCategoryIndex]
                .toString()
                .split('.')
                .last,
          });
          setState(() {
            isLoading = false;
          });
        });

        if (mounted) {
          Navigator.pop(context);
        }
      } // Close the add article screen
    } on FirebaseException catch (e) {
      print('Error adding article to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorTheme.background,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isLoading
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 16,
              ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Write Your Article",
                  style: AppTextStyle().textHeading2Style(context),
                ),
              ),
              validate ? const SizedBox.shrink() : snackBar(message),
              const SizedBox(height: 16),
              isLoading
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextField(
                                textEditingController: _titleController,
                                label: "Choose Title",
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 4),
                                child: Text(
                                  "Select Category",
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle()
                                      .textBodyLightFontStyle(context),
                                ),
                              ),
                              ListView(
                                shrinkWrap: true,
                                children: [
                                  Wrap(
                                      spacing: 8.0,
                                      children: List.generate(
                                          ArticleCategory.values.length,
                                          (index) => ChoiceChip(
                                                label: Text(ArticleCategory
                                                    .values[index]
                                                    .toString()
                                                    .split('.')
                                                    .last),
                                                selected:
                                                    _selectedCategoryIndex ==
                                                        index,
                                                elevation: 0,
                                                backgroundColor:
                                                    isDarkMode(context)
                                                        ? colorTheme
                                                            .tertiaryContainer
                                                        : colorTheme.shadow,
                                                selectedColor:
                                                    colorTheme.primary,
                                                labelStyle: TextStyle(
                                                    color:
                                                        _selectedCategoryIndex ==
                                                                index
                                                            ? !isDarkMode(
                                                                    context)
                                                                ? Colors.white
                                                                : Colors.black
                                                            : isDarkMode(
                                                                    context)
                                                                ? Colors.white
                                                                : Colors.black),
                                                onSelected: (selected) {
                                                  setState(() {
                                                    isSelect = selected;
                                                    _selectedCategoryIndex =
                                                        selected ? index : 0;
                                                  });
                                                },
                                              )).toList()),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CommonTextField(
                                textEditingController: _quotesController,
                                label: "Quotes",
                              ),
                              const SizedBox(height: 16),
                              CommonTextField(
                                textEditingController: _descriptionController,
                                label: "Write Description",
                                maxLine: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "Select Image",
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle()
                                      .textBodyLightFontStyle(context),
                                ),
                              ),
                              GestureDetector(
                                onTap: _pickImage,
                                child: _selectedImage != null
                                    ? Stack(
                                        children: [
                                          Container(
                                              height: 200,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black45),
                                                color: Colors.transparent,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                child: Image.file(
                                                  _selectedImage!,
                                                  height: 200,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              )),
                                          Positioned(
                                              right: 0,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedImage = null;
                                                    });
                                                  },
                                                  icon:
                                                      const Icon(Icons.clear)))
                                        ],
                                      )
                                    : Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.4)),
                                          color: Colors.transparent,
                                        ),
                                        child: const Icon(
                                          Icons.image,
                                          size: 28,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: CommonFillButton(
                  click: () async {
                    setState(() {});
                    if (validation()) {
                      isLoading = true;
                      await _uploadImage();

                      isLoading = false;
                    }
                  },
                  name: "Upload your Article",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

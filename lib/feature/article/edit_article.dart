import 'dart:io';
import '../../feature/components/common_alert.dart';
import '../../feature/components/common_textfield.dart';
import '../../feature/home/home_screen.dart';
import '../../utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/details_model.dart';
import '../../service/firestore_service.dart';
import '../components/common_fill_button.dart';

class EditArticleScreen extends StatefulWidget {
  final Article article;
  final String? id;

  const EditArticleScreen({Key? key, required this.article, this.id});

  @override
  EditArticleScreenState createState() => EditArticleScreenState();
}

class EditArticleScreenState extends State<EditArticleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quotesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FireStoreService fireStoreService = FireStoreService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _selectedImage;

  @override
  void initState() {
    _titleController.text = widget.article.title ?? "";
    _descriptionController.text = widget.article.description ?? "";
    _quotesController.text = widget.article.quotes ?? "";
    super.initState();
  }

  Widget snackBar(String message) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(message, style: AppTextStyle().textWarningStyle),
    );
  }

  bool validate = true;
  String message = "";

  bool validation() {
    if (_titleController.text.isEmpty) {
      message = "Please give a title for your Article";
      validate = false;
    }
    if (_descriptionController.text.isEmpty) {
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
      } else {
        await _saveArticleToFirestore(null);
      }
    } on FirebaseException {
      validate = false;
      message = 'Error uploading image to Firebase Storage';
    }
  }

  Future<void> _saveArticleToFirestore(String? imageUrl) async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    String? quotes = _quotesController.text.trim();
    final Timestamp date = Timestamp.now();

    try {
      if (validation()) {
        await fireStoreService.updateArticle(widget.id!, {
          'title': title,
          'description': description,
          'quotes': quotes,
          'image': widget.article.image ?? imageUrl,
          'date': date,
        });
        if (mounted) {
          Navigator.pop(context);
        }
      } // Close the add article screen
    } on FirebaseException {
      validate = false;
      message = 'Error adding article to Firestore';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorTheme.background,
      body: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  IconButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const Icon(
                      Icons.delete_outlined,
                      size: 22,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      showDialog(
                          useRootNavigator: false,
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return Center(
                              child: CommonAlert(
                                warning:
                                    'Are you sure you want to delete this article? This action cannot be undone, and you will not be able to read or edit it again.',
                                name: "Delete",
                                negativeName: "Don't Delete",
                                click: () async {
                                  await FireStoreService()
                                      .deleteArticle(widget.id ?? "");
                                  if (mounted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                                uid: widget.article.uid ?? "")));
                                  }
                                },
                                negativeClick: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Edit Your Article",
                  style: AppTextStyle().textHeading2Style(context),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              validate ? const SizedBox.shrink() : snackBar(message),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextField(
                          textEditingController: _titleController,
                          label: "Choose Title",
                        ),
                        const SizedBox(
                          height: 16,
                        ),
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            "Select Image",
                            textAlign: TextAlign.left,
                            style: AppTextStyle().textBodyLightFontStyle(context),
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: widget.article.image != null
                              ? Stack(
                                  children: [
                                    Container(
                                        height: 200,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.black45),
                                          color: Colors.transparent,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Image.network(
                                            widget.article.image!,
                                            height: 200,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )),
                                    Positioned(
                                        right: 0,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                widget.article.image = null;
                                              });
                                            },
                                            icon: const Icon(Icons.clear)))
                                  ],
                                )
                              : _selectedImage != null
                                  ? Stack(
                                      children: [
                                        Container(
                                            height: 200,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.black45),
                                              color: Colors.transparent,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
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
                                                icon: const Icon(Icons.clear)))
                                      ],
                                    )
                                  : Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey.withOpacity(0.4)),
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
                    setState(() {
                      validation();
                    });
                    await _uploadImage();
                  },
                  name: "Save Your article",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../service/auth_service.dart';
import '../../utils/constant.dart';
import '../components/common_snackbar.dart';
import '../onboarding/login.dart';
import 'display_profile.dart';
import 'home_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  final String uid;
  final String username;

  const ProfilePage({super.key, required this.uid, required this.username});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();
  File? _selectedProfileImage;
  String? _profileImageUrl;
  String? message;
  bool? loading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    _profileImageUrl = await authService.getProfileImage(widget.uid);
  }

  Future<void> _pickProfileImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedProfileImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_selectedProfileImage != null) {
      setState(() {
        loading = true;
      });
      String? imageUrl = await authService.uploadProfileImage(
          widget.uid, _selectedProfileImage!);
      if (imageUrl != null) {
        loading = false;
        message = authService.errorMessage?.message ?? "Successfully Uploaded.";
        setState(() {
          _profileImageUrl = imageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              username: widget.username,
                              uid: widget.uid,
                            ),
                          ),
                        );
                      },
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 24,
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.zero),
                  Text(
                    "Edit Profile",
                    style: AppTextStyle().textHeading1Style,
                  ),
                  const SizedBox(height: 32),
                  loading == true
                      ? const Center(child: CircularProgressIndicator())
                      : _selectedProfileImage != null
                          ? Center(
                              child: Container(
                                height: 120,
                                width: 120,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                        image:
                                            FileImage(_selectedProfileImage!),
                                        fit: BoxFit.fill)),
                              ),
                            )
                          : _profileImageUrl != null
                              ? Center(
                                  child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          NetworkImage(_profileImageUrl!)),
                                )
                              : Center(
                                  child: UserProfileImage(
                                    uid: widget.username,
                                    username: widget.username,
                                    size: 120,
                                  ),
                                ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _pickProfileImage();
                        });
                      },
                      child: const Text("Pick Profile Image"),
                    ),
                  ),
                  message == null
                      ? const SizedBox.shrink()
                      : CommonSnackBar(
                          onClose: () {},
                          success: message != authService.errorMessage?.message
                              ? true
                              : false,
                          description: message,
                          title: message != authService.errorMessage?.message
                              ? "Successful"
                              : "Upload Failed",
                        ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                ElevatedButton(
                  onPressed: _uploadProfileImage,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("Upload Profile Image"),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await AuthService().signOut();
                      setState(() {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      });
                    },
                    child: const Text("Log Out",style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],)

            ],
          ),
        ),
      ),
    );
  }
}

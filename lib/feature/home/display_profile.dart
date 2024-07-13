import '../../utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../service/auth_service.dart';
import '../components/initial_image.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserProfileImage extends StatefulWidget {
  final String uid;
  final String username;
  final double? size;

  const UserProfileImage({
    super.key,
    required this.uid,
    required this.username,
    this.size = 60,
  });

  @override
  UserProfileImageState createState() => UserProfileImageState();
}

class UserProfileImageState extends State<UserProfileImage> {
  User? user = _auth.currentUser;
  late Future<String?> profile;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    profile = AuthService().getProfileImage(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: profile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          imageUrl = snapshot.data;
          return imageUrl != null && !snapshot.hasError
              ? ClipOval(
                  child: SizedBox(
                    height: widget.size,
                    width: widget.size,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl ?? "",
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : InitialImage(
                  name: widget.username.capitalizeByWord(),
            size: widget.size??24,
                );
        }
      },
    );
  }
}

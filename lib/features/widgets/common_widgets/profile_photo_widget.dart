import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    super.key,
    required XFile? profileImage,
  }) : _profileImage = profileImage;

  final XFile? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: _profileImage == null
          ? Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[600],
            )
          : ClipOval(
              child: Image.file(
                File(_profileImage.path),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

class LogoPhoto extends StatelessWidget {
  const LogoPhoto({
    super.key,
    required XFile? profileImage,
  }) : _profileImage = profileImage;

  final XFile? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: _profileImage == null
          ? Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[600],
            )
          : ClipOval(
              child: Image.file(
                File(_profileImage.path),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

class ProfilePhotoNet extends StatelessWidget {
  const ProfilePhotoNet({
    super.key,
    required this.profileImage,
  });

  final String? profileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: profileImage == null
          ? Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[600],
            )
          : ClipOval(
              child: Image.network(
                profileImage!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

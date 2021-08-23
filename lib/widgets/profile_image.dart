import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {

  final image;
  final size;

  ProfileImage({this.image, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Colors.grey.withOpacity(0.2),
      backgroundImage: CachedNetworkImageProvider(image),

    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget profileWidget({String? imageUrl, File? image, Uint8List? imageWeb}) {
  print(imageUrl);
  if (imageUrl != null &&
      imageUrl != "" &&
      (image == null || imageWeb == null)) {
    return CachedNetworkImage(
      imageUrl: "$imageUrl",
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return CircularProgressIndicator();
      },
      errorWidget: (context, url, error) => Image.asset(
        'assets/profile_default.png',
        fit: BoxFit.cover,
      ),
    );
  } else if (image != null) {
    return Image.file(
      image,
      fit: BoxFit.cover,
    );
  } else if (imageWeb != null) {
    return Image.memory(imageWeb);
  } else {
    return Image.asset(
      'assets/profile_default.png',
      fit: BoxFit.cover,
    );
  }
}

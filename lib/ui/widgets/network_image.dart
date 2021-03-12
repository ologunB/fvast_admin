import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/constants/styles.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  CachedImage({this.size, this.imageUrl});

  final String person =
      "https://firebasestorage.googleapis.com/v0/b/proj-along.appspot.com/o/person.png?alt=media&token=54d54309-fa02-4000-b156-188ee2a38c7f";

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(color: Styles.appCanvasBlue, width: 1)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? person,
            height: size,
            width: size,
            fit: BoxFit.fill,
            placeholder: (context, url) => Image(
                image: AssetImage("images/person.png"),
                height: size,
                width: size,
                fit: BoxFit.contain),
            errorWidget: (context, url, error) => Image(
                image: AssetImage("images/person.png"),
                height: size,
                width: size,
                fit: BoxFit.contain),
          ),
        ));
  }
}

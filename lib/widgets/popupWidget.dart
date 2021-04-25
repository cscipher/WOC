import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

createPopup(BuildContext ctx, String photo, String status) {

  return showDialog(context: ctx, builder: (ctx){
    return Dialog(
      insetAnimationCurve: Curves.decelerate,
      insetAnimationDuration: const Duration(milliseconds: 2000),
      child: Container(
        height: status.isNotEmpty ? MediaQuery.of(ctx).size.height*0.5 : MediaQuery.of(ctx).size.height*0.3655,
        child: Column(
          children: [
            Container(
                child: Image(image: CachedNetworkImageProvider(photo),)
            ),
            status.isNotEmpty ? Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                // alignment: Alignment.center,
                child: Text(status, style: TextStyle(
                    fontSize: 16
                ),)
            ) : Container()
          ],
        ),
      ),
    );
  });
}


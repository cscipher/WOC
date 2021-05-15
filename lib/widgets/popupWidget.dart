import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

createPopup(BuildContext ctx, String photo, String status) {
  return showDialog(
      context: ctx,
      builder: (ctx) {
        return Dialog(
          child: Container(
            // height: status.isNotEmpty
            //     ? MediaQuery.of(ctx).size.height * 0.2
            //     : MediaQuery.of(ctx).size.height * 0.2,
            height: MediaQuery.of(ctx).size.height * 0.485,

            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      child: Image(
                    image: CachedNetworkImageProvider(photo),
                  )),
                ),
                status.isNotEmpty
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        // alignment: Alignment.center,
                        child: Text(
                          status,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ))
                    : Container()
              ],
            ),
          ),
        );
      });
}

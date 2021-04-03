import 'package:flutter/material.dart';

createPopup(BuildContext ctx, String photo, String status) {
  return showDialog(context: ctx, builder: (ctx){
    return Dialog(
      child: Container(
        height: MediaQuery.of(ctx).size.height*0.5,
        child: Column(
          children: [
            Container(
                child: Image(image: NetworkImage(photo),)
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                // alignment: Alignment.center,
                child: Text(status, style: TextStyle(
                    fontSize: 16
                ),)
            )
          ],
        ),
      ),
    );
  });
}
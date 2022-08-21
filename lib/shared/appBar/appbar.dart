import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar(
        {required String title, required BuildContext context,String? txtbtn,Function? onPressed}) =>
    AppBar(
      actions: [
        MaterialButton(onPressed: ()
        {
          return onPressed!() != null ?onPressed() : null ;
        },child: Text(txtbtn!=null ? txtbtn : ''),)
      ],
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ));

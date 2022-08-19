import 'package:flutter/material.dart';

Widget defaultButton({required context,required String txt,required IconData iconty,required Function onTap,double? fontSize = 4}) => Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset(0.0, 8), blurRadius: 10, color: Colors.black12)
      ], borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Row(children: [
        InkWell(
          onTap: ()
          {
            return onTap();
          },
          child: Container(
            alignment: Alignment.centerLeft,
            width: 110,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(95),
                topLeft: Radius.circular(95),
                bottomRight: Radius.circular(200),
              ),
            ),
            child: Text(txt,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .apply(color: Colors.white, fontSizeDelta: fontSize!)),
          ),
        ),
         Icon(
         iconty,
          size: 30,
        )
      ]),
    );

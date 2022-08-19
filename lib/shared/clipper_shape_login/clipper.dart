import 'package:flutter/material.dart';

Widget ClipperShape({required String txt}) => Container(
        child: Stack(
      children: [
        Opacity(
          opacity: .5,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              height: 240,
              //child: Text('LOGIN',style: TextStyle(color: Colors.white,fontSize: 25),),
            ),
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            alignment: Alignment.bottomLeft,
            color: Colors.blue,
            height: 230,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                txt,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ),
      ],
    ));

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height);

    var firstStart = Offset(size.width / 5, size.height);

    var firstEnd = Offset(size.width / 2.25, size.height - 50);

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    var secondEnd = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

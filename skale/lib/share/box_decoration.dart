import 'package:flutter/material.dart';

BoxDecoration boxDecorationTopRightLeft(
    {Color? color, required double radius}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    ),
  );
}

BoxDecoration boxDecorationAll({Color? color, required double radius}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    ),
  );
}

BoxDecoration boxDecorationTopLeft({Color? color, required double radius}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radius),
    ),
  );
}

BoxDecoration boxDecorationTopRight({Color? color, required double radius}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(radius),
    ),
  );
}

Widget boxDecorationBorderStroke({required child, double? width,double? height, Color? cor,double? borderWidth}) {
  return Container(
    alignment: Alignment.center,
    width: width,
    height: height,
    decoration: BoxDecoration(
      border: Border.all(width: borderWidth ?? 1),
      color: cor,
    ),
    child: child,
  );
}

BoxDecoration boxDecorationBottomLeftRight(
    {Color? color, required double radius}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    ),
  );
}

import 'package:flutter/material.dart';

import 'text_style.dart';

SnackBar snackMessage(String texto,{int? duration}) {
    return SnackBar(
      content: Text(
        texto,
        style: primaryStyle(size: 18),
      ),
      duration: Duration(seconds: duration ?? 7),
    );
  }
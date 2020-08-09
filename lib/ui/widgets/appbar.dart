import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
    child: AppBar(
      backgroundColor: Colors.green,
      title: Text('Number Trivia'),
    ),
  );
}

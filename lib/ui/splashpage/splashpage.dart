import 'package:flutter/material.dart';

import '../../routes/routes.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 700)).then(
      (_) => Navigator.of(context).pushAndRemoveUntil(
        Routes.home(),
        (route) => false,
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Text('Number Magic'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}

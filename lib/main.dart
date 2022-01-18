import 'package:flutter/material.dart';

import 'global.dart';

void main() => Global.init().then((e) => runApp(const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

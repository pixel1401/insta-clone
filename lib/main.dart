import 'package:flutter/material.dart';
import 'package:insta_clone/features/presentation/page/credential/sign_in_page.dart';
import 'package:insta_clone/on_generate_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Instagram Clone",
      darkTheme: ThemeData.dark(),
      onGenerateRoute: OnGenerateRoute.route ,
      initialRoute: "/",
      routes: {
        "/": (context) {
          return SignInPage();
        }
      },
    );
  }
}

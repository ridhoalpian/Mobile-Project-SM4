import 'package:flutter/material.dart';
import 'package:projectone/login_register/login_page.dart';
import 'package:projectone/login_register/register_page.dart';
import 'package:projectone/home/home_page.dart';
import 'package:projectone/login_register/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        textTheme: TextTheme(
        bodyText1: TextStyle(fontFamily: 'Montserrat'), 
        bodyText2: TextStyle(fontFamily: 'Montserrat'), 
      ),
      ),
      initialRoute: '/', //modalroute
      routes: {
        '/': (context) => Splash(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

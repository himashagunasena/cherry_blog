import '../../utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'feature/onboarding/login.dart';
import 'feature/onboarding/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Blog App',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: ThemeColor.themes.shade500,
          onPrimary: ThemeColor.white,
          secondary: ThemeColor.themes.shade300,
          onSecondary: ThemeColor.white,
          tertiary: ThemeColor.themes.shade600,
          error: ThemeColor.warning,
          onError: Colors.white,
          background: ThemeColor.background,
          shadow: ThemeColor.themes.shade50,
          onBackground: Colors.black,
          surface: ThemeColor.white,
          onSurface: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: ThemeColor.themes.shade500,
          onPrimary: ThemeColor.white,
          secondary: ThemeColor.themes.shade300,
          onSecondary: ThemeColor.white,
          tertiary: ThemeColor.themes.shade600,
          tertiaryContainer: ThemeColor.themes.shade100,
          error: ThemeColor.warning,
          onError: Colors.white,
          background: Colors.black,
          shadow: ThemeColor.themes.shade50,
          onBackground: Colors.black,
          surface: ThemeColor.darkBackground,
          onSurface: Colors.black,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/register',
      routes: {
        //'/': (context) => HomeScreen(uid: '',),
        '/login': (context) => LoginScreen(),
        '/register': (context) => SignUpScreen(),
        // '/articles': (context) => ArticleListScreen(),
        // '/own_articles': (context) => OwnArticlesScreen(),
        // '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

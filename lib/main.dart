import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'theme/luxury_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: LuxuryColors.darkBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HwtListerApp());
}

class HwtListerApp extends StatefulWidget {
  const HwtListerApp({super.key});

  @override
  State<HwtListerApp> createState() => _HwtListerAppState();
}

class _HwtListerAppState extends State<HwtListerApp> {
  bool _isDark = true;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HWT Lister - Haute Horlogerie',
      debugShowCheckedModeBanner: false,
      theme: LuxuryTheme.lightTheme,
      darkTheme: LuxuryTheme.darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        isDark: _isDark,
      ),
    );
  }
}

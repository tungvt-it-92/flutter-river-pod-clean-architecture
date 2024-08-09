import 'package:flutter/material.dart';

import 'presentation/page/main/index.dart';
import 'presentation/resources/index.dart';
import 'presentation/utils/page_tag.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalizations.shared.reloadLanguageBundle(languageCode: 'en');
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Colors.transparent),
      ),
      home: const MainPage(
        pageTag: PageTag.main,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

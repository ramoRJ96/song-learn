import 'package:flutter/material.dart';

import 'kit/widgets/kit_page.dart';
import 'theme/app_theme.dart';

class SongLearnApp extends StatelessWidget {
  const SongLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song Learn',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const KitPage(),
    );
  }
}

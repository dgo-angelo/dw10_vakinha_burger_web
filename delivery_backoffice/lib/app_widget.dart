import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'src/core/global/global_context.dart';
import 'src/core/ui/theme/theme_config.dart';

class AppWidget extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  AppWidget({super.key}) {
    GlobalContext.instance.navigatorKey = _navigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/login');
    Modular.setNavigatorKey(_navigatorKey);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Vakinha Burger',
      theme: ThemeConfig.theme,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}

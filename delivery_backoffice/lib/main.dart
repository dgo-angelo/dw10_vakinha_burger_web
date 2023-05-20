import 'app_widget.dart';
import 'src/modules/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'src/core/env/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.instance.load();

  runApp(
    ModularApp(
      module: AppModule(),
      child: AppWidget(),
    ),
  );
}

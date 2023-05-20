import 'package:flutter/material.dart';

import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import '../../core/ui/styles/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Loader, Messages {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: const InputDecoration(
                label: Text('FormField'),
              ),
            ),
          ),
          Container(
            color: context.colors.secondary,
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Button'),
            ),
          ),
        ],
      ),
    );
  }
}
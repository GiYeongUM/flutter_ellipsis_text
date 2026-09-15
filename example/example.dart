import 'package:flutter/material.dart';
import 'package:flutter_ellipsis_text/flutter_ellipsis_text.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Expandable text',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
    ),
    home: const ExamplePage(),
  );
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});
  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Expandable text')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const EllipsisText(
          text:
              'Flutter packages should follow your app’s typography, color scheme, '
              'layout constraints, and accessibility preferences. Tap this paragraph '
              'to read the complete description, and tap again to collapse it.',
          ellipsis: '… more',
          maxLines: 2,
        ),
        const SizedBox(height: 24),
        const EllipsisText(
          text:
              'هذا مثال لنص يدعم اتجاه الكتابة من اليمين إلى اليسار ويعرض المزيد عند الضغط عليه.',
          ellipsis: '…',
          textDirection: TextDirection.rtl,
          maxLines: 1,
        ),
      ],
    ),
  );
}

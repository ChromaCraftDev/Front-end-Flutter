import 'package:chroma_craft_1/engine/fetch.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class Browser extends StatefulWidget {
  const Browser({super.key});

  @override
  State<Browser> createState() => _Browser();
}

class _Browser extends State<Browser> {
  late final Map<String, dynamic> _metadata;
  var _loaded = false;

  @override
  void initState() {
    super.initState();
    fetchTemplateMetadata().then((value) => setState(() {
          _metadata = value;
          _loaded = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 60.0, title: const Text('ChromaCraft')),
      body: !_loaded
          ? const Text(
              'Loading templates...',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: _metadata.entries.map(_buildTemplateCard).toList(),
            ),
    );
  }

  Widget _buildTemplateCard(MapEntry<String, dynamic> e) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            e.key,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
          )),
    );
  }

  @override
  void dispose() => super.dispose();
}

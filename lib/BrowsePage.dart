import 'engine/fetch.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'engine/meta.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class Browser extends StatefulWidget {
  const Browser({super.key});

  @override
  State<Browser> createState() => _Browser();
}

class _Browser extends State<Browser> {
  late final List<TemplateMetadata> _templates;
  var _loaded = false;

  @override
  void initState() {
    super.initState();
    fetchTemplatesList().then((value) => setState(() {
          _templates = value;
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
              children: _templates.map(_buildTemplateCard).toList(),
            ),
    );
  }

  Widget _buildTemplateCard(TemplateMetadata meta) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(image: NetworkImage(meta.previewUrl.toString())),
            Text(meta.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Supported Platforms: "),
                Column(
                  children: meta.platforms.map((it) => Text(it.name)).toList(),
                )
              ],
            ),
            InkWell(
              child: const Text("Project Homepage"),
              onTap: () => launchUrl(meta.projectHomepage),
            ),
            FutureBuilder(
              future: templateNeedsUpdate(meta.name, _templates),
              builder: (_, it) => Text(
                it.hasError
                    ? "Update Error: ${it.error}"
                    : (it.data! ? "Needs Update" : "Already up to date"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

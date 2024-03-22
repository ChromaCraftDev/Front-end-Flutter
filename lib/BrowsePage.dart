import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          ? const Center(
              child: Text(
                'Loading templates...',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: _templates.map(_buildTemplateCard).toList(),
              ),
            ),
    );
  }

  Widget _buildTemplateCard(TemplateMetadata meta) {
    return IntrinsicWidth(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meta.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Image(image: NetworkImage(meta.previewUrl), width: 500),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const Text("Project Homepage"),
                  onTap: () => launchUrl(meta.projectHomepage),
                ),
                Column(
                  children: meta.platforms
                      .map((it) => switch (it) {
                            Platform.windows =>
                              const FaIcon(FontAwesomeIcons.windows),
                            Platform.macos =>
                              const FaIcon(FontAwesomeIcons.apple),
                            Platform.linux =>
                              const FaIcon(FontAwesomeIcons.linux),
                            Platform.invalid =>
                              const FaIcon(FontAwesomeIcons.exclamation),
                          })
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/about/dependecies.dart';
import '../../model/about/dependency.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("关于"),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _buildAboutHeader(context),
          const SizedBox(height: 16),
          Text("开源依赖", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dependencies.length,
            itemBuilder: (context, index) {
              return _buildDependencyItem(context, dependencies[index]);
            },
            separatorBuilder: (context, _) => const Divider(height: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildDependencyItem(BuildContext context, Dependency dependency) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      title: Text(
        dependency.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dependency.description,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 2),
          Text("License: ${dependency.license}",
              style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
      trailing: Text(dependency.author,
          style: Theme.of(context).textTheme.bodySmall),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () => launchUrl(Uri.parse(dependency.url)),
    );
  }

  Widget _buildAboutHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("玩安卓", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text("作者: opoojkk", style: Theme.of(context).textTheme.bodyLarge),
        Text("仓库: opoojkk/wandroid",
            style: Theme.of(context).textTheme.bodyLarge),
        Text("基于玩Android api",
            style: Theme.of(context).textTheme.bodyLarge),
        Text("本项目 fork 自 hurshi/wanandroid",
            style: Theme.of(context).textTheme.bodyLarge),
        Text("特别感谢: hurshi",
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

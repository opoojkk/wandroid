import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/about/dependecies.dart';
import '../../model/about/dependency.dart';

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('关于')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            _buildAboutHeader(),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dependencies.length,
              itemBuilder: (context, index) {
                Dependency dependency = dependencies[index];
                return _buildDependecyItem(dependency);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 12);
              },
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildDependecyItem(Dependency dependency) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(dependency.url));
      },
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Row(
            children: [
              Text(
                dependency.name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const Spacer(),
              Text(
                dependency.author,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          Text(
            dependency.license,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 4),
          Text(
            dependency.description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Column _buildAboutHeader() {
    return Column(
      children: [
        SizedBox(height: 6),
        Text(
          '基于玩Android api实现的flutter客户端',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Text('fork自原仓库: '),
            InkWell(
              child: Text(
                'hurshi/wanandroid',
                style: TextStyle(color: Colors.blueAccent, fontSize: 16),
              ),
              onTap: () {
                launchUrl(Uri.parse('https://github.com/hurshi/wanandroid'));
              },
            ),
          ],
        ),
        SizedBox(height: 16),
        Text('开源协议', style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
      ],
    );
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

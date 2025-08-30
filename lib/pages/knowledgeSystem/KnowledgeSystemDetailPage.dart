import 'package:flutter/material.dart';

import '../articleList/articleListPage.dart';

class KnowledgeSystemDetailPage extends StatefulWidget {
  final String title;
  final RequestData request;

  const KnowledgeSystemDetailPage({key, required this.title, required this.request})
    : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KnowledgeSystemDetailPageState();
  }
}

class KnowledgeSystemDetailPageState extends State<KnowledgeSystemDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ArticleListPage(request: widget.request),
    );
  }
}

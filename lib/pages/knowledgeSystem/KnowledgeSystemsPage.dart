import 'package:flutter/material.dart';
import 'package:wandroid/network/api/tree.dart';
import 'package:wandroid/network/service/treeService.dart';

import '../../model/knowledgeSystem/KnowledgeSystemsChildModel.dart';
import '../../model/knowledgeSystem/KnowledgeSystemsModel.dart';
import '../../model/knowledgeSystem/KnowledgeSystemsParentModel.dart';
import 'KnowledgeSystemDetailPage.dart';

class KnowledgeSystemsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KnowledgeSystemsPageState();
  }
}

class _KnowledgeSystemsPageState extends State<KnowledgeSystemsPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late KnowledgeSystemsModel _treeModel;

  var loading = true;

  @override
  void initState() {
    super.initState();
    _loadTreeList();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return Center(child: Text("loading..."));
    }

    return Scaffold(
      appBar: AppBar(title: Text('体系')),
      body: ListView.builder(
        itemCount: _treeModel.data.length,
        itemBuilder: (context, index) {
          KnowledgeSystemsParentModel model = _treeModel.data[index];
          return _buildCategoryItem(model);
        },
      ),
    );
  }

  void _loadTreeList() async {
    TreeService.getTrees((KnowledgeSystemsModel _bean) {
      if (mounted) {
        setState(() {
          loading = false;
          _treeModel = _bean;
        });
      }
    });
  }

  Widget _buildCategoryItem(KnowledgeSystemsParentModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 14, top: 20),
          child: Text(
            model.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Wrap(
            direction: Axis.horizontal,
            // 水平排列（默认值）
            alignment: WrapAlignment.start,
            // 主轴对齐方式
            spacing: 8.0,
            // 水平间距
            runSpacing: 12.0,
            // 行间距（垂直间距）
            children: List.generate(model.children.length, (index) {
              final childModel = model.children[index];
              return _buildTag(childModel);
            }),
          ),
        ),
      ],
    );
  }

  ActionChip _buildTag(KnowledgeSystemsChildModel childModel) {
    return ActionChip(
      label: Text(childModel.name),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KnowledgeSystemDetailPage(
              title: childModel.name,
              request: (page) {
                return TreeService.getTreeItemList(
                  "${Tree.treeDetailList}$page/json?cid=${childModel.id}",
                );
              },
            ),
          ),
        );
      },
    );
  }
}

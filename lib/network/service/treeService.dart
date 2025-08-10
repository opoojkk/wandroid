import 'package:dio/dio.dart';
import 'package:wandroid/network/api/tree.dart';

import '../../model/knowledgeSystem/KnowledgeSystemsModel.dart';

class TreeService {
  static void getTrees(Function callback) async {
    Dio().get(Tree.treeList).then((response) {
      callback(KnowledgeSystemsModel.fromJson(response.data));
    });
  }

  static Future<Response> getTreeItemList(String url) async {
    return await Dio().get(url);
  }
}

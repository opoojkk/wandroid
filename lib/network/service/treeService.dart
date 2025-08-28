import 'package:dio/dio.dart';
import 'package:wandroid/network/api/tree.dart';

import '../../model/knowledgeSystem/KnowledgeSystemsModel.dart';
import '../const.dart';
import '../dioClient.dart';

class TreeService {
  static void getTrees(Function callback) async {
    DioClient.getDio().get(Tree.treeList).then((response) {
      callback(KnowledgeSystemsModel.fromJson(response.data));
    });
  }

  static Future<Response> getTreeItemList(String url) async {
    return await DioClient.getDio().get(url);
  }
}

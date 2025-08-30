import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:wandroid/common/Router.dart' show Router;

import '../../model/articleList/ArticleItemModel.dart';
import '../../network/api/avatar.dart';
import '../../utils/StringUtil.dart';
import '../../widget/StrokeWidget.dart';

class ArticleItemPage extends StatelessWidget {
  final ArticleItemModel item;

  const ArticleItemPage(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    //去掉html中的高亮
    item.title = StringUtil.strClean(item.title);
    item.desc = (null == item.desc) ? "" : StringUtil.strClean(item.desc);

    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Router().openArticle(context, item);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 2.5),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: _buildListViewItem(context, item),
            ),
            Divider(
              height: 1.0,
              indent: 20.0,
              endIndent: 20.0,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListViewItem(BuildContext context, ArticleItemModel item) {
    var widget =
        (item.envelopePic.isNotEmpty &&
            !item.envelopePic.endsWith(Avatar.DEFAULT_PROJECT_IMG)) //默认图片就不显示了
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(child: _buildItemLeftSide(context, item)),
              SizedBox(
                width: 30.0,
                child: CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                  imageUrl: item.envelopePic,
                ),
              ),
            ],
          )
        : _buildItemLeftSide(context, item);

    return widget;
  }

  Widget _buildItemLeftSide(BuildContext context, ArticleItemModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildItemLeftColumns(context, item),
    );
  }

  List<Widget> _buildItemLeftColumns(
    BuildContext context,
    ArticleItemModel item,
  ) {
    List<Widget> list = [];
    list.add(
      Padding(
        padding: EdgeInsets.only(bottom: 2),
        child: Text(
          item.title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.left,
        ),
      ),
    );
    if (item.desc.length > item.title.length) {
      list.add(
        Text(
          item.desc,
          maxLines: 3,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    var author = item.author;
    if (author.isNotEmpty) {
      author = "@$author";
    } else {
      author = "";
    }
    list.add(
      Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.access_time,
              size: 13.0,
              // color: GlobalConfig.color_dark_gray,
            ),
            Text(
              " ${item.niceDate} $author",
              style: Theme.of(context).textTheme.bodyMedium, //灰色
            ),
          ],
        ),
      ),
    );
    var tags = _buildTagsAndDate(context,item);
    if (tags.isNotEmpty) {
      list.add(
        Row(
          textBaseline: TextBaseline.ideographic,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: tags,
        ),
      );
    }
    return list;
  }

  List<Widget> _buildTagsAndDate(BuildContext context,ArticleItemModel item) {
    List<Widget> list = [];
    for (var tag in item.tags) {
      list.add(
        StrokeWidget(
          strokeWidth: 0.5,
          edgeInsets: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
          // color: GlobalConfig.color_tags,
          childWidget: Text(
            tag.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    String chapterNameStr =
        "${StringUtil.isNullOrEmpty(item.superChapterName) ? "" : "${(list.isEmpty ? "分类：" : "  ")}${item.superChapterName}"}"
        "${(StringUtil.isNullOrEmpty(item.superChapterName) || StringUtil.isNullOrEmpty(item.chapterName)) ? "" : "/"}"
        "${StringUtil.isNullOrEmpty(item.chapterName) ? "" : item.chapterName}";
    if (!StringUtil.isNullOrEmpty(chapterNameStr.trim())) {
      list.add(
        Text(
          chapterNameStr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
    }
    return list;
  }
}

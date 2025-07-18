/// 屏蔽的分类

import 'dart:convert';

import 'package:pikapika/i18.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../Method.dart';
import '../store/Categories.dart';
import 'ShadowCategoriesEvent.dart';

const _propertyName = "shadowCategories";
late List<String> shadowCategories;

/// 获取封印的类型
Future<List<String>> _loadShadowCategories() async {
  var value = await method.loadProperty(_propertyName, jsonEncode(<String>[]));
  return List.of(jsonDecode(value)).map((e) => "$e").toList();
}

/// 保存封印的类型
Future<dynamic> _saveShadowCategories(List<String> value) {
  return method.saveProperty(_propertyName, jsonEncode(value));
}

Future<void> initShadowCategories() async {
  shadowCategories = await _loadShadowCategories();
}

Future<void> _chooseShadowCategories(BuildContext context) async {
  var theme1 =  Theme.of(context);
  await showDialog(
    context: context,
    builder: (ctx) {
      var initialValue = <String>[];
      for (var element in shadowCategories) {
        if (shadowCategories.contains(element)) {
          initialValue.add(element);
        }
      }
      return MultiSelectDialog<String>(
        backgroundColor: theme1.scaffoldBackgroundColor,
        checkColor: theme1.colorScheme.onSurface,
        title: Text(tr("settings.shadow_categories.title")),
        searchHint: tr("settings.shadow_categories.search_hint"),
        searchable: true,
        cancelText: Text(tr("app.cancel")),
        confirmText: Text(tr("app.confirm")),
        items: storedCategories.map((e) => MultiSelectItem(e, e)).toList(),
        initialValue: initialValue,
        onConfirm: (List<String>? value) async {
          if (value != null) {
            await _saveShadowCategories(value);
            shadowCategories = value;
            shadowCategoriesEvent.broadcast();
          }
        },
        selectedColor: theme1.primaryColor,
        unselectedColor: theme1.textTheme.bodyMedium?.color,
        itemsTextStyle: theme1.textTheme.bodyMedium,
        selectedItemsTextStyle: theme1.textTheme.bodyMedium,
      );
    },
  );
}

Widget shadowCategoriesActionButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      _chooseShadowCategories(context);
    },
    icon: const Icon(Icons.hide_source),
  );
}

Widget shadowCategoriesSetting() {
  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return ListTile(
        title: Text(tr("settings.shadow_categories.title")),
        subtitle: Text(jsonEncode(shadowCategories)),
        onTap: () async {
          await _chooseShadowCategories(context);
          setState(() {});
        },
      );
    },
  );
}

const chooseShadowCategories = _chooseShadowCategories;

/// 阅读器的类型

import 'package:pikapika/i18.dart';
import 'package:flutter/material.dart';
import '../Method.dart';

enum ReaderType {
  WEB_TOON,
  WEB_TOON_ZOOM,
  GALLERY,
  WEB_TOON_FREE_ZOOM,
  TWO_PAGE_GALLERY,
}

// const _types = {
//   'WebToon (默认)': ReaderType.WEB_TOON,
//   'WebToon (双击放大)': ReaderType.WEB_TOON_ZOOM,
//   '相册': ReaderType.GALLERY,
//   'WebToon (ListView双击放大)\n(此模式进度条无效)': ReaderType.WEB_TOON_FREE_ZOOM,
//   '双页模式\n(实验)': ReaderType.TWO_PAGE_GALLERY,
// };

Map<String, ReaderType> _types = {};

enum TwoPageDirection {
  LEFT_TO_RIGHT,
  RIGHT_TO_LEFT,
}

String _twoPageDirectionName(TwoPageDirection direction) {
  switch (direction) {
    case TwoPageDirection.LEFT_TO_RIGHT:
      return tr("settings.reader_type.left_to_right");
    case TwoPageDirection.RIGHT_TO_LEFT:
      return tr("settings.reader_type.right_to_left");
  }
}

TwoPageDirection _twoPageDirectionFromString(String directionString) {
  for (var value in TwoPageDirection.values) {
    if (directionString == value.toString()) {
      return value;
    }
  }
  return TwoPageDirection.LEFT_TO_RIGHT;
}

const _propertyName = "readerType";
late ReaderType _readerType;

const _twoPageDirectionPropertyName = "twoPageDirection";
late TwoPageDirection _twoPageDirection;

TwoPageDirection get twoPageDirection => _twoPageDirection;

Future<dynamic> initReaderType() async {
  _types.addAll({
    tr("settings.reader_type.web_toon"): ReaderType.WEB_TOON,
    tr("settings.reader_type.web_toon_zoom"): ReaderType.WEB_TOON_ZOOM,
    tr("settings.reader_type.gallery"): ReaderType.GALLERY,
    tr("settings.reader_type.web_toon_free_zoom"): ReaderType.WEB_TOON_FREE_ZOOM,
    tr("settings.reader_type.two_page_gallery"): ReaderType.TWO_PAGE_GALLERY,
  });
  _readerType = _readerTypeFromString(
      await method.loadProperty(_propertyName, ReaderType.WEB_TOON.toString()));
  _twoPageDirection = _twoPageDirectionFromString(await method.loadProperty(
      _twoPageDirectionPropertyName,
      TwoPageDirection.LEFT_TO_RIGHT.toString()));
}

ReaderType currentReaderType() {
  return _readerType;
}

ReaderType _readerTypeFromString(String pagerTypeString) {
  for (var value in ReaderType.values) {
    if (pagerTypeString == value.toString()) {
      return value;
    }
  }
  return ReaderType.WEB_TOON;
}

String currentReaderTypeName() {
  for (var e in _types.entries) {
    if (e.value == _readerType) {
      return e.key;
    }
  }
  return '';
}

Future<void> choosePagerType(BuildContext buildContext) async {
  ReaderType? t = await showDialog<ReaderType>(
    context: buildContext,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(tr("settings.reader_type.choose")),
        children: _types.entries
            .map((e) => SimpleDialogOption(
                  child: Text(e.key),
                  onPressed: () {
                    Navigator.of(context).pop(e.value);
                  },
                ))
            .toList(),
      );
    },
  );
  if (t != null) {
    await method.saveProperty(_propertyName, t.toString());
    _readerType = t;
  }
}

Widget readerTypeSettings() {
  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      List<Widget> children = [];
      children.add(_readerTypeTile(context, setState));
      // if (_readerType == ReaderType.TWO_PAGE_GALLERY) {
        children.add(_twoPageDirectionTile(context, setState));
      // }
      return Column(children: children);
    },
  );
}

Widget _readerTypeTile(
  BuildContext context,
  void Function(void Function()) setState,
) {
  return ListTile(
    title: Text(tr("settings.reader_type.title")),
    subtitle: Text(currentReaderTypeName()),
    onTap: () async {
      await choosePagerType(context);
      setState(() {});
    },
  );
}

Widget _twoPageDirectionTile(
  BuildContext context,
  void Function(void Function()) setState,
) {
  return ListTile(
    title: Text(tr("settings.reader_type.two_page_direction")),
    subtitle: Text(_twoPageDirectionName(_twoPageDirection)),
    onTap: () async {
      TwoPageDirection? t = await showDialog<TwoPageDirection>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(tr("settings.reader_type.two_page_direction_choose")),
            children: TwoPageDirection.values
                .map((e) => SimpleDialogOption(
                      child: Text(_twoPageDirectionName(e)),
                      onPressed: () {
                        Navigator.of(context).pop(e);
                      },
                    ))
                .toList(),
          );
        },
      );
      if (t != null) {
        await method.saveProperty(_twoPageDirectionPropertyName, t.toString());
        _twoPageDirection = t;
        setState(() {});
      }
    },
  );
}

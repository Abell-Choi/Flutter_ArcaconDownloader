import 'package:flutter/material.dart';

Widget defaultCardData(
  Icon icon,
  String strTitle,
  var pressData,
) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: icon,
          title: Text(strTitle),
        ),
        ButtonBar(
          children: [TextButton(onPressed:(){}, child: Text('asdf'))],
        )
      ],
    ),
  );
}

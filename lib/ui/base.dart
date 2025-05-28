import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget buildLayout(
  BuildContext context,
  String lottieAssets,
  double lottieHeight, {
  String text = "",
  Widget? content,
}) =>
    Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                lottieAssets,
                height: lottieHeight,
                width: double.infinity,
                fit: BoxFit.fitHeight,
              ),
              if (text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (content != null) content,
            ],
          ),
        ],
      ),
    );

Widget buildPageOrEmptyData(
  BuildContext context, {
  int size = 0,
  required NullableIndexedWidgetBuilder itemBuilder,
}) {
  if (size == 0) {
    return buildLayout(context, 'assets/lottie/no_data.json', 240,
        text: '暂无数据');
  } else {
    return ListView.builder(
      itemCount: size,
      itemBuilder: itemBuilder,
    );
  }
}

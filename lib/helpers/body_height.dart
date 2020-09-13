import 'package:flutter/material.dart';

double bodyHeightWithAppBar(BuildContext context) {
  var media = MediaQuery.of(context);
  return media.size.height - (media.padding.top + kToolbarHeight);
}

double bodyHeightWithOutAppBar(BuildContext context) {
  var media = MediaQuery.of(context);
  return media.size.height - media.padding.top;
}

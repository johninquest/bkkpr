import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/dialogs.dart';

class WebService {
  Future<void> openUrl(String _url, context) async {
    // if (!await launch(_url)) throw 'Could not launch $_url';
    if (!await launch(_url))
      showDialog(
          context: context,
          builder: (_) => ErrorDialog('Could not launch $_url'));
  }
}

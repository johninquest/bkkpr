import 'package:flutter/material.dart';

class SnackBarMessage {
  saveSuccess(context) {
    var message = ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Saved successfully \u{2713}')));
    return message;
  }

    saveFail(context) {
    var message = ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('An error occured!')));
    return message;
  }

  addSuccess(context) {
    var message = ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Added successfully \u{2713}')));
    return message;
  }

  changeSuccess(context) {
    var message = ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Change saved successfully \u{2713}')));
    return message;
  }

  deleteSuccess(context) {
    var message = ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Deleted successfully \u{2713}')));
    return message;
  }
}

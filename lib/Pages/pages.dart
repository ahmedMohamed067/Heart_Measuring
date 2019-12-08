library pages;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:flutter/material.dart';

export 'Home/home.dart';
export 'Request/request.dart';
export 'Doctors/places.dart';
export 'Doctors/doctors.dart';
export 'Doctors/clinics.dart';

Future push(BuildContext context, Widget page,
    {bool initial = false, bool fullScreenDialog = false}) async {
  Route route = new CupertinoPageRoute(
      fullscreenDialog: (fullScreenDialog || initial),
      builder: (context) => page);

  if (initial) {
    await Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
  } else {
    await Navigator.of(context).push(route);
  }
}

pop(BuildContext context) {
  Navigator.of(context).pop();
}

Future pushAndReplace(BuildContext context, Widget page,
    {bool fullScreenDialog = false}) async {
  await Navigator.pushReplacement(
    context,
    CupertinoPageRoute(
      builder: (context) => page,
      fullscreenDialog: fullScreenDialog,
    ),
  );
}

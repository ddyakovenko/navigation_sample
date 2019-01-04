import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../../config/application.dart';

class HomeComponent extends StatefulWidget {
  @override
  State createState() => new HomeComponentState();
}

class HomeComponentState extends State<HomeComponent> {
  final _daysOfWeek = const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  Widget build(BuildContext context) {
    var menuWidgets = <Widget>[
      menuButton(context, "Native Animation", "native"),
      menuButton(context, "Preset (In from Left)", "preset-from-left"),
      menuButton(context, "Preset (Fade In)", "preset-fade"),
      menuButton(context, "Custom Transition", "custom"),
      menuButton(context, "Navigator Result", "pop-result"),
      menuButton(context, "Function Call", "function-call"),
    ];

    return new Material(
      color: const Color(0xFF00D6F7),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: menuWidgets,
      ),
    );
  }

  // helpers
  Widget menuButton(BuildContext context, String title, String key) {
    return new Padding(
      padding: new EdgeInsets.all(4.0),
      child: new ConstrainedBox(
        constraints: new BoxConstraints(minHeight: 42.0),
        child: new FlatButton(
          highlightColor: const Color(0x11FFFFFF),
          splashColor: const Color(0x22FFFFFF),
          child: new Text(
            title,
            style: new TextStyle(
              color: const Color(0xAA001133),
            ),
          ),
          onPressed: () {
            tappedMenuButton(context, key);
          },
        ),
      ),
    );
  }

  // actions
  void tappedMenuButton(BuildContext context, String key) {
    String message = "";
    String hexCode = "#FFFFFF";
    String result;
    TransitionType transitionType = TransitionType.native;
    if (key != "custom" && key != "function-call") {
      if (key == "native") {
        hexCode = "#F76F00";
        message =
            "This screen should have appeared using the default flutter animation for the current OS";
      } else if (key == "preset-from-left") {
        hexCode = "#5BF700";
        message =
            "This screen should have appeared with a slide in from left transition";
        transitionType = TransitionType.inFromLeft;
      } else if (key == "preset-fade") {
        hexCode = "#F700D2";
        message = "This screen should have appeared with a fade in transition";
        transitionType = TransitionType.fadeIn;
      } else if (key == "pop-result") {
        transitionType = TransitionType.native;
        hexCode = "#7d41f4";
        message =
            "When you close this screen you should see the current day of the week";
        result = "Today is ${_daysOfWeek[new DateTime.now().weekday - 1]}!";
      }

      String route = "/demo?message=$message&color_hex=$hexCode";

      if (result != null) {
        route = "$route&result=$result";
      }

      Application.router
          .navigateTo(context, route, transition: transitionType)
          .then((result) {
        if (key == "pop-result") {
          Application.router.navigateTo(context, "/demo/func?message=$result");
        }
      });
    } else if (key == "custom") {
      hexCode = "#DFF700";
      message =
          "This screen should have appeared with a crazy custom transition";
      var transition = (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return new ScaleTransition(
          scale: animation,
          child: new RotationTransition(
            turns: animation,
            child: child,
          ),
        );
      };
      Application.router.navigateTo(
        context,
        "/demo?message=$message&color_hex=$hexCode",
        transition: TransitionType.custom,
        transitionBuilder: transition,
        transitionDuration: const Duration(milliseconds: 600),
      );
    } else {
      message = "You tapped the function button!";
      Application.router.navigateTo(context, "/demo/func?message=$message");
    }
  }
}

import 'dart:io';
import 'dart:ui';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class AppData {
  static final AppData _appData = new AppData._internal();

  bool isDonator;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();//appData.isDonator

const kColorPrimary = Color(0xff283149);
const kColorPrimaryLight = Color(0xff424B67);
const kColorPrimaryDark = Color(0xff21293E);
const kColorAccent = Colors.blue;
const kColorText = Color(0xffDBEDF3);

Flushbar flush;

var kWelcomeAlertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  animationDuration: Duration(milliseconds: 450),
  backgroundColor: kColorPrimaryLight,
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  titleStyle: TextStyle(
    color: kColorText,
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
    letterSpacing: 1.5,
  ),
);

TextStyle kSendButtonTextStyle = TextStyle(
  color: kColorText,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

TextStyle kSendButtonTextStyleSecondary = TextStyle(
  color: kColorText,
  fontSize: 15,
);

class TopBarAgnosticNoIcon extends StatelessWidget {
  final String text;

  final TextStyle style;
  final String uniqueHeroTag;
  final Widget child;

  TopBarAgnosticNoIcon({
    this.text,
    this.style,
    this.uniqueHeroTag,
    this.child,
  });

  BuildContext context2;

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      context2 = context;
      return Scaffold(
        backgroundColor: kColorPrimary,
        bottomNavigationBar: new FlatButton(
          onPressed: () {
            /// Other Applications Option
            openHomeFlushBar();
          },
          color: Colors.transparent,
          child: new Text(
            "Check out the rest of our apps",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: kColorText, //change your color here
          ),
          backgroundColor: kColorPrimaryLight,
          title: Text(
            text,
            style: style,
          ),
        ),
        body: child,
      );
    } else {
      context2 = context;
      return CupertinoPageScaffold(
        backgroundColor: kColorPrimary,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: kColorPrimaryLight,
          heroTag: uniqueHeroTag,
          transitionBetweenRoutes: false,
          middle: Text(
            text,
            style: style,
          ),
        ),
        child: child,
      );
    }
  }

  /// Other Applications Option
  void openHomeFlushBar() {
    flush = new Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      padding: EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 12.0),
      margin: EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 20.0),
      borderRadius: 25,
      duration: Duration(seconds: 5),
      backgroundGradient: LinearGradient(
        colors: [Color(0xff717ba8), Color(0xff8189b1)],
        stops: [0.6, 1],
      ),
      icon: new Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
        child: new SizedBox(
            height: 30,
            width: 30,
            child: new GestureDetector(
                onTap: () {
                  String _url =
                      "https://play.google.com/store/apps/details?id=com.LnY.passwordkit";
                  _launchUniversalLinkIos(_url);
                },
                child: new Image(
                    image: AssetImage('assets/password_kit_icon.png')))),
      ),
      mainButton: FlatButton(
        onPressed: () {
//          this.widget.callback();
          flush.dismiss(true);
        },
        child: new Text(
          "Dismiss",
          style: TextStyle(fontSize: 15),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(4, 4),
          blurRadius: 4,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
//        title: 'This is a floating Flushbar',
      messageText: new GestureDetector(
          onTap: () {
            String _url =
                "https://play.google.com/store/apps/details?id=com.LnY.passwordkit";
            _launchUniversalLinkIos(_url);
          },
          child: new Text(
            '   PasswordKit',
            style: TextStyle(fontSize: 20),
          )),
    )..show(context2);
  }
  Future<void> _launchUniversalLinkIos(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url);
      }
    }
  }
  /// END of: Other Applications Option

}












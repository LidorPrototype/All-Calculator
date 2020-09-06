import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;
import "package:intl/intl.dart";
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tip_calculator_flutter/upgrade.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components.dart';
import 'custom_drop_down.dart' as custom;
import 'package:tip_calculator_flutter/buttons.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


// Global Variables
final appName = "All Calculator";
final prefKey = "DEFAULT_INDEX";
final welcomeText =
    "Welcome to the $appName where you can calculate everything that you desire. \nTable of contents:";
const Color gradientStartColor = Color(0xff717ba8);
const Color gradientEndColor = Color(0xffE8CBC0);
int _currentIndex = 0;
double _leftPadding, _customHeight;

double xOffset = 0, yOffset = 0, scaleFactor = 1;
bool isDrawerOpen = false;

final appData = AppData();

void main() {
  runApp(new MaterialApp(
    home: new Main(),
    debugShowCheckedModeBanner: false,
  ));
}

class Main extends StatefulWidget {
  @override
  _Main createState() => _Main();
}
class HomePage extends StatefulWidget {

  final Function callback;
  const HomePage(this.callback);

  @override
  _HomePage createState() => _HomePage();
}
class ScientificCalculator extends StatefulWidget {

  final Function callback;
  const ScientificCalculator(this.callback);

  @override
  _ScientificCalculator createState() => _ScientificCalculator();
}
class TipCalculator extends StatefulWidget {

  final Function callback;
  const TipCalculator(this.callback);

  @override
  _TipCalculator createState() => _TipCalculator();
}
class CurrencyConverter extends StatefulWidget {

  final Function callback;
  const CurrencyConverter(this.callback);

  @override
  _CurrencyConverter createState() => _CurrencyConverter();
}

PageController pageController = PageController(
  initialPage: _currentIndex,
  keepPage: true,
);

class _Main extends State<Main> {
    HomePage homePage;
    ScientificCalculator scientificCalculator;
    TipCalculator tipCalculator;
    CurrencyConverter currencyConverter;

    double h,w;

    @override
    void initState() {
        super.initState();
        initPlatformState();
        homePage = HomePage(this.callback);
        scientificCalculator = ScientificCalculator(this.callback);
        tipCalculator = TipCalculator(this.callback);
        currencyConverter = CurrencyConverter(this.callback);
    }

    // Callback function from other classes
    void callback() {
        setState(() {
        doAnimation();
        });
    }

    Future<void> initPlatformState() async {
        /// Sensitive data, not uploaded
    }

    // Drawer page animation in and out
    void doAnimation(){
        if(isDrawerOpen){
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
        isDrawerOpen = false;
        }else{
        xOffset = w;
        yOffset = h;
        scaleFactor = 0.7;
        isDrawerOpen = true;
        }
    }
    
    @override
    Widget build(BuildContext context) {
        _leftPadding = ResponsiveScreen().widthMediaQuery(context, 10);
        _customHeight = ResponsiveScreen().widthMediaQuery(context, 15);
        h = MediaQuery.of(context).size.height / 5.5;
        w =  MediaQuery.of(context).size.width / 2;
        SystemChrome.setEnabledSystemUIOverlays([]);
        return Container(
        child: Stack(
            children: <Widget>[
            donationsDrawer(),
            buildMain(),
            ],
        ),
        );
    }

    Widget donationsDrawer(){
        return UpgradeScreen();
    }

    Widget buildMain(){
        return AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
            duration: Duration(milliseconds: 750),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isDrawerOpen ? 40 : 0),
                bottomLeft: Radius.circular(isDrawerOpen ? 40 : 0),
                ),
                gradient: LinearGradient(
                colors: [gradientStartColor, gradientEndColor],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                )
            ),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                bottomNavigationBar: CurvedNavigationBar(
                animationCurve: Curves.easeInOut,
                height: 50,
                index: _currentIndex,
                // [0, 1, 2, . . ., n]
                color: Colors.white,
                // over all background color
                backgroundColor: Colors.transparent,
                // icon outside drop background color
                buttonBackgroundColor: Colors.white,
                // icon inside drop background color
                items: <Widget>[
                    new Icon(
                    Icons.home,
                    size: 35,
                    ),
                    new Icon(
                    const IconData(0xe900, fontFamily: 'Calculator'),
                    size: 35,
                    ),
                    new Icon(
                    const IconData(0xe900, fontFamily: 'Tip'),
                    size: 35,
                    ),
                    new Icon(
                    const IconData(0xe900, fontFamily: 'CurrencyConverter'),
                    size: 35,
                    ),
                ],
                onTap: (index) {
                    setState(() {
                    bottomTapped(index);
                    });
                },
                ),
                body: buildPageView(),
            ),
            ),
        );
    }

    Widget buildPageView() {
        return new PageView(
        controller: pageController,
        onPageChanged: (index) {
            pageChanged(index);
        },
        children: <Widget>[
            HomePage(this.callback),
            ScientificCalculator(this.callback),
            TipCalculator(this.callback),
            CurrencyConverter(this.callback),
        ],
        );
    }

    void bottomTapped(int index) {
        setState(() {
        _currentIndex = index;
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
        });
    }

    void pageChanged(int index) {
        setState(() {
        _currentIndex = index;
        });
    }

}

class _HomePage extends State<HomePage> {
    final textControllerIndex = TextEditingController();
    AnimationController containerAnimationController;
    double scaleFactor = 2;
    
    @override
    void initState() {
        super.initState();
        containerAnimationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
        );
        containerAnimationController.forward();
        containerAnimationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
            containerAnimationController.reverse();
        }
        if(status == AnimationStatus.dismissed){
            containerAnimationController.forward();
        }
        });
    }

    @override
    void dispose() {
        containerAnimationController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
            onTap: (){
            this.widget.callback();
            },
            child: new AutoSizeText(
            '($appName)',
            style: TextStyle(fontSize: 100, fontFamily: 'RioGrande', color: Colors.black87),
            maxLines: 1,
            ),
        ),
        ),
        body: new Container(
        child: new Column(
            children: <Widget>[
            new SizedBox(
                height: 20,
            ), //Spacing
            new Padding(
                padding: EdgeInsets.fromLTRB(_leftPadding, 2.0, 15.0, 2.0),
                child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    new Text(
                    "$welcomeText",
                    style: TextStyle(fontSize: 25, fontFamily: 'Skia'),
                    ),
                ],
                ),
            ), // Texts
            new SizedBox(
                height: 20,
            ), // Spacing
            new Padding(
                padding: EdgeInsets.fromLTRB(_leftPadding, 0.0, 0.0, 0.0),
                child: new Align(
                alignment: Alignment.centerLeft,
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    new AutoSizeText(
                        '1) Home Page',
                        style: TextStyle(fontSize: 25, fontFamily: 'Skia'),
                        maxLines: 1,
                    ),
                    new SizedBox(
                        height: 15,
                    ),
                    new AutoSizeText(
                        '2) Scientific Calculator',
                        style: TextStyle(fontSize: 25, fontFamily: 'Skia'),
                        maxLines: 1,
                    ),
                    new SizedBox(
                        height: 15,
                    ),
                    new AutoSizeText(
                        '3) Tip Calculatorr',
                        style: TextStyle(fontSize: 25, fontFamily: 'Skia'),
                        maxLines: 1,
                    ),
                    new SizedBox(
                        height: 15,
                    ),
                    new AutoSizeText(
                        '4) Currency Converter',
                        style: TextStyle(fontSize: 25, fontFamily: 'Skia'),
                        maxLines: 1,
                    ),
                    ],
                ),
                ),
            ), // Options
            Expanded(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: new FlatButton(
                    onPressed: () {
                        this.widget.callback();
                    },
                    color: Colors.transparent,
                    child: !isDrawerOpen ?
                            Text(
                              'Want to make a donation?',
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            )
                          : AnimatedBuilder(
                              animation: containerAnimationController.view,
                              builder: (context, child){
                                return Transform.scale(
                                  scale: containerAnimationController.value * 2,
                                  child: child,
                                );
                              },
                              child: Text(
                                  'Get Back Here!',
                                  style: TextStyle(color: Colors.black, fontSize: 15),
                                ),
                            ),
                    ),
                ),
                ),
            ),
            ],
        ),
        ),
    );
    }

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
    )..show(context);
    }

    // Open links and outside applications
    Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
        await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
        );
    } else {
        throw 'Could not launch $url';
    }
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

    Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
        await launch(url);
    } else {
        throw 'Could not launch $url';
    }
    }

}

class _ScientificCalculator extends State<ScientificCalculator> {
    var userQuestion = '';
    var userAnswer = '';

    final List<String> buttons = [
        'tan', 'sin', 'cos', '(', ')', 'arctan', 'arcsin', 'arccos', 'π', 'e', '%',
        '^', '√', 'ln', 'log', '7', '8', '9', 'C', 'DEL', '4', '5', '6', '/', 'x',
        '1', '2', '3', '+', '-', '0', '.', ',', 'Ans', '='
    ];

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
            title: new Text("Scientific Calculator",
                style: TextStyle(fontSize: 25, color: Colors.black)),
            backgroundColor: Colors.transparent,
            leading: isDrawerOpen ? IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
                this.widget.callback();
            },
            ):IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){
                this.widget.callback();
            },
            ),
        ),
        body: new SizedBox.expand(
            child: new Container(
            child: new Center(
                child: new Column(
                children: <Widget>[
                    new Expanded(
                    child: new Container(
                        color: Colors.transparent,
                        child: new SingleChildScrollView(
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                            new SizedBox(
                                height: _customHeight,
                            ),
                            new Container(
                                padding: EdgeInsets.all(_leftPadding),
                                alignment: Alignment.centerLeft,
                                child: Text(userQuestion,
                                    style: TextStyle(fontSize: 30))
                            ),
                            new Container(
                                padding: EdgeInsets.all(_leftPadding),
                                alignment: Alignment.centerRight,
                                child: Text(userAnswer,
                                    style: TextStyle(fontSize: 40))
                            ),
                            ],
                        ),
                        ),
                    ),
                    ),
                    new Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: new Container(
                        color: Colors.transparent,
                        child: new Center(
                        child: GridView.builder(
                            itemCount: buttons.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: MediaQuery.of(context)
                                    .size
                                    .width /
                                    (MediaQuery.of(context).size.height / 2.5)
                            ),
                            itemBuilder: (BuildContext context, int index) {
                                if (buttons[index] == 'C') {
                                // Clear Button
                                return new MyButton(
                                    buttonTapped: () {
                                    setState(() {
                                        userQuestion = '';
                                    });
                                    },
                                    buttonText: buttons[index],
                                    color: Colors.green,
                                    textColor: Colors.white,
                                );
                                } else if (buttons[index] == 'DEL') {
                                // Delete Button
                                return new MyButton(
                                    buttonTapped: () {
                                    setState(() {
                                        userQuestion = userQuestion.substring(
                                            0, userQuestion.length - 1);
                                    });
                                    },
                                    buttonText: buttons[index],
                                    color: Colors.red,
                                    textColor: Colors.white,
                                );
                                } else if (buttons[index] == '=') {
                                // Equal Button
                                return new MyButton(
                                    buttonTapped: () {
                                    setState(() {
                                        equalPressed();
                                    });
                                    },
                                    buttonText: buttons[index],
                                    color: Colors.deepPurple,
                                    textColor: Colors.white,
                                );
                                } else {
                                return new MyButton(
                                    // Rest of the Buttons
                                    buttonTapped: () {
                                    setState(() {
                                        if (buttons[index] == "log") {
                                        userQuestion += "log(10,";
                                        } else {
                                        userQuestion += buttons[index];
                                        }
                                    });
                                    },
                                    buttonText: buttons[index],
                                    color: isOperator(buttons[index])
                                        ? Colors.deepPurple
                                        : Colors.deepPurple[50],
                                    textColor: isOperator(buttons[index])
                                        ? Colors.white
                                        : Colors.deepPurple,
                                );
                                }
                            }),
                        ),
                    ),
                    ),
                    new SizedBox(
                    height: (_customHeight - 5),
                    ),
                ],
                ),
            ),
            ),
        ),
        );

    }

    void equalPressed() {
        String finalQuestion = userQuestion;
        finalQuestion = finalQuestion.replaceAll('Ans', userAnswer.toString());
        finalQuestion = finalQuestion.replaceAll('x', '*');
        finalQuestion = finalQuestion.replaceAll('√', 'sqrt');
        finalQuestion = finalQuestion.replaceAll('π', math.pi.toString());
        finalQuestion = finalQuestion.replaceAll('e', math.e.toString());
        Parser p = Parser();
        Expression exp = p.parse(finalQuestion);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        userAnswer = eval.toString();
    }

    bool isOperator(String x) {
        if (x == "%" ||
            x == "/" ||
            x == "x" ||
            x == "-" ||
            x == "+" ||
            x == "=" ||
            x == "tan" ||
            x == "cos" ||
            x == "sin" ||
            x == "^" ||
            x == "(" ||
            x == ")" ||
            x == "√" ||
            x == "arctan" ||
            x == "arcsin" ||
            x == "arccos" ||
            x == "ln" ||
            x == "log" ||
            x == "π" ||
            x == "e") {
        return true;
        } else {
        return false;
        }
    }
}

class _TipCalculator extends State<TipCalculator> with TickerProviderStateMixin {
    final textControllerBill = TextEditingController();
    final textControllerPercentage = TextEditingController();
    final textControllerNumOfPpl = TextEditingController();
    String tip = "", bill = "", perPerson = "";
    String roundValue = 'Round Up';
    final roundAnswers = ['Round Up', 'Don\'t Round Up'];
    String currency = "\$";
    final currencies = ['\$', '€', '₪', '₣', '¥', 'kr', 'р.', '฿'];

    //                   [dollars,Euro,New Israeli Shekel,Swiss Franc,China Yuan / Yen,Danish Krone,Russian Ruble,Baht];
    final outputsEmpty = [" ", " ", " "];
    final outputsFull = ["Bill: ", "Tip: ", "Per Person: "];
    int nomOfPeople = 1, addPeople = 1, subtractPeople = -1;
    double _scale_1, _scale_2;

    AnimationController _controllerBounceBtn_1, _controllerBounceBtn_2;

    @override
    void initState() {
        _controllerBounceBtn_1 = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150),
        lowerBound: 0.0,
        upperBound: 1.5,
        )..addListener(() {
            setState(() {});
        });
        _controllerBounceBtn_2 = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150),
        lowerBound: 0.0,
        upperBound: 1.5,
        )..addListener(() {
            setState(() {});
        });
        super.initState();
    }

    @override
    void dispose() {
        // Clean up the controller when the widget is disposed.
        textControllerBill.dispose();
        textControllerPercentage.dispose();
        textControllerNumOfPpl.dispose();
        _controllerBounceBtn_1.dispose();
        _controllerBounceBtn_2.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        try {
        _scale_1 = 1 - _controllerBounceBtn_1.value;
        _scale_2 = 1 - _controllerBounceBtn_2.value;
        } on Exception catch (e) {
        _scale_1 = 1;
        _scale_2 = 1;
        }
        return new Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
            title: new Text("Tip Calculator",
                style: TextStyle(fontSize: 25, color: Colors.black)),
            backgroundColor: Colors.transparent,
            leading: isDrawerOpen ? IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
                this.widget.callback();
            },
            ):IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){
                this.widget.callback();
            },
            ),
        ),
        body: new Container(
            alignment: Alignment.topCenter,
            child: new SingleChildScrollView(
            child: new Column(
                children: <Widget>[
                new SizedBox(
                    height: _customHeight + 5,
                ),
                new Container(
                    child: new SizedBox(
                    width: 250,
                    child: new Row(
                        children: <Widget>[
                        new Expanded(
                            child: new TextFormField(
                            controller: textControllerBill,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                labelText: 'Bill Amount',
                                labelStyle: new TextStyle(color: Colors.black45),
                                enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                ),
                            ),
                            style: new TextStyle(fontSize: 20),
                            onChanged: (String newValue) {
                                setState(() {
                                calculateTip();
                                });
                            },
                            ),
                        ),
                        ],
                    ),
                    ),
                ), // Bill Amount
                new SizedBox(
                    height: 15,
                ),
                new Container(
                    child: new SizedBox(
                    width: 250,
                    child: new Row(
                        children: <Widget>[
                        new Expanded(
                            child: new TextFormField(
                            controller: textControllerPercentage,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                labelText: 'Tip Percent (%)',
                                labelStyle: new TextStyle(color: Colors.black45),
                                enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                ),
                            ),
                            style: new TextStyle(fontSize: 20),
                            onChanged: (String newValue) {
                                setState(() {
                                calculateTip();
                                });
                            },
                            ),
                        ),
                        ],
                    ),
                    ),
                ), // Tip Percent
                new SizedBox(
                    height: 15,
                ),
                new Container(
                    child: new SizedBox(
                    width: 250,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        new DropdownButton<String>(
                            value: roundValue,
                            elevation: 16,
                            style: TextStyle(color: Colors.black54, fontSize: 20),
                            underline: Container(
                            height: 2,
                            color: Colors.black54,
                            ),
                            onChanged: (String newValue) {
                            setState(() {
                                roundValue = newValue;
                                calculateTip();
                            });
                            },
                            items: roundAnswers
                                .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                            );
                            }).toList(),
                        ), // Round Up
                        new DropdownButton<String>(
                            value: currency,
                            elevation: 16,
                            style: TextStyle(color: Colors.black54, fontSize: 23),
                            underline: Container(
                            height: 2,
                            color: Colors.black54,
                            ),
                            onChanged: (String newValue) {
                            setState(() {
                                currency = newValue;
                                calculateTip();
                            });
                            },
                            items: currencies
                                .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                            );
                            }).toList(),
                        ), // Currency
                        ],
                    ),
                    ),
                ), // Round Up + Currency
                new SizedBox(
                    height: 15,
                ),
                new Container(
                    decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: new SizedBox(
                    height: 100,
                    width: 200,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        new SizedBox(
                            height: 50,
                            width: 50,
                            child: new GestureDetector(
                            onTapDown: _onTapDown2,
                            onTapUp: _onTapUp2,
                            onTap: () {
                                setState(() {
                                changeNoOfPeople(subtractPeople);
                                calculateTip();
                                });
                            },
                            child: Transform.scale(
                                scale: _scale_2,
                                child: _animatedButtonUiMinus,
                            ),
                            ),
                        ), // Btn Minus People
                        new SizedBox(
                            width: 50,
                            child: new Center(
                                child: new Text(
                                "$nomOfPeople",
                                style: TextStyle(fontSize: 40, fontFamily: "Skia"),
                            ))),
                        new SizedBox(
                            height: 50,
                            width: 50,
                            child: new GestureDetector(
                            onTapDown: _onTapDown1,
                            onTapUp: _onTapUp1,
                            onTap: () {
                                setState(() {
                                changeNoOfPeople(addPeople);
                                calculateTip();
                                });
                            },
                            child: Transform.scale(
                                scale: _scale_1,
                                child: _animatedButtonUiPlus,
                            ),
                            ),
                        ), // Btn Plus People
                        ],
                    ),
                    ),
                ), // No. of People
                new SizedBox(
                    height: 15,
                ),
                new Container(
                    child: new SizedBox(
                    width: 250,
                    child: new Center(
                        child: new Column(
                        children: <Widget>[
                            new SizedBox(
                            height: 30,
                            ),
                            new Column(
                            children: <Widget>[
                                new Row(
                                children: <Widget>[
                                    new Align(
                                    alignment: Alignment.centerLeft,
                                    child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                        new Text(outputsEmpty[0],
                                            style: TextStyle(fontSize: 25)),
                                        new Text(outputsEmpty[1],
                                            style: TextStyle(fontSize: 25)),
                                        new Text(outputsEmpty[2],
                                            style: TextStyle(fontSize: 25)),
                                        ],
                                    ),
                                    ),
                                    new Expanded(
                                    child: new Align(
                                        alignment: Alignment.centerLeft,
                                        child: new SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                            new Text('  $bill',
                                                style: TextStyle(fontSize: 25)),
                                            new Text('  $tip',
                                                style: TextStyle(fontSize: 25)),
                                            new Text('  $perPerson',
                                                style: TextStyle(fontSize: 25)),
                                            ],
                                        ),
                                        ),
                                    ),
                                    ),
                                ],
                                ),
                            ],
                            ),
                        ],
                        ),
                    ),
                    ),
                ), // OutPutTexts
                ],
            ),
            ),
        ),
        );
    }

    void changeNoOfPeople(int value) {
        if (nomOfPeople == 1 && value == subtractPeople) {
        flush = new Flushbar(
            flushbarPosition: FlushbarPosition.BOTTOM,
            padding: EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 12.0),
            margin: EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 20.0),
            borderRadius: 25,
            duration: Duration(seconds: 5),
            backgroundGradient: LinearGradient(
            colors: [Color(0xff717ba8), Color(0xffa0a6c5)],
            stops: [0.4, 1],
            ),
            icon: Icon(
            Icons.clear,
            size: 30,
            ),
            mainButton: FlatButton(
            onPressed: () {
                setState(() {
                changeNoOfPeople(addPeople);
                calculateTip();
                });
                flush.dismiss(true);
            },
            child: new Text(
                "I meant\nadd one",
                style: TextStyle(fontSize: 15),
            ),
            ),
            boxShadows: [
            BoxShadow(
                color: Colors.black45,
                offset: Offset(3, 3),
                blurRadius: 3,
            ),
            ],
            dismissDirection: FlushbarDismissDirection.HORIZONTAL,
            // The default curve is Curves.easeOut
            forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    //        title: 'This is a floating Flushbar',
            messageText: new Text(
            'You can\'t have less than 1 people',
            style: TextStyle(fontSize: 20),
            ),
        )..show(context);
        } else {
        nomOfPeople += value;
        }
    }

    void calculateTip() {
        try {
        var f = new NumberFormat("###.0##", "en_US");
        double amount = double.parse(textControllerBill.text);
        int percentage = int.parse(textControllerPercentage.text);
        double _tip = (amount * (percentage / 100));
        double _bill = (amount + _tip);
        bill = (f.format(_bill) + " " + currency);
        tip = (f.format(_tip) + " " + currency);
        if (roundValue == roundAnswers[0]) {
            perPerson = ((_bill / nomOfPeople).ceil().toString() + " " + currency);
        } else if (roundValue == roundAnswers[1]) {
            perPerson = (f.format(_bill / nomOfPeople) + " " + currency);
        }
        outputsEmpty[0] = outputsFull[0];
        outputsEmpty[1] = outputsFull[1];
        outputsEmpty[2] = outputsFull[2];
        } on Exception catch (e) {
        // in order to delete all when there is no input of some kind
        outputsEmpty[0] = " ";
        outputsEmpty[1] = " ";
        outputsEmpty[2] = " ";
        bill = "";
        tip = "";
        perPerson = "";
        return;
        }
    }

    Widget get _animatedButtonUiMinus => Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                boxShadow: [
                BoxShadow(
                    color: Color(0x80000000),
                    blurRadius: 30.0,
                    offset: Offset(0.0, 5.0),
                ),
                ],
                gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                    Color(0xff57608e),
                    gradientEndColor,
                ],
                )),
            child: Center(
            child: Text(
                '-',
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
            ),
            ),
        );

    Widget get _animatedButtonUiPlus => Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                boxShadow: [
                BoxShadow(
                    color: Color(0x80000000),
                    blurRadius: 30.0,
                    offset: Offset(0.0, 5.0),
                ),
                ],
                gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                    Color(0xff57608e),
                    gradientEndColor,
                ],
                )),
            child: Center(
            child: Text(
                '+',
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
            ),
            ),
        );

    void _onTapDown1(TapDownDetails details) {
        _controllerBounceBtn_1.forward();
    }

    void _onTapUp1(TapUpDetails details) {
        _controllerBounceBtn_1.reverse();
    }

    void _onTapDown2(TapDownDetails details) {
        _controllerBounceBtn_2.forward();
    }

    void _onTapUp2(TapUpDetails details) {
        _controllerBounceBtn_2.reverse();
    }
}

/// Donation feature only, none donators cant access this one
class _CurrencyConverter extends State<CurrencyConverter> {
    var fromTextController;
    List<String> currencies;
    List<String> listAllCurrencies = [
        "CAD", "HKD", "ISK", "PHP", "DKK", "HUF", "CZK", "AUD", "RON", "SEK", "IDR",
        "INR", "BRL", "RUB", "HRK", "JPY", "THB", "CHF", "SGD", "PLN", "BGN", "TRY",
        "CNY", "NOK", "NZD", "ZAR", "USD", "MXN", "ILS", "GBP", "KRW", "MYR", "EUR"
    ];
    List<String> currenciesSymbols = [
        "C\$", "HK\$", "kr", "₱", "Kr.", "Ft", "Kč", "A\$", "lei", "kr", "Rp", "₹",
        "R\$", "₽", "kn", "¥", "฿", "CHf", "S\$", "zł", "Лв.", "₺", "¥", "kr", "\$",
        "R", "\$", "Mex\$", "₪", "£", "₩", "RM", "‎€"
    ];
    String fromCurrency = "USD";
    String toCurrency = "EUR";
    String currencySymbol = "‎€";
    String result;

    @override
    void initState() {
        super.initState();
        fromTextController = TextEditingController(text: "1");
        _loadCurrencies();
        _doConversion();
    }

    int x = 0;

    @override
    Widget build(BuildContext context) {
        if (appData.isDonator) {    // check if the user has ever made a donation
        return new Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
            title: new Text("Currency Converter",
                style: TextStyle(fontSize: 25, color: Colors.black)),
            backgroundColor: Colors.transparent,
            leading: isDrawerOpen ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                this.widget.callback();
                },
            ):IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                this.widget.callback();
                },
            ),
            ),
            body: currencies == null
                ? new Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    new Text(
                        "Waiting to establish a stable internet connection..."),
                    new SizedBox(
                        height: 50,
                    ),
                    new CircularProgressIndicator(),
                    ],
                ))
                : new SingleChildScrollView(
                child: new Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: new Padding(
                        padding: EdgeInsets.all(_leftPadding - 2),
                        child: new Card(
                        elevation: 3.0,
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                            new ListTile(
                                title: new TextField(
                                autofocus: false,
                                controller: fromTextController,
                                style:
                                    TextStyle(fontSize: 25.0, color: Colors.black),
                                keyboardType:
                                    TextInputType.numberWithOptions(decimal: true),
                                onChanged: (text) {
                                    _doConversion();
                                },
                                ),
                                trailing: _buildDropDownButtonFrom(fromCurrency),
                            ),
                            new IconButton(
                                icon: new Icon(
                                Icons.arrow_downward,
                                size: 40,
                                ),
                                onPressed: _doConversion,
                            ),
                            new ListTile(
                                title: new Center(
                                child: new SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: result != null
                                        ? new Wrap(
                                            children: <Widget>[
                                            new Container(
                                                padding: const EdgeInsets.fromLTRB(
                                                    5.0, 5.0, 5.0, 5.0),
                                                decoration: BoxDecoration(
                                                color: Color(0xffDBDBDB),
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                ),
                                                child: new Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    3.0, 0.5, 3.0, 0.5),
                                                child: new Wrap(
                                                    alignment: WrapAlignment.center,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment.center,
                                                    runSpacing: 10,
                                                    children: <Widget>[
                                                    new Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                1.0)),
                                                    new Text(
                                                        currency(
                                                            result, toCurrency),
                                                        style: new TextStyle(
                                                            fontSize: 25)),
                                                    new Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                5.0)),
                                                    new Padding(
                                                        padding:
                                                            const EdgeInsets.all(1.0),
                                                        child: new ClipOval(
                                                        child: new Text(
                                                            " " +
                                                                currencySymbol +
                                                                " ",
                                                            style: TextStyle(
                                                            fontSize: 30,
                                                            color: Colors.black,
                                                            backgroundColor:
                                                                Colors.black26,
                                                            ),
                                                        ),
                                                        ),
                                                    ),
                                                    new Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                1.0)),
                                                    ],
                                                ),
                                                ),
                                            )
                                            ],
                                        )
                                        : new Text("0.0",
                                            style: new TextStyle(fontSize: 30)
                                        ),
                                ),
                                ),
                                trailing: _buildDropDownButtonTo(toCurrency),
                            ),
                            ],
                        ),
                        ),
                    ),
                    ),
                ),
        );
        }else {
        return new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
            title: new Text("Currency Converter",
                style: TextStyle(fontSize: 25, color: Colors.black)),
            backgroundColor: Colors.transparent,
            leading: isDrawerOpen ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                this.widget.callback();
                },
            ):IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                this.widget.callback();
                },
            ),
            ),
            body: new Container(
            child: new Center(
                child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new AutoSizeText(
                        "Donation are unavailable on this device,\nwe are terribly sorry for inconvenience",
                        maxLines: 4,
                        style: new TextStyle(fontSize: 100),
                    ),
                    )
                ],
                ),
            ),
            ),
        );
        }
    }

    Future<String> _loadCurrencies() async {
        String uri = "http://api.openrates.io/latest";
        var response = await http
            .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
        var responseBody = json.decode(response.body);
        Map curMap = responseBody['rates'];
        currencies = curMap.keys.toList();
        currencies.add("EUR");
        setState(() {});
        print(currencies);
        return "Success";
    }

    Future<String> _doConversion() async {
        String uri =
            "http://api.openrates.io/latest?base=$fromCurrency&symbols=$toCurrency";
        var response = await http
            .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
        var responseBody = json.decode(response.body);
        setState(() {
        if (fromCurrency == toCurrency) {
            result = (double.parse(fromTextController.text)).toString();
        } else {
            result = (double.parse(fromTextController.text) *
                    (responseBody["rates"][toCurrency]))
                .toString();
        }
        });
        print(result);
        return "Success";
    }

    _onFromChanged(String value) {
        setState(() {
        fromCurrency = value;
        });
    }

    _onToChanged(String value) {
        setState(() {
        toCurrency = value;
        });
    }

    Widget _buildDropDownButtonFrom(String currencyCategory) {
        return custom.DropdownButton(
        height: 600,
        value: currencyCategory,
        items: currencies
            .map((String value) => new custom.DropdownMenuItem(
                    key: new UniqueKey(),
                    value: value,
                    child: new Row(
                    children: <Widget>[
                        new Text(
                        value,
                        style: new TextStyle(fontSize: 25),
                        ),
                    ],
                    ),
                ))
            .toList(),
        onChanged: (String value) {
            if (currencyCategory == fromCurrency) {
            _onFromChanged(value);
            _doConversion();
            } else {
            _onToChanged(value);
            _doConversion();
            }
        },
        );
    }

    Widget _buildDropDownButtonTo(String currencyCategory) {
        return custom.DropdownButton(
        height: 600,
        value: currencyCategory,
        items: currencies
            .map((String value) => new custom.DropdownMenuItem(
                    key: new UniqueKey(),
                    value: value,
                    child: new Row(
                    children: <Widget>[
                        new Text(
                        value,
                        style: new TextStyle(fontSize: 25),
                        ),
                    ],
                    ),
                ))
            .toList(),
        onChanged: (String value) {
            if (currencyCategory == fromCurrency) {
            _onFromChanged(value);
            _doConversion();
            } else {
            _onToChanged(value);
            _doConversion();
            }
        },
        );
    }

    String currency(String old, String type) {
        String fresh = old;
        for (int i = 0; i < listAllCurrencies.length; i++) {
        if (type == listAllCurrencies[i]) {
            fresh += " ";
            setState(() {
            currencySymbol = currenciesSymbols[i];
            });
        }
        }
        return fresh;
    }
}

class ResponsiveScreen {
  static final ResponsiveScreen _singleton = ResponsiveScreen._internal();
  factory ResponsiveScreen() {
    return _singleton;
  }
  ResponsiveScreen._internal();
  double widthMediaQuery(BuildContext context, double width) {
    return MediaQuery.of(context).size.width * width / 375;
  }
  double heightMediaQuery(BuildContext context, double height) {
    return MediaQuery.of(context).size.height * height / 667;
  }
}
































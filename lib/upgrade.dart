/// NOTE: not all of the upgrade screen and options are uploaded, some of them are sensitive data, 
///     so this parts are not being loaded to here, tho you will see the functions name and everything, 
///     only the sensitive code and areas are being cut out.


import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'components.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

PurchaserInfo _purchaserInfo;
double donation;

class UpgradeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
    Offerings _offerings;

    @override
    void initState() {
        super.initState();
        fetchData();
    }

    Future<void> fetchData() async {
        PurchaserInfo purchaserInfo;
        try {
        purchaserInfo = await Purchases.getPurchaserInfo();
        } on PlatformException catch (e) {
        print(e);
        }

        Offerings offerings;
        try {
        offerings = await Purchases.getOfferings();
        } on PlatformException catch (e) {
        print(e);
        }
        if (!mounted) return;

        setState(() {
        _purchaserInfo = purchaserInfo;
        _offerings = offerings;
        });
    }
    
    @override
    Widget build(BuildContext context) {
        if(_purchaserInfo == null){
        fetchData();
        }
        if (_purchaserInfo == null) {
        return TopBarAgnosticNoIcon(
            text: "Upgrade Screen",
            style: kSendButtonTextStyle,
            uniqueHeroTag: 'upgrade_screen',
            child: Scaffold(
            backgroundColor: kColorPrimary,
            body: Center(
                child: Text(
                "Loading...",
                )
            )
            ),
        );
        } else {
        if (**sensitive area***) {
            **sensitive area***
        } else {
            **sensitive area***
        }

        return UpsellScreen(offerings: _offerings);

        }
    }

}

class UpsellScreen extends StatefulWidget {
    final Offerings offerings;

    UpsellScreen({Key key, @required this.offerings}) : super(key: key);

    @override
    _UpsellScreenState createState() => _UpsellScreenState();
}

class _UpsellScreenState extends State<UpsellScreen> {
    _launchURLWebsite(String zz) async {
        if (await canLaunch(zz)) {
        await launch(zz);
        } else {
        throw 'Could not launch $zz';
        }
    }

    String rateUsPrompt(){
        AppReview.getAppID.then((String onValue) {
        setState(() {
            output = onValue;
        });
        print("AppID \t" + onValue);
        });
        AppReview.requestReview.then((String onValue) {
        setState(() {
            output = onValue;
        });
        print(onValue);
        print("\n\n\n");
        });
    //    AppReview.writeReview.then((String onValue) {
    //      setState(() {
    //        output = onValue;
    //      });
    //      print(onValue);
    //    });
        return output;
    }

    @override
    Widget build(BuildContext context) {
        if (widget.offerings != null) {
            print('offerings is not null');
            print(widget.offerings.current.toString());
            print('--');
            print(widget.offerings.toString());
            final offering = widget.offerings.current;
            if (offering != null) {
            final monthly = offering.monthly;
            final annual = offering.annual;
            final lifetime = offering.lifetime;
            if (monthly != null && annual != null && lifetime != null) {
                return TopBarAgnosticNoIcon(
                text: "About Screen",
                style: kSendButtonTextStyle,
                uniqueHeroTag: 'purchase_screen',
                child: Scaffold(
                    backgroundColor: kColorPrimary,
                    body: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Container(
                            height: MediaQuery.of(context).size.height / 7.8,
                            child: **sensitive area***
                            ),
                            Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 1.0),
                            child: **sensitive area***
                            ),
                            SizedBox(
                            height: 8.0,
                            ),
                            Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: GestureDetector(
                                onTap: () {
                                _launchURLWebsite('https://yahoo.com');
                                },
                                child: Text(
                                'Term of Use',
                                style: kSendButtonTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                ),
                                ),
                            ),
                            ), 
                        ],
                        ),
                    )
                ),
                );
            }
        }
    }
        
    return TopBarAgnosticNoIcon(
      style: kSendButtonTextStyle,
      uniqueHeroTag: 'purchase_screen',
      child: Scaffold(
          backgroundColor: kColorPrimary,
          body: Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 3.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 7.8,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      appData.isDonator ? 'You\'re a Donator!' : 'You\'re a normal user',
                                      textAlign: TextAlign.center,
                                      style: kSendButtonTextStyle,
                                    ),
                                  ), // User Status
                                  SizedBox(
                                    height: 6.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Every donation is highly appriciated,\nif you wish to give a donation please\nchoose one of the donations below:\n',
                                      textAlign: TextAlign.center,
                                      style: kSendButtonTextStyleSecondary,
                                    ),
                                  ), // Appreciation Text
                                ],
                              ), // Texts
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: new SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: new GestureDetector(
                                        onTap: () {
                                                rateUsPrompt();
                                        },
                                        child: new Image(
                                            image: AssetImage('assets/rate_us.png')
                                        )
                                    )
                                ),
                              ), // Rate Us
                            ],
                          ), // Temp Instructions
                        ],
                      ),
                    ),
                  ), // Texts + Rating
                  Container(
                    margin: EdgeInsets.only(left: 14.0),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text('Donations are not available on this device and/or account.\n'
                          'we are terribly sorry for inconvenience.',
                        style: TextStyle(color: Colors.white70),),
                  ), /// No Donations Available
                  /* Restore Option, refer to the end of this file */
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: ExpansionTile(
                      title: Text(
                        "Information",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      subtitle: Text('about the developer, the app and more',
                        style: TextStyle(color: Colors.white60, fontSize: 10),
                      ),
                      children: <Widget>[
                        ExpansionTile(
                          title: Text(
                            'Developer',
                            style: kSendButtonTextStyleSecondary,
                          ),
                          children: <Widget>[
                            Card(
                              color: Color(0xff364263),
                              child: ListTile(
                                title: Text('L-ES', style: null,),
                                subtitle: Text('Lidor Eliyahu', style: null,),
                                onTap: (){
                                  _launchURLWebsite('https://github.com/LidorPrototype');
                                },
                              ),
                            ),
                          ],
                        ), // Developer
                        ExpansionTile(
                          title: Text(
                            'All-Calculator',
                            style: kSendButtonTextStyleSecondary,
                          ),
                          children: <Widget>[
                            Card(
                              color: Color(0xff364263),
                              child: ListTile(
                                title: Text('L-ES', style: null,),
                                subtitle: Text(
                                  'The All-Calculator application is a multi task calculator where you can '
                                      'calculate everything you want as shown in the main page.',
                                  style: TextStyle(color: Colors.white38, fontSize: 10),),
                              ),
                            ),
                          ],
                        ), // The Application
                        ExpansionTile(
                          title: Text(
                            'Thanks to',
                            style: kSendButtonTextStyleSecondary,
                          ),
                          children: <Widget>[
                            Container(
                              height: 100,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Card(
                                  color: Color(0xff364263),
                                  child: ListTile(
                                    title: Text('L-ES', style: null,),
                                    subtitle: Text(// Thanks to:
                                      // Dawn K
                                      'Dawn Kadmiel for the design consult and helping with the '
                                          'animations related to this page.\n'
                                      // Elior C
                                          '\nElior Cohen for his help with some of the problems we '
                                          'encountered along the way of developing this application.',
                                      style: TextStyle(color: Colors.white38, fontSize: 10),),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ), // Thanks
                      ],
                    ),
                  ), // Extra Information
                ],
              ),
            ),
          )
      ),
    );

    }

}

class PurchaseButton extends StatefulWidget {
    final Package package;

    PurchaseButton({Key key, @required this.package}) : super(key: key);

    @override
    _PurchaseButtonState createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<PurchaseButton> {
    @override
    Widget build(BuildContext context) {
        return Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
            color: kColorPrimaryLight,
            width: MediaQuery.of(context).size.width / 2.2,
            child: Column(
            children: <Widget>[
                Padding(
                padding: const EdgeInsets.all(4.0),
                child: RaisedButton(
                    textColor: kColorText,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: LinearGradient(
                            colors: <Color>[
                                Color(0xFF364263),
                                Color(0xFF485884),
                                Color(0xFF5b6ea4),
                            ],
                            ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            '${widget.package.product.title}\n${widget.package.product.priceString}',
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                        ),
                    ),
                    onPressed: () async {
                    try {
                        print('now trying to purchase');
                        _purchaserInfo = await Purchases.purchasePackage(widget.package);
                        donation = widget.package.product.price;

                        **sensitive area***

    /// Congratulation and ERROR new options:
                        **sensitive area***

                    } on PlatformException catch (e) {
                        print('----xx-----');
                        var errorCode = PurchasesErrorHelper.getErrorCode(e);
                        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
                        print("User cancelled");
                        openHomeFlushBar(appData.isDonator, "Action is cancelled");
                        } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
                        print("User not allowed to purchase");
                        openHomeFlushBar(appData.isDonator, "Not allowed to purchase");
                        }
                    }
                    return UpgradeScreen();
                    },
                ),
                ),
            ],
            ),
        ),
        );
    }

    void openHomeFlushBar(bool didHeDonate, String text) {
        flush = new Flushbar(
        flushbarPosition: didHeDonate ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        borderRadius: 30,
        duration: Duration(seconds: 3),
        backgroundGradient: LinearGradient(
            colors: [Color(0xff57608e), Color(0xff717ba8)],
            stops: [0.6, 1],
        ),
        icon: Icon(FontAwesomeIcons.donate, color: Colors.white,),
        mainButton: FlatButton(
            onPressed: () {flush.dismiss(true);},
            child: new Text(
            "Dismiss",
            style: TextStyle(fontSize: 15, color: Colors.white),
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
        messageText: Text(text, style: TextStyle(color: Colors.white),),
        )..show(context);
    }

}

class DonatorScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return TopBarAgnosticNoIcon(
        text: "Upgrade Screen",
        style: kSendButtonTextStyle,
        uniqueHeroTag: **sensitive area***,
        child: Scaffold(
            backgroundColor: kColorPrimary,
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Icon(
                            Icons.star,
                            color: kColorText,
                            size: 44.0,
                        ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: **sensitive area***
                        ),
                    ],
                ),
            )),
        );
    }
}



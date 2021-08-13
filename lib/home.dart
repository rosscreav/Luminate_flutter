import 'dart:io';

import 'package:flutter/material.dart';
import 'package:luminate_flutter/presentation/custom_icons_icons.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  bool one = true;
  bool two = false;
  bool three = false;

  String button_text = "CONNECT";

  changeOpacity(BuildContext context) {
    if(one){
    print("button pressed");
    setState(() {
      one = !one;
      button_text = "NEXT";
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        two = !two;
      });
    });
    }else if(two){
      setState(() {
        two = !two;
        button_text = "START";
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          three = !three;
        });
      });
    }
    else{
      setState(() {
        Navigator.pushNamed(context, '/timer');
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: new Column(
                children: [
                  Image.asset("assets/images/bubble_bar.png"),
                  //Top left Icon
                  Container(
                      margin: const EdgeInsets.only(top: 40.0, left: 40),
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        "assets/images/triple_dash_image.png",
                        scale: 1.8,
                      )),
                  //Hello Mary Text
                  Container(
                      margin: const EdgeInsets.only(top: 20.0, left: 40),
                      alignment: Alignment.topLeft,
                      child: Stack(children: [
                        AnimatedOpacity(
                            opacity: one ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: Text(
                              "Hello, Mary",
                              style: TextStyle(
                                  fontFamily: 'gilroy',
                                  fontSize: 40,
                                  color: const Color(0xff424242)),
                            )),
                        AnimatedOpacity(
                            opacity: two ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: Text(
                              "Success!",
                              style: TextStyle(
                                  fontFamily: 'gilroy',
                                  fontSize: 40,
                                  color: const Color(0xff424242)),
                            )),
                        AnimatedOpacity(
                            opacity: three ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: Text(
                              "Awesome!",
                              style: TextStyle(
                                  fontFamily: 'gilroy',
                                  fontSize: 40,
                                  color: const Color(0xff424242)),
                            ))
                      ])),
                  //Main Body Text
                  Container(
                      margin:
                          const EdgeInsets.only(top: 10.0, left: 40, right: 20),
                      alignment: Alignment.topLeft,
                      child: Stack(
                        children: [
                          AnimatedOpacity(
                            opacity: one ? 1.0 : 0,
                            duration: Duration(seconds: 1),
                            child: RichText(
                              text: TextSpan(
                                text:
                                    "Let's get started with your Lily therapy. Turn on the Lily device and press ",
                                style: TextStyle(
                                    fontFamily: 'sergoe_ui',
                                    fontSize: 22,
                                    color: const Color(0xff707070)),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'connect',
                                      style: TextStyle(
                                          color: const Color(0xffAA5BB0))),
                                  TextSpan(text: ' on the screen below.'),
                                ],
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: two ? 1.0 : 0,
                            duration: Duration(seconds: 1),
                            child: RichText(
                              text: TextSpan(
                                text:
                                    "Lily is now connected. You can now place the headband over your head.",
                                style: TextStyle(
                                    fontFamily: 'sergoe_ui',
                                    fontSize: 22,
                                    color: const Color(0xff707070)),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: three ? 1.0 : 0,
                            duration: Duration(seconds: 1),
                            child: RichText(
                              text: TextSpan(
                                text:
                                "When you are ready, press begin to start compression therapy.",
                                style: TextStyle(
                                    fontFamily: 'sergoe_ui',
                                    fontSize: 22,
                                    color: const Color(0xff707070)),
                              ),
                            ),
                          )
                        ],
                      )),
                  //Bluetooth Icon
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Stack(alignment: Alignment.center, children: [
                      AnimatedOpacity(
                        opacity: one ? 1.0 : 0.0,
                        duration: Duration(seconds: 1),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Lottie.asset(
                              "assets/animations/pulse.json",
                              width: 250,
                              height: 250,
                              alignment: Alignment.center,
                            ),
                            Image.asset(
                              "assets/images/bluetooth_unconnected.png",
                              scale: 2,
                              alignment: Alignment.center,
                            )
                          ],
                        ),
                      ),
                      AnimatedOpacity(
                          opacity: two ? 1.0 : 0.0,
                          duration: Duration(seconds: 1),
                          child: Image.asset(
                            "assets/images/bluetooth_connected.png",
                            alignment: Alignment.center,
                            scale: 2.5,
                          )),
                      AnimatedOpacity(
                          opacity: three ? 1.0 : 0.0,
                          duration: Duration(seconds: 1),
                          child: Image.asset(
                            "assets/images/helmet_render.png",
                            alignment: Alignment.center,
                            scale: 2.8,
                          ))
                    ]),

                  ),

                  //Button
                  Container(
                      height: 50,
                      width: 180,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffAA5BB0)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () => changeOpacity(context),
                        child: Text(
                          button_text,
                          style: const TextStyle(
                              fontFamily: "sofia",
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ))
                ],
              ))),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home, color: const Color(0xff684FA0)),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.search, color: const Color(0xffb5b5b5)),
            title: new Text('Search'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications, color: const Color(0xffb5b5b5)),
              title: Text('Alerts')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: const Color(0xffb5b5b5)),
              title: Text('Profile'))
        ],
      ),
    );
  }
}

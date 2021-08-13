import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class treatment_timer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerState();
  }
}

class _TimerState extends State<treatment_timer> with TickerProviderStateMixin{
  final mainProgress = CountDownController();
  final secondProgress = CountDownController();
  late AnimationController _tickController;
  bool placeholder = true;
  bool done = false;
  bool compPhase = true;
  bool recoverPhase = false;

  String timer_value = "20 minutes";
  String timer2_value = "5 minutes";

  @override
  void initState(){
    super.initState();
    _tickController = AnimationController(vsync: this, duration: Duration(seconds: 1));

  }

  @override
  Widget build(BuildContext context) {

    //mainProgress.getTime();
    return Scaffold(
      body: SafeArea(
          child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: new Column(
                children: [
                  //Top left Icon
                  Image.asset("assets/images/bubble_bar.png"),
                  //Progress bar stack
                  Container(
                      margin: const EdgeInsets.only(top: 50.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          //Tick animation
                          AnimatedOpacity(
                              opacity: done ? 1.0 : 0.0,
                              duration: Duration(seconds: 1),
                              child: Lottie.asset(
                                "assets/animations/tick.json",
                                controller: _tickController,
                                width: 250,
                                height: 250,
                                repeat: true,
                                alignment: Alignment.center,
                              )),
                          //Progress bar container,
                          AnimatedOpacity(
                            opacity: done ? 0.0 : 1.0,
                            duration: Duration(seconds: 1),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                //Time
                                //Green bar
                                CircularCountDownTimer(
                                  duration: 10,
                                  initialDuration: 0,
                                  controller: secondProgress,
                                  width: 250,
                                  height: 250,
                                  ringColor: const Color(0xffB8D8D8),
                                  ringGradient: null,
                                  fillColor: const Color(0xff2EC4B6),
                                  fillGradient: null,
                                  backgroundColor: Colors.white,
                                  backgroundGradient: null,
                                  strokeWidth: 18.0,
                                  strokeCap: StrokeCap.square,
                                  textStyle: TextStyle(
                                      fontSize: 33.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textFormat: CountdownTextFormat.S,
                                  isReverse: false,
                                  isReverseAnimation: false,
                                  isTimerTextShown: true,
                                  autoStart: true,
                                  onStart: () {
                                    print('Countdown Started');
                                  },
                                  //Comp phase done
                                  onComplete: () {
                                    setState(() {
                                      compPhase = false;
                                    });
                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                    setState(() {
                                      recoverPhase = true;
                                      mainProgress.start();
                                    });
                                    });


                                    print('Countdown Ended');
                                  },
                                ),
                                //Blue bar
                                CircularCountDownTimer(
                                  duration: 10,
                                  initialDuration: 0,
                                  controller: mainProgress,
                                  width: 250,
                                  height: 250,
                                  ringColor: const Color(0x0000000),
                                  ringGradient: null,
                                  fillColor: const Color(0xff00A3DC),
                                  fillGradient: null,
                                  backgroundColor: null,
                                  backgroundGradient: null,
                                  strokeWidth: 18.0,
                                  strokeCap: StrokeCap.square,
                                  textStyle: TextStyle(
                                      fontSize: 33.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textFormat: CountdownTextFormat.S,
                                  isReverse: false,
                                  isReverseAnimation: false,
                                  isTimerTextShown: true,
                                  autoStart: false,
                                  onStart: () {
                                    print('Countdown Started');
                                  },
                                  //Recover phase done
                                  onComplete: () {
                                    setState(() {
                                      recoverPhase = false;

                                    });
                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                      setState(() {
                                      done = true;
                                      });
                                    });
                                    Future.delayed(const Duration(milliseconds: 2000), () {
                                      _tickController.forward();
                                    });

                                    print('Countdown Ended');
                                  },
                                ),
                                Column(children: [
                                  Text(
                                    "Time Remaining:",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'sergoe_ui',
                                        fontSize: 20,
                                        color: const Color(0xff707070)),
                                  ),
                                  Stack(
                                    children: [
                                      AnimatedOpacity(
                                          opacity: compPhase ? 1.0 :0.0,
                                          duration: Duration(seconds: 1),
                                          child:Text(
                                            timer_value,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'sergoe_ui',
                                                fontSize: 35,
                                                color: const Color(0xff707070)),
                                          ),
                                      ),
                                      AnimatedOpacity(
                                        opacity: recoverPhase ? 1.0 :0.0,
                                        duration: Duration(seconds: 1),
                                        child:Text(
                                          timer2_value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'sergoe_ui',
                                              fontSize: 35,
                                              color: const Color(0xff707070)),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    "35 minutes total",
                                    style: TextStyle(
                                        fontFamily: 'sergoe_ui',
                                        fontSize: 20,
                                        color: const Color(0xff707070)),
                                  ),
                                ]),


                              ],
                            ),
                          )
                        ],
                      )),
                  //Text Box
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 50.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity: compPhase ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: Column(
                              children: [
                                Text(
                                  "Compression Phase",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'gilroy',
                                      fontSize: 30,
                                      color: const Color(0xff424242)),
                                ),
                                Text("We won't be long",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'sergoe_ui',
                                        fontSize: 22,
                                        color: const Color(0xff707070))),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: recoverPhase ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: Column(
                              children: [
                                Text(
                                  "Recovery phase",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'gilroy',
                                      fontSize: 30,
                                      color: const Color(0xff424242)),
                                ),
                                Text("Your blood flow is returning to normal.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'sergoe_ui',
                                        fontSize: 22,
                                        color: const Color(0xff707070))),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: done ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: Column(
                              children: [
                                Text(
                                  "Congratulations!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'gilroy',
                                      fontSize: 30,
                                      color: const Color(0xff424242)),
                                ),
                                Text("You have finished another Lily session ! You can now remove the device.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'sergoe_ui',
                                        fontSize: 22,
                                        color: const Color(0xff707070))),
                              ],
                            ),
                          )
                        ],
                      )),
                  //Button
                  Container(
                      margin: const EdgeInsets.only(top: 50.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "CANCEL",
                          style: const TextStyle(
                              fontFamily: "sofia",
                              fontSize: 20,
                              color: const Color(0xff707070)),
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

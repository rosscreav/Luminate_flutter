import 'dart:async';
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
  final recoveryProgress = CountDownController();
  final compressionProgress = CountDownController();
  late AnimationController _tickController;
  bool placeholder = true;
  bool done = false;
  bool compPhase = true;
  bool recoverPhase = false;

  int compressionTimerLength = 10;
  int recoveryTimerLength = 5;
  String compressionText = "10 minutes";
  String recoveryText = "5 minutes";

  //Create a tick controller for the animation and timer for updating text
  @override
  void initState(){
    super.initState();
    _tickController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    new Timer.periodic(const Duration(milliseconds: 500), (Timer t) => updateTime());
  }

  //Update the amount of minutes remaining
  updateTime(){
    //Stop when unmounted (overflow precaution)
    if(mounted) {
      //If in the compression phase
      if (recoverPhase == false) {
        var time = compressionTimerLength -
            int.parse(compressionProgress.getTime()) - 1;
        if(time == -1) {time = 0;}
        setState(() {
          compressionText = "$time minutes";
        });
      }
      //In the recovery phase
      else {
        var time = recoveryTimerLength -
            int.parse(recoveryProgress.getTime()) - 1;
        if(time == -1) {time = 0;}
        setState(() {
          recoveryText = "$time minutes";
        });
      }
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
                                  duration: compressionTimerLength,
                                  initialDuration: 0,
                                  controller: compressionProgress,
                                  width: 280,
                                  height: 280,
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
                                      recoveryProgress.start();
                                      print(compressionProgress.getTime());
                                    });
                                    });


                                    print('Countdown Ended');
                                  },
                                ),
                                //Blue bar
                                CircularCountDownTimer(
                                  duration: recoveryTimerLength,
                                  initialDuration: 0,
                                  controller: recoveryProgress,
                                  width: 240,
                                  height: 240,
                                  ringColor: const Color(0xff8fc5d9),
                                  ringGradient: null,
                                  fillColor: const Color(0xff00A3DC),
                                  fillGradient: null,
                                  backgroundColor: null,
                                  backgroundGradient: null,
                                  strokeWidth: 12.0,
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
                                        fontSize: 17,
                                        color: const Color(0xff707070)),
                                  ),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedOpacity(
                                          opacity: compPhase ? 1.0 :0.0,
                                          duration: Duration(seconds: 1),
                                          child:Text(
                                            compressionText,
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
                                          recoveryText,
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
                                    "${recoveryTimerLength+compressionTimerLength} minutes total",
                                    style: TextStyle(
                                        fontFamily: 'sergoe_ui',
                                        fontSize: 17,
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

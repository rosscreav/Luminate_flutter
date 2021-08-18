//Imports
import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//Allow for calls of an instance of the Widget
class treatment_timer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerState();
  }
}

//Widget Class
class _TimerState extends State<treatment_timer> with TickerProviderStateMixin {
  //Controller for the progress indicators
  final recoveryProgress = CountDownController();
  final compressionProgress = CountDownController();
  //Animation controller for lottie animation
  late AnimationController _tickAnimationController;

  //Booleans for animated transitions
  //First phase with compression text and green timer tracked
  bool compPhase = true;
  //Second phase with recovery text and blue timer tracked
  bool recoverPhase = false;
  //Final state of the screen on timer completion
  bool done = false;

  //Variables used to control length of each timer in seconds
  int compressionTimerLength = 10;
  int recoveryTimerLength = 5;
  //Text variables for time real time timers
  String compressionText = "10 minutes";
  String recoveryText = "5 minutes";

  //Create a tick controller for the animation and timer for updating text
  @override
  void initState() {
    super.initState();
    //Animation length is one second
    _tickAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    //Create a timer to update the trackers every 500 ms
    new Timer.periodic(
        const Duration(milliseconds: 500), (Timer t) => updateTime());
  }

  //Update the amount of minutes remaining
  updateTime() {
    //Stop when unmounted (overflow precaution to stop when not drawn)
    if (mounted) {
      //If in the compression phase
      if (recoverPhase == false) {
        //Calculate the time left and round down by taking away 1
        var time =
            compressionTimerLength - int.parse(compressionProgress.getTime()) - 1;
        //When timer hits 0 display 0 instead of -1
        if (time == -1) {
          time = 0;
        }
        //Update the timer text
        setState(() {
          compressionText = "$time minutes";
        });
      }
      //Else in the recovery phase
      else {
        //Calculate the time left and round down by taking away 1
        var time =
            recoveryTimerLength - int.parse(recoveryProgress.getTime()) - 1;
        //When timer hits 0 display 0 instead of -1
        if (time == -1) {
          time = 0;
        }
        //Update the timer text
        setState(() {
          recoveryText = "$time minutes";
        });
      }
    }
  }

  //Build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Only display widgets within the safe area
      body: SafeArea(
          //Main container aligned to the center of the screen and containing a white background
          child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              //Column to place all widgets within to work down the screen
              child: new Column(
                children: [
                  //Image with the bubbles placed at the screen start
                  Image.asset("assets/images/bubble_bar.png"),
                  //Progress bar Container
                  Container(
                      //Offset 50 pixels away from the image
                      margin: const EdgeInsets.only(top: 50.0),
                      //Stack for all progress bar items and internal text
                      child: Stack(
                        //Align all children to the center of the stack
                        alignment: Alignment.center,
                        children: [
                          //Lottie Tick animation (plays on completion)
                          AnimatedOpacity(
                              //Only display when done is true
                              opacity: done ? 1.0 : 0.0,
                              duration: Duration(seconds: 1),
                              child: Lottie.asset(
                                "assets/animations/tick.json",
                                controller: _tickAnimationController,
                                width: 250,
                                height: 250,
                                repeat: true,
                                alignment: Alignment.center,
                              )),
                          //Timer container
                          AnimatedOpacity(
                            //Display until done is true
                            opacity: done ? 0.0 : 1.0,
                            duration: Duration(seconds: 1),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                //Compression Timer (Green)
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
                                  //Hide the in-built timer text
                                  textStyle: TextStyle(fontSize: 0),
                                  isReverse: false,
                                  isReverseAnimation: false,
                                  isTimerTextShown: true,
                                  autoStart: true,
                                  //Compression timer completion method
                                  onComplete: () {
                                    //Start transition to next phase
                                    setState(() {
                                      compPhase = false;
                                    });
                                    //Wait 1 second for animations to finish (avoid cross-fade)
                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                      setState(() {
                                        //Call in new text
                                        recoverPhase = true;
                                        //Start the recovery timer
                                        recoveryProgress.start();
                                      });
                                    });
                                  },
                                ),

                                //Recovery Timer (Blue)
                                CircularCountDownTimer(
                                  duration: recoveryTimerLength,
                                  initialDuration: 0,
                                  controller: recoveryProgress,
                                  width: 250,
                                  height: 250,
                                  ringColor: const Color(0xff8fc5d9),
                                  ringGradient: null,
                                  fillColor: const Color(0xff00A3DC),
                                  fillGradient: null,
                                  backgroundColor: null,
                                  backgroundGradient: null,
                                  strokeWidth: 12.0,
                                  strokeCap: StrokeCap.square,
                                  //Hide the in-built timer text
                                  textStyle: TextStyle(fontSize: 0),
                                  isReverse: false,
                                  isReverseAnimation: false,
                                  isTimerTextShown: true,
                                  autoStart: false,
                                  //Recovery timer completion method
                                  onComplete: () {
                                    //Start transition to next phase
                                    setState(() {
                                      recoverPhase = false;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 1000), () {
                                      setState(() {
                                        done = true;
                                      });
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 2000), () {
                                      _tickAnimationController.forward();
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
                                        opacity: compPhase ? 1.0 : 0.0,
                                        duration: Duration(seconds: 1),
                                        child: Text(
                                          compressionText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'sergoe_ui',
                                              fontSize: 35,
                                              color: const Color(0xff707070)),
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        opacity: recoverPhase ? 1.0 : 0.0,
                                        duration: Duration(seconds: 1),
                                        child: Text(
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
                                    "${recoveryTimerLength + compressionTimerLength} minutes total",
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
                                Text(
                                    "You have finished another Lily session ! You can now remove the device.",
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
      //Bottom navigation bar
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

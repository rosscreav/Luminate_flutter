//Imports
import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//Allow for calls of an instance of the Widget
class TreatmentTimer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerState();
  }
}

//Timer screen class
class _TimerState extends State<TreatmentTimer> with TickerProviderStateMixin {
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

  //Fade animation durations
  Duration fadeTime = const Duration(seconds: 1);
  Duration tickTime = const Duration(seconds: 1);

  //Variables used to control length of each timer in seconds
  int compressionTimerLength = 10;
  int recoveryTimerLength = 5;
  //Text variables for time real time timers
  String compressionText = "10 minutes";
  String recoveryText = "5 minutes";
  //Button text to allow for the button to swap text after completion
  String buttonText = "CANCEL";

  //Text Styles
  TextStyle smallTimerText = TextStyle(fontFamily: 'sergoe_ui', fontSize: 17, color: const Color(0xff707070));
  TextStyle largeTimerText = TextStyle(fontFamily: 'sergoe_ui', fontSize: 35, color: const Color(0xff707070));
  TextStyle titleTextStyle = TextStyle(fontFamily: 'gilroy', fontSize: 30, color: const Color(0xff424242));
  TextStyle subTextStyle = TextStyle(fontFamily: 'sergoe_ui', fontSize: 22, color: const Color(0xff707070));
  TextStyle buttonTextStyle = const TextStyle(fontFamily: "sofia", fontSize: 20, color: const Color(0xff707070));

  //Create a tick controller for the animation and timer for updating text
  @override
  void initState() {
    super.initState();
    //Animation length is one second
    _tickAnimationController =
        AnimationController(vsync: this, duration: tickTime);
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
            //Column to place all widgets within to in a vertical layout
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
                            duration: fadeTime,
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
                          duration: fadeTime,
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
                                  //Wait 1 second for animations to finish (avoid cross-fade)
                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                    setState(() {
                                      //Call in new text
                                      done = true;
                                      buttonText = "DONE";
                                    });
                                  });
                                  //Wait for animations to fully fade (1s after the new text)
                                  Future.delayed(const Duration(milliseconds: 2000), () {
                                    //Call the tick animation to play
                                    _tickAnimationController.forward();
                                  });
                                },
                              ),
                              //Text within the timer
                              Column(
                                  children: [
                                  //Top text - Time Remaining
                                  Text(
                                    "Time Remaining:",
                                    textAlign: TextAlign.center,
                                    style: smallTimerText,
                                  ),
                                  //Stack for the middle real time timer
                                  Stack(
                                    //Stack of two texts use to allow for easy fade out and back in
                                    alignment: Alignment.center,
                                    children: [
                                      //Compression real time countdown text
                                      AnimatedOpacity(
                                        opacity: compPhase ? 1.0 : 0.0,
                                        duration: fadeTime,
                                        child: Text(compressionText, textAlign: TextAlign.center, style: largeTimerText,),
                                      ),
                                      //Recovery real time countdown text
                                      AnimatedOpacity(
                                        opacity: recoverPhase ? 1.0 : 0.0,
                                        duration: fadeTime,
                                        child: Text(recoveryText, textAlign: TextAlign.center, style: largeTimerText,),
                                      ),
                                    ],
                                  ),
                                  //Bottom text - X minutes total
                                  Text(
                                    //Calculate the amount of time
                                    "${recoveryTimerLength + compressionTimerLength} minutes total",
                                    style: smallTimerText,
                                  ),
                              ]),
                            ],
                          ),
                        )
                      ],
                    )),
                //Text Box Container
                Container(
                    alignment: Alignment.center,
                    //Offset 50 from the progress bars and margin for text
                    margin: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
                    //Stack to hold all possible text
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        //Compression phase text
                        AnimatedOpacity(
                          //Only show during compression phase
                          opacity: compPhase ? 1.0 : 0.0,
                          duration: fadeTime,
                          //Column to hold title and subtext
                          child: Column(
                            children: [
                              //Compression title text
                              Text(
                                "Compression Phase",
                                textAlign: TextAlign.center,
                                style: titleTextStyle,
                              ),
                              //Compression subtext
                              Text("We won't be long",
                                  textAlign: TextAlign.center,
                                  style: subTextStyle,
                              ),
                            ],
                          ),
                        ),
                        //Recovery phase text
                        AnimatedOpacity(
                          //Only show during recovery phase
                          opacity: recoverPhase ? 1.0 : 0.0,
                          duration: fadeTime,
                          //Column to hold title and subtext
                          child: Column(
                            children: [
                              //Recovery title text
                              Text(
                                "Recovery phase",
                                textAlign: TextAlign.center,
                                style: titleTextStyle,
                              ),
                              //Recovery subtext
                              Text(
                                "Your blood flow is returning to normal.",
                                textAlign: TextAlign.center,
                                style: subTextStyle,
                              ),
                            ],
                          ),
                        ),
                        //Completion phase text
                        AnimatedOpacity(
                          //Only display when done
                          opacity: done ? 1.0 : 0.0,
                          duration: fadeTime,
                          //Column to hold title and subtext
                          child: Column(
                            children: [
                              //Completion title text
                              Text(
                                "Congratulations!",
                                textAlign: TextAlign.center,
                                style: titleTextStyle,
                              ),
                              //Completion subtext
                              Text(
                                "You have finished another Lily session! You can now remove the device.",
                                textAlign: TextAlign.center,
                                style: subTextStyle,
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                //Button Container
                Container(
                  //Offset from text box
                  margin: const EdgeInsets.only(top: 50.0),
                  //Remove the cancel button upon completion
                  child: AnimatedOpacity(
                    //Only show the cancel button before done
                    opacity: done ? 0 : 1,
                    duration: fadeTime,
                    //Cancel button
                    child: ElevatedButton(
                      //Set the button style
                      style: ButtonStyle(
                        //Set the background color to white
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          //Change rounded corners to be more round
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
                        //Add a light gray border for contrast
                        side: BorderSide(width: 1.0, color: const Color(0xf0d1d1d1),),
                            ))
                      ),
                      //On press cancel the screen when working or ignore presses when hidden
                      onPressed: () => done ? Navigator.pop(context) : {},
                      //Button text
                      child: Text(buttonText, style: buttonTextStyle,),
                    ),
                ),
                )
              ],
            ))),
        //Bottom navigation bar
        bottomNavigationBar: BottomNavigationBar(
          //Default to home icon
          currentIndex: 0,
          //Don't show the labels
          showSelectedLabels: false,
          showUnselectedLabels: false,
          //Four icons - Home, Search, Alerts, Profile
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home, color: const Color(0xff684FA0)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.search, color: const Color(0xffb5b5b5)),
              label: 'Search',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications, color: const Color(0xffb5b5b5)),
                label: 'Alerts'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, color: const Color(0xffb5b5b5)),
                label: 'Profile'
            )
          ],
        ),
    );
  }
}

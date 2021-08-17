import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Splash();
  }
}

class _Splash extends State<splash> {
  bool tapped = false;
  bool unlocked = false;

  onFingerprintTap() {
    print("test");
    setState(() {
      tapped = !tapped;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        unlocked = true;
      });
    });
    print("$tapped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Build from the center outwards so background can cover bounds
      body: Center(
          //Main stack for all objects
          child: Stack(
        children: [
          //Main background
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/images/splashbackground.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center),
          ),
          //Background top
          Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/splashbackgroundtop.png',
                width: double.infinity,
                fit: BoxFit.cover,
              )),
          //Top icon group
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30.0),
                child: Image.asset(
                  "assets/images/health_icon.png",
                  scale: 3,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 140.0),
                child: Image.asset(
                  "assets/images/health_icon.png",
                  scale: 3,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 40.0),
                margin: const EdgeInsets.only(right: 50.0),
                child: Image.asset(
                  "assets/images/health_icon.png",
                  scale: 3,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0.0),
                child: Image.asset(
                  "assets/images/health_icon.png",
                  scale: 3,
                ),
              ),
            ],
          ),
          //Lower icon group
          Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 130.0),
                    child: Image.asset(
                      "assets/images/health_icon.png",
                      scale: 2.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    margin: const EdgeInsets.only(right: 50.0),
                    child: Image.asset(
                      "assets/images/health_icon.png",
                      scale: 5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Image.asset(
                      "assets/images/health_icon.png",
                      scale: 2.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 150.0),
                    child: Image.asset(
                      "assets/images/health_icon.png",
                      scale: 4,
                    ),
                  ),
                ],
              )),
          //Logo
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 40.0, left: 40),
            child: Image.asset(
              'assets/images/white_luminate_logo.png',
              scale: 2,
            ),
          ),
          //Fingerprint and button
          Stack(children: [
            //Button
            AnimatedOpacity(
                opacity: unlocked ? 1 : 0,
                duration: Duration(seconds: 1),
                //Alignment Container
                child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 150),
                    //Container for button size
                    child: Container(
                        height: 60,
                        width: 200,
                        //Start button
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xffAA5BB0)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ))),
                          onPressed: unlocked
                              //When button is active
                              ? () {
                                  setState(() {
                                    Navigator.pushNamed(context, '/home');
                                  });
                                }
                              //When button is inactive
                              : () {
                                  print("locked");
                                },
                          child: Text(
                            "GET STARTED",
                            style: const TextStyle(
                                fontFamily: "sofia",
                                fontSize: 25,
                                color: Colors.white),
                          ),
                        )))),
            //Fingerprint container
            AnimatedOpacity(
                opacity: unlocked ? 0 : 1,
                duration: Duration(seconds: 1),
                //Fingerprint Icon
                child: Visibility(
                    visible: !unlocked,
                    child: Container(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 150),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            //Pulse animation
                            AnimatedOpacity(
                              opacity: tapped ? 1 : 0,
                              duration: Duration(seconds: 1),
                              child: Lottie.asset(
                                "assets/animations/cyan_pulse.json",
                                width: 100,
                                height: 100,
                                animate: tapped,
                              ),
                            ),
                            //Fingerprint
                            GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTapDown: (TapDownDetails details) =>
                                    onFingerprintTap(), // handle your image tap here
                                child: ColorFiltered(
                                  colorFilter: tapped
                                      ? ColorFilter.mode(
                                          Colors.cyan, BlendMode.srcIn)
                                      : ColorFilter.mode(
                                          Colors.blue, BlendMode.dst),
                                  child: Image.asset(
                                    'assets/images/fingerprint_icon.png',
                                    //color: tapped ? const Color(0xffffffff) : const Color(0xff00ccff),
                                    //colorBlendMode: BlendMode.multiply,

                                    fit: BoxFit
                                        .cover, // this is the solution for border
                                    scale: 3,
                                  ),
                                )),
                          ],
                        )))),
          ])
        ],
      )),
    );
  }
}

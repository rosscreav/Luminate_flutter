//Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//Allow for calls of an instance of the Widget
class LockScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LockScreen();
  }
}

//Lockscreen Class
class _LockScreen extends State<LockScreen> {
  //Booleans for animated transitions
  bool fingerprintLoading = false;
  bool unlocked = false;

  //The length of time for the fingerprint to wait
  Duration fingerprintProcessTime = const Duration(milliseconds: 1500);
  //Fade animation durations
  Duration fadeTime = const Duration(seconds: 1);

  //Text styles
  TextStyle buttonText = const TextStyle(fontFamily: "sofia", fontSize: 25, color: Colors.white);

  //Start the animation: processing the fingerprint
  //Wait fingerprintProcessTime and load the button
  onFingerprintTap() {
    //Start the fingerprint animation and color shift
    setState(() {fingerprintLoading = true;});
    //Wait for fingerprintProcessTime and call the button and fade the fingerprint
    Future.delayed(fingerprintProcessTime, () {
      setState(() {unlocked = true;});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Build from the center outwards so background can cover full screen bounds
      body: Center(
        //Main stack to contain all widgets
        child: Stack(
          children: [
            //Main background container
            Container(
              alignment: Alignment.center,
              //Align the image to the center of the screen and scale it till it hits borders
              child: Image.asset(
                  'assets/images/lockbackground.png',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center
              ),
            ),
            //Background top container
            Container(
              //Snap image to start of screen
              alignment: Alignment.topCenter,
              //Scale image fully horizontally to screen edge
              child: Image.asset(
                'assets/images/lockbackgroundtop.png',
                width: double.infinity,
                fit: BoxFit.cover,
              )
            ),
            //Top icon group Container
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //4 Icons spread across the top background spread equally horizontally
              children: [
                //Top left
                Container(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Image.asset(
                    "assets/images/health_icon.png",
                    scale: 3,
                  ),
                ),
                //Middle left
                Container(
                  padding: const EdgeInsets.only(top: 140.0),
                  child: Image.asset(
                    "assets/images/health_icon.png",
                    scale: 3,
                  ),
                ),
                //Middle right (offset 50 towards the middle)
                Container(
                  padding: const EdgeInsets.only(top: 40.0),
                  margin: const EdgeInsets.only(right: 50.0),
                  child: Image.asset(
                    "assets/images/health_icon.png",
                    scale: 3,
                  ),
                ),
                //Right
                Container(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Image.asset(
                    "assets/images/health_icon.png",
                    scale: 3,
                  ),
                ),
              ],
            ),
            //Lower icon group container
            Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Bottom left
                    Container(
                      padding: const EdgeInsets.only(bottom: 130.0),
                      child: Image.asset(
                        "assets/images/health_icon.png",
                        scale: 2.5,
                      ),
                    ),
                    //Left middle (offset towards left 50)
                    Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      margin: const EdgeInsets.only(right: 50.0),
                      child: Image.asset(
                        "assets/images/health_icon.png",
                        scale: 5,
                      ),
                    ),
                    //Right middle
                    Container(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Image.asset(
                        "assets/images/health_icon.png",
                        scale: 2.5,
                      ),
                    ),
                    //Right
                    Container(
                      padding: const EdgeInsets.only(bottom: 150.0),
                      child: Image.asset(
                        "assets/images/health_icon.png",
                        scale: 4,
                      ),
                    ),
                  ],
                )
            ),
            //Logo container
            Container(
              alignment: Alignment.center,
              //Keep logo from edge of the screen
              margin: const EdgeInsets.only(right: 40.0, left: 40),
              child: Image.asset(
                'assets/images/white_luminate_logo.png',
                scale: 2,
              ),
            ),
            //Fingerprint and button container
            Stack(
                children: [
                  //Button
                  AnimatedOpacity(
                    //Only show when unlocked
                    opacity: unlocked ? 1 : 0,
                    duration: fadeTime,
                    //Alignment Container
                    child: Container(
                      //Position the button
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.only(bottom: 150),
                      //Container size defined for button
                      child: Container(
                          height: 50,
                          width: 200,
                          //Start button
                          child: ElevatedButton(
                            //Set the button style
                            style: ButtonStyle(
                              //Button color #AA5BB0
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffAA5BB0)),
                                //Change rounded corners to be more round
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),))
                            ),
                            //On pressed progress when button is active
                            onPressed: unlocked
                                //When button is active
                                ? () {
                                    setState(() {
                                      Navigator.pushNamed(context, '/home');
                                    });
                                  }
                                //When button is inactive
                                : () {},
                            //Button text
                            child: Text("GET STARTED", style: buttonText,),
                          )
                      )
                    )
                  ),
                  //Fingerprint container
                  AnimatedOpacity(
                    //Only show when not unlocked
                    opacity: unlocked ? 0 : 1,
                    duration: fadeTime,
                    //Fingerprint Icon
                    child: Visibility(
                      //Disable the visibility when not in use (avoid button overlap)
                      visible: !unlocked,
                      child: Container(
                        //Disable any clipping (resolves button eating input)
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        //Offset everything from the bottom
                        margin: const EdgeInsets.only(bottom: 150),
                        //Stack for animation and icon
                        child: Stack(
                          //Allow for clipping between both
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            //Pulse animation
                            AnimatedOpacity(
                              //Only show while the fingerprint is loading
                              opacity: fingerprintLoading ? 1 : 0,
                              duration: fadeTime,
                              child: Lottie.asset(
                                "assets/animations/cyan_pulse.json",
                                width: 100,
                                height: 100,
                                //Turn on during fingerprint loading
                                animate: fingerprintLoading,
                              ),
                            ),
                            //Fingerprint image
                            GestureDetector(
                              //Allow hits through the GestureDetector
                              behavior: HitTestBehavior.translucent,
                              //On touching the fingerprint icon call the function
                              onTapDown: (TapDownDetails details) => onFingerprintTap(),
                              //Color filter to change the color of the image
                              child: ColorFiltered(
                                //Apply the color filter depending on loading
                                colorFilter: fingerprintLoading
                                    //If loading blend with a cyan mask
                                    ? ColorFilter.mode(Colors.cyan, BlendMode.srcIn)
                                    //If not loading use image as a mask
                                    : ColorFilter.mode(Colors.blue, BlendMode.dst),
                                //Fingerprint icon
                                child: Image.asset('assets/images/fingerprint_icon.png', fit: BoxFit.cover, scale: 3,),
                              )
                            ),
                          ],
                        )
                      )
                    )
                  ),
               ]
            )
          ],
       )
      ),
    );
  }
}

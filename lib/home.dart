//Imports
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//Create and return the Widget
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

//Home screen class
class _HomeState extends State<Home> {
  //Booleans for animated transitions
  bool stageUnconnected = true;
  bool stageConnected = false;
  bool stageStart = false;

  //Variable to allow the same button to be used for all stages
  String buttonText = "CONNECT";
  //Client name
  String name = "Mary";

  //Text styles
  TextStyle titleTextStyle = new TextStyle(fontFamily: 'gilroy', fontSize: 40, color: const Color(0xff424242));
  TextStyle subTextStyle = TextStyle(fontFamily: 'sergoe_ui', fontSize: 22, color: const Color(0xff707070));
  TextStyle buttonTextStyle = const TextStyle(fontFamily: "sofia", fontSize: 20, color: Colors.white);

  //Fade animation durations
  Duration fadeTime = const Duration(seconds: 1);

  //Set the opacity of different Text sections and images
  //This screen is divided into three stages - Connect, Connected, Start
  changeWidgets(BuildContext context) {
    //Connect => Connected Transition
    if(stageUnconnected){
      //Fade out unconnected and set button text to next
      setState(() {
        stageUnconnected = false;
        buttonText = "NEXT";
      });
      //Wait for animation and load new text and image
      Future.delayed(fadeTime, () {
        setState(() {stageConnected = true;});
      });
    //Connected => Start Transition
    }else if(stageConnected){
      //Fade out connected and set button text to next
      setState(() {
        stageConnected = false;
        buttonText = "START";
      });
      //Wait for animation and load new text and image
      Future.delayed(fadeTime, () {
        setState(() {stageStart = true;});
      });
    }
    //Transition to the next route
    else{
      setState(() {
        //Push transition to timer
        Navigator.pushNamed(context, '/timer');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Build within the safe area (avoiding notches and other system specific features)
      body: SafeArea(
          //Main container aligned to the center and with white background
          child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              //Column to place all widgets within to in a vertical layout
              child: new Column(
                children: [
                  //Image with the bubbles placed at the screen start
                  Image.asset("assets/images/bubble_bar.png"),
                  //Top left Icon decoration
                  Container(
                      //Add margin from the bubble bar and give it margin same as the text from left edge
                      margin: const EdgeInsets.only(top: 40.0, left: 40),
                      alignment: Alignment.topLeft,
                      //Call image and scale it 2.5 smaller
                      child: Image.asset("assets/images/triple_dash_image.png", scale: 2.5,)
                  ),
                  //Title Text Container
                  Container(
                      //Add margin from left side and the icon decoration
                      margin: const EdgeInsets.only(top: 20.0, left: 40),
                      alignment: Alignment.topLeft,
                      //Stack to container title text for each stage
                      child: Stack(
                          children: [
                          //Hello "name" => text title
                          AnimatedOpacity(
                              //Only show during unconnected
                              opacity: stageUnconnected ? 1.0 : 0.0,
                              duration: fadeTime,
                              child: Text(
                                "Hello, $name",
                                style: titleTextStyle,
                              )
                          ),
                          //Success => connected text title
                          AnimatedOpacity(
                              //Only show during connected
                              opacity: stageConnected ? 1.0 : 0.0,
                              duration: fadeTime,
                              child: Text(
                                "Success!",
                                style: titleTextStyle,
                              )
                          ),
                          //Awesome => start text title
                          AnimatedOpacity(
                              //Only show during start stage
                              opacity: stageStart ? 1.0 : 0.0,
                              duration: fadeTime,
                              child: Text(
                                "Awesome!",
                                style: titleTextStyle,
                              )
                          ),
                        ]
                      )
                  ),
                  //Subtext Container
                  Container(
                      //Add margin from left side and the title text as well as limiting text box size
                      margin: const EdgeInsets.only(top: 10.0, left: 40, right: 20),
                      alignment: Alignment.topLeft,
                      //Stack to container subtext for each stage
                      child: Stack(
                        children: [
                          //Bluetooth not connected (Rich text to highlight the word TextSpan)
                          AnimatedOpacity(
                            //Only show during unconnected
                            opacity: stageUnconnected ? 1.0 : 0,
                            duration: fadeTime,
                            child: RichText(
                              //Split Strings into three text spans to allow for the other color
                              text: TextSpan(
                                //Start string
                                text: "Let's get started with your Lily therapy. Turn on the Lily device and press ",
                                style: subTextStyle,
                                children: <TextSpan>[
                                  //Connect in purple
                                  TextSpan(
                                      text: 'connect',
                                      //Purple color for connect
                                      style: TextStyle(color: const Color(0xffAA5BB0))),
                                  //End of string
                                  TextSpan(text: ' on the screen below.'),
                                ],
                              ),
                            ),
                          ),
                          //Bluetooth connected subtext
                          AnimatedOpacity(
                            //Only show during connected
                            opacity: stageConnected ? 1.0 : 0,
                            duration: fadeTime,
                            child: Text(
                                "Lily is now connected. You can now place the headband over your head.",
                                style: subTextStyle,
                            ),
                          ),
                          AnimatedOpacity(
                            //Only show during start stage
                            opacity: stageStart ? 1.0 : 0,
                            duration: fadeTime,
                            child: Text(
                                "When you are ready, press begin to start compression therapy.",
                                style: subTextStyle,
                            ),
                          )
                        ],
                      )
                  ),
                  //Image Container
                  Container(
                    //Offset from Text
                    margin: const EdgeInsets.only(top: 10.0),
                    //Stack of images
                    child: Stack(
                        alignment: Alignment.center,
                        children: [
                          //Stack for bluetooth logo and animation
                          AnimatedOpacity(
                            //Only show while not connected
                            opacity: stageUnconnected ? 1.0 : 0.0,
                            duration: fadeTime,
                            //Stack of animation and image
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                //Pulse animation shown behind the Bluetooth icon
                                Lottie.asset(
                                  "assets/animations/pulse.json",
                                  width: 250,
                                  height: 250,
                                  alignment: Alignment.center,
                                ),
                                //Unconnected bluetooth logo
                                Image.asset(
                                  "assets/images/bluetooth_unconnected.png",
                                  scale: 2,
                                  alignment: Alignment.center,
                                ),
                              ],
                            ),
                          ),
                          //Bluetooth connected image
                          AnimatedOpacity(
                            //Only show when connected
                            opacity: stageConnected ? 1.0 : 0.0,
                            duration: fadeTime,
                            //Image centered and scaled down
                            child: Image.asset(
                              "assets/images/bluetooth_connected.png",
                              alignment: Alignment.center,
                              scale: 2.5,
                            )
                          ),
                          //Helmet render image
                          AnimatedOpacity(
                            //Only show on start stage
                            opacity: stageStart ? 1.0 : 0.0,
                            duration: fadeTime,
                            //Image centered on container and scaled
                            child: Image.asset(
                              "assets/images/helmet_render.png",
                              alignment: Alignment.center,
                              scale: 2.8,
                            ))
                        ]
                    ),
                  ),
                  //Button Container
                  Container(
                    //Set the size of the button
                    height: 50,
                    width: 180,
                    child: ElevatedButton(
                      //Set the button style
                      style: ButtonStyle(
                        //Button color #AA5BB0
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffAA5BB0)),
                        //Change rounded corners to be more round
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),))
                      ),
                      //When checked change the current screen or move on
                      onPressed: () => changeWidgets(context),
                      //Button text
                      child: Text(buttonText, style: buttonTextStyle,),
                    )
                  )
                ],
              )
          )
      ),
      //Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        //Even spacing
        type: BottomNavigationBarType.fixed,
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


import 'package:flutter/material.dart';

import 'lang/AppLocalizations.dart';

class Manual extends StatelessWidget {
  const Manual({super.key});

  @override
  Widget build(BuildContext context) {
     var localizedStrings = AppLocalizations.of(context);
 
    String? help = localizedStrings?.getHelp();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 128, 200, 85),
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text('${help ?? 'Help'}'),
        backgroundColor: Color.fromARGB(255, 128, 200, 85),
      ),
      body: Center(
          child: Column(
        children: [
          (Column(
            children: [
              
            ],
          )),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 1.7,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 230, 226, 214),
                    child: Column(
                      children: [
                        Text(
                          'Detection Help',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 50),
                              child: Text(
                                'first click on deection button',
                              ),
                            ),
                            Transform.rotate(
                              angle: 45.55,
                              child: Container(
                                padding: EdgeInsets.only(left: 180, top: 150),
                                child: Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 150,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 200, top: 30),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/1.jpg",
                                    
                                  )),
                            ),
                          ],
                        ),
  
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 200, top: 100),
                              child: Text(
                                'then select or capture image',
                              ),
                            ),
                            Transform.rotate(
                              alignment: Alignment.center,
                              angle: 45,
                              child: Container(
                                padding: EdgeInsets.only(left: 280, top: 200),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 100,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 200),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/2.jpg",
                                  )),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 200, top: 70),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/3.jpg",
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(right:20, top: 50),
                              child: Text(
                                'now click on detect button',
                              ),
                              
                            ), Transform.rotate(
                              angle: 45.55,
                              child: Container(
                                padding: EdgeInsets.only(left: 180, top: 200),
                                child: Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 150,
                                ),
                              ),
                            ),Container(
                              padding: EdgeInsets.only(left: 0, top: 400),
                              child: Text(
                                'observe result and recomendations',
                              ),
                            ),
                          ],
                        ),Stack(
                          children: [
                            Transform.rotate(
                              angle: 45.55,
                              child: Container(
                                padding: EdgeInsets.only(left: 180, top: 150),
                                child: Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 150,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 3, top: 30),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/result.png",
                                    
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),Container(
                    padding: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 1.2,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 230, 226, 214),
                    child: Column(
                      children: [
                        Text(
                          'history',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 0, top: 50),
                              child: Text(
                                'on home page click on history',
                              ),
                            ),
                            Transform.rotate(
                              angle: 45.55,
                              child: Container(
                                padding: EdgeInsets.only(left: 180, top: 150),
                                child: Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 150,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 200, top: 30),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/home.png",
                                    
                                  )),
                            ),
                          ],
                        ),
  
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 200, top: 100),
                              child: Text(
                                'based on what has been detected see ',
                              ),
                            ),
                            Transform.rotate(
                              alignment: Alignment.center,
                              angle: 45,
                              child: Container(
                                padding: EdgeInsets.only(left: 280, top: 200),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 100,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 200),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/history.png",
                                  )),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 200, top: 70),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/historyde.jpg",
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 30, top: 90),
                              child: Text(
                                'observe hstory',
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),Container(
                    padding: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 1.2,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 230, 226, 214),
                    child: Column(
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 0, top: 50),
                              child: Text(
                                'on home page click on profile',
                              ),
                            ),
                            Transform.rotate(
                              angle: 45.55,
                              child: Container(
                                padding: EdgeInsets.only(left: 180, top: 150),
                                child: Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 150,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 200, top: 30),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/home.png",
                                    
                                  )),
                            ),
                          ],
                        ),
  
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 200, top: 100),
                              child: Text(
                                'change any neccessary content',
                              ),
                            ),
                            Transform.rotate(
                              alignment: Alignment.center,
                              angle: 45,
                              child: Container(
                                padding: EdgeInsets.only(left: 280, top: 200),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 100,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 200),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/profile.jpg",
                                  )),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 200, top: 70),
                              child: Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    "assets/profilede.jpg",
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 30, top: 90),
                              child: Text(
                                'save change',
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:safe_crop/view/pages/DetectPest.dart';

import 'Detect.dart';
import 'lang/AppLocalizations.dart';


class detectchoose extends StatelessWidget {
   final String deviceId;
    detectchoose({required this.deviceId});
  @override
  Widget build(BuildContext context) {
  var localizedStrings = AppLocalizations.of(context);
    String? detectPests = localizedStrings?.getDetectPests();
    String? detectDisease = localizedStrings?.getDetectDisease();
    String? choose = localizedStrings?.getChoose();
    return Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
        ),
        
        title:  Text('${choose ?? 'Choose'}'),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bug_report,
                    size: 110,
                    color: Color.fromARGB(255, 128, 200, 85),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetectPest(deviceId: deviceId,)),
                      );
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            image: AssetImage(
                              "assets/d.png",
                            ),
                          ),
                          Text(
                            '${detectPests ?? 'Detect Pest'}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_outlined,
                            size: 30,
                          )
                        ],
                      ),
                      height: 47,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 128, 200, 85)),
                    ),
                  ),
                ],
              ),
            )),
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(255, 128, 200, 85),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Detect(deviceId: deviceId,)),
                      );
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            image: AssetImage(
                              "assets/d.png",
                            ),
                          ),
                          Text(
                            '${detectDisease ?? 'Detect Disease'}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_outlined,
                            size: 30,
                          )
                        ],
                      ),
                      height: 47,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Icon(
                        Icons.bubble_chart,
                        size: 99,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.circle_outlined,
                        size: 119,
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

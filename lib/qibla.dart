import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';

class QiblaPage extends StatefulWidget {
  @override
  _QiblaState createState() => new _QiblaState();
}

class _QiblaState extends State<QiblaPage> {
  double _direction;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.blueGrey[800],
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Colors.grey[300],
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                  margin: EdgeInsetsDirectional.only(top: 40.0),
                  width: 300.0,
                  height: 300.0,
                  color: Colors.grey[300],
                  child: Transform.rotate(
                    angle: ((_direction ?? 0) * (math.pi / 180) * -1),
                    child: Image.asset('assets/compass.png'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(top: 30.0),
                child: Text(
                  '136° SE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white),
                ),
              ),
              Align(
                child: Container(
                    margin: EdgeInsetsDirectional.only(top: 10.0),
                    child: Image.asset('assets/footer.png')),
              )
            ],
          )),
    );
  }
}

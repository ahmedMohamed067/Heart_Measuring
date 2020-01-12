import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../pages.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool isLoading = false;
  bool isConnected = false;
  String value, condition;

  Future get connect async {
    setState(() => isLoading = !isLoading);
    BluetoothConnection connection =
        await BluetoothConnection.toAddress("20:15:08:13:95:77");
    print("connected");

    setState(() => isConnected = connection.isConnected);

    StreamSubscription<Uint8List> subscription =
        connection.input.listen((Uint8List data) {
      print("listening");
      if (isLoading) {
        setState(() => isLoading = !isLoading);
      }
      setState(() {
        value = ascii.decode(data);
      });
    });

    await Future.delayed(Duration(seconds: 10));
    await subscription.cancel();
    setState(() {
      condition = "See a doctor";
    });
    print("done");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var topBar = ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      title: Text(
        "Heart Measuring",
        style: TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
      // subtitle: Text(
      //   titles[selectedIndex],
      //   style: TextStyle(
      //     color: Colors.white54,
      //     fontSize: 17,
      //   ),
      // ),
      trailing: Image.asset(
        "assets/logo.png",
        // height: size.width / 3,
      ),
    );

    var body = GestureDetector(
      onTap: () async {
        if (condition == "See a doctor") {
          push(context, Places(), fullScreenDialog: true);
        } else {
          connect.catchError((error) async {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Connection Error"),
                content: Text("Please restart your device and try again."),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Done"),
                    onPressed: () {
                      pop(context);
                    },
                  )
                ],
              ),
            );

            value = null;
            condition = null;

            setState(() => isLoading = !isLoading);
          });
        }
      },
      child: Material(
        elevation: 10,
        shape: CircleBorder(),
        child: Container(
          height: size.width / 2,
          width: size.width / 2,
          child: (isLoading)
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.red[900]),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      value ?? "Start",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    (condition != null)
                        ? Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              condition,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue[900], Colors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              topBar,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    body,
                    SizedBox(height: 10),
                    (condition != null)
                        ? FlatButton(
                            onPressed: () {
                              value = null;
                              condition = null;
                              connect.catchError((error) async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Connection Error"),
                                    content: Text(
                                        "Please restart your device and try again."),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Done"),
                                        onPressed: () {
                                          pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                );

                                value = null;
                                condition = null;

                                setState(() => isLoading = !isLoading);
                              });
                            },
                            child: Text(
                              "Try Again",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

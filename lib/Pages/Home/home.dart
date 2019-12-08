import 'dart:async';

import '../pages.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool isLoading = false;
  String value, condition;

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

    var body = Center(
      child: GestureDetector(
        onTap: () async {
          if (condition == "See a doctor") {
            push(context, Places(), fullScreenDialog: true);
          } else {
            setState(() => isLoading = !isLoading);
            Timer(Duration(seconds: 5), () {
              value = "99";
              condition = "See a doctor";
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
                child: body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

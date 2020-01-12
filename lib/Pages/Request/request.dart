import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:http/http.dart';

import '../pages.dart';

class RequestDialog extends StatefulWidget {
  RequestDialog(this.clinic, this.userDocument);
  final DocumentSnapshot clinic, userDocument;
  @override
  _RequestDialogState createState() => _RequestDialogState();
}

class _RequestDialogState extends State<RequestDialog> {
  bool isLoading = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Map<String, dynamic> request = new Map<String, dynamic>();
  List<FocusNode> nodes = List.generate(2, (index) => FocusNode());

  Future get send async {
    setState(() => isLoading = !isLoading);

    if (formKey.currentState.validate() &&
        request["time"] != null &&
        request["day"] != null) {
      request["date"] = DateTime.now();

      TimeOfDay _time = request["time"];

      DateTime now = DateTime.now();

      request["time"] =
          DateTime(now.year, now.month, now.day, _time.hour, _time.minute);

      print(request);

      request["clinicName"] = widget.clinic["clinicName"];

      await widget.userDocument.reference.collection("requests").add(request);

      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAOvGyh50:APA91bEooEab6_vh5jPxPgxHWkXJ2HwJ-V8mWv3H3kz4t5n8HAMDYMq8wsXwiDGXBkVSnOAV7T_TbIkVrHjGKr-2zD8-jtpQ2jnCgq4h2MoOPbEW10Vpf-JKqGwlDKLFRw6x6I9a1ya7",
      };

      var httpRequest = {
        "notification": {
          "title": "You have a new request.",
        },
        "to": "/topics/${widget.userDocument.documentID}",
      };

      var client = new Client();
      var response = await client.post(url,
          headers: header, body: json.encode(httpRequest));

      print(json.decode(response.body)["message_id"].toString());

      pop(context);
    }

    setState(() => isLoading = !isLoading);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var name = Padding(
      padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: TextFormField(
        focusNode: nodes[0],
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (text) =>
            FocusScope.of(context).requestFocus(nodes[1]),
        validator: (text) {
          if (text.isEmpty) {
            return "Do not leave empty.";
          } else {
            setState(() => request["patientName"] = text);
          }
        },
        decoration: InputDecoration(
          labelText: "Full name",
          // labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );

    var phone = Padding(
      padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: TextFormField(
        focusNode: nodes[1],
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        validator: (text) {
          if (text.isEmpty) {
            return "Do not leave empty.";
          } else {
            setState(() => request["phone"] = text);
          }
        },
        decoration: InputDecoration(
          labelText: "Phone",
          // labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );

    var daysWidget = Column(
      children: List.generate(
        widget.clinic["days"].length,
        (index) => RadioListTile(
          value: widget.clinic["days"][index],
          groupValue: request["day"],
          title: Text(widget.clinic["days"][index]),
          onChanged: (value) {
            setState(() {
              request["day"] = value;
            });
          },
        ),
      ),
    );

    var time = FlatButton(
      onPressed: () async {
        request["time"] = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());
        setState(() {});
      },
      child: Text(
        (request["time"] != null)
            ? "${request["time"].hour}:${request["time"].minute}"
            : "Time",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    var doneButton = GestureDetector(
      onTap: () async {
        await send.catchError((error) {
          print(error);
          setState(() => isLoading = !isLoading);
        });
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.lightBlue,
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: (isLoading)
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(
                  "Done",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );

    var topBar = Row(
      children: <Widget>[
        IconButton(
          onPressed: () => pop(context),
          icon: Icon(
            Icons.close,
            size: 27,
          ),
        ),
      ],
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Material(
          elevation: 10,
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                topBar,
                SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          name,
                          phone,
                          daysWidget,
                          time,
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                doneButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

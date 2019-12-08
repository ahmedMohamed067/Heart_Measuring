import 'package:date_format/date_format.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages.dart';

class Clinics extends StatelessWidget {
  Clinics(this.doctor);
  final DocumentSnapshot doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue[900], Colors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text("${doctor["fullName"]}'s clinics"),
        ),
        backgroundColor: Colors.transparent,
        body: StreamBuilder(
          stream: doctor.reference
              .collection("clinics")
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, querySnapshot) {
            if (!querySnapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );

            List<DocumentSnapshot> clinics = querySnapshot.data?.documents;

            if (clinics.isEmpty)
              return Center(
                child: Text(
                  "No doctors in your city.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 30),
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                DocumentSnapshot clinic = clinics[index];
                String from =
                    formatDate(clinic["from"].toDate(), [hh, ":", mm, " ", am]);
                String to =
                    formatDate(clinic["to"].toDate(), [hh, ":", mm, " ", am]);

                return Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
                  child: GestureDetector(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) => RequestDialog(clinic, doctor));
                    },
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        title: Text(
                          clinic["clinicName"],
                          style: TextStyle(
                            color: Colors.lightBlue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text("From $from to $to"),
                        trailing: IconButton(
                          onPressed: () {
                            launch("tel:${clinic["phone"]}");
                          },
                          icon: Icon(
                            Icons.call,
                            color: Colors.lightBlue[900],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

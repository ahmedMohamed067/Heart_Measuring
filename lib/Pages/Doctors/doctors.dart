import '../pages.dart';

class Doctors extends StatelessWidget {
  Doctors(this.place);
  final String place;
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
          title: Text("Choose doctor"),
        ),
        backgroundColor: Colors.transparent,
        body: StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .where("city", isEqualTo: place)
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, querySnapshot) {
            if (!querySnapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );

            List<DocumentSnapshot> doctors = querySnapshot.data?.documents;

            if (doctors.isEmpty)
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
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doctor = doctors[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
                  child: GestureDetector(
                    onTap: () {
                      push(context, Clinics(doctor));
                    },
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        title: Text(
                          doctor["fullName"],
                          style: TextStyle(
                            color: Colors.lightBlue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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

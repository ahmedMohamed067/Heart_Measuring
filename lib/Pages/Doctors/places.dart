import '../pages.dart';

class Places extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> places = ["Cairo", "Giza"];

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
          title: Text("Choose your city"),
        ),
        backgroundColor: Colors.transparent,
        body: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 30),
          itemCount: places.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: GestureDetector(
              onTap: () {
                push(context, Doctors(places[index]));
              },
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  title: Text(
                    places[index],
                    style: TextStyle(
                      color: Colors.lightBlue[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

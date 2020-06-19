import 'package:flutter/material.dart';
import 'package:imagestorage/results.dart';
import 'crud_operations.dart';
import 'students.dart';
import 'dart:async';
import 'insert.dart';
import 'update.dart';
import 'select.dart';
import 'convertidor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
      ),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  //Variables referentes al manejo de la BD
  Future<List<Student>> Studentss;
  TextEditingController onecontroller = TextEditingController();
  TextEditingController twocontroller = TextEditingController();
  TextEditingController threecontroller = TextEditingController();
  TextEditingController fourcontroller = TextEditingController();
  TextEditingController fivecontroller = TextEditingController();
  TextEditingController sixcontroller = TextEditingController();
  String name;
  String ap;
  String am;
  String tel;
  String email;
  String clave;
  int currentUserId;


  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating; //Saber el estado actual de la consulta
  bool disabled1;
  bool disabled2;
  bool disabled3;
  bool disabled4;
  bool disabled5;
  bool disabled6;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    disabled1 = false;
    disabled2 = false;
    disabled3 = false;
    disabled4 = false;
    disabled5 = false;
    disabled6 = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = dbHelper.getStudents();
    });
  }

  void cleanData() {
    onecontroller.text = "";
    twocontroller.text = "";
    threecontroller.text = "";
    fourcontroller.text = "";
    fivecontroller.text = "";
    sixcontroller.text = "";
  }

  //Mostrar datos
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Name"),
          ),
          DataColumn(
            label: Text("P-Surname"),
          ),
          DataColumn(
            label: Text("M-Surname"),
          ),
          DataColumn(
            label: Text("Phone"),
          ),
          DataColumn(
            label: Text("E-Mail"),
          ),
          DataColumn(
            label: Text("Enrollment"),
          ),
          DataColumn(
            label: Text("Image"),
          ),
          DataColumn(
            label: Text("Delete"),
          ),
        ],
        rows: Studentss.map((student) => DataRow(cells: [
          DataCell(Text(student.name.toString().toUpperCase())),
          DataCell(Text(student.ap.toString().toUpperCase())),
          DataCell(Text(student.am.toString().toUpperCase())),
          DataCell(Text(student.tel.toString().toUpperCase())),
          DataCell(Text(student.email.toString().toUpperCase())),
          DataCell(Text(student.clave.toString().toUpperCase())),
          DataCell(Convertir.imageFromBase64String(student.photoName)),
          DataCell(IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              dbHelper.delete(student.controlnum);
              refreshList();
            },
          ))
        ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
          future: Studentss,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //Cuando tenemos datos
              return dataTable(snapshot.data);
            }
            if (snapshot.data == null || snapshot.data.length == 0) {
              return Text("No data founded!");
            }
            return CircularProgressIndicator();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Flutter Basic SQL Operations',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),),
        backgroundColor: Colors.indigoAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
              ),
              padding: EdgeInsets.all(10),
              child: Text("Operations:",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            ListTile(
              title: Text("Insert",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent),),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new homePageinsert()));
              },
            ),
            ListTile(
              title: Text("Update",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent),),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new homePageupdate()));
              },
            ),
            ListTile(
              title: Text("Select",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent),),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new homePageselect()));
              },
            ),
            ListTile(
              title: Text("Results",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent),),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new homePageresults()));
              },
            ),
          ],
        ),
      ),
      body: new Container(
        child: new Padding(
          padding: (EdgeInsets.all(20.0)),
          child: new Column(
            children: <Widget>[
              list(),
              MaterialButton(
                color: Colors.indigoAccent,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.indigoAccent),
                ),
                onPressed: () {
                  refreshList();
                },
                //Agregar si ya se ha insertado
                child: Text('Update Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

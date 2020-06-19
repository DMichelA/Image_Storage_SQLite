import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'students.dart';
import 'dart:async';
import 'convertidor.dart';

class homePageselect extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePageselect> {
  Future<List<Student>> Studentss;
  TextEditingController onecontroller = TextEditingController();
  TextEditingController twocontroller = TextEditingController();
  TextEditingController threecontroller = TextEditingController();
  TextEditingController fourcontroller = TextEditingController();
  TextEditingController fivecontroller = TextEditingController();
  TextEditingController sixcontroller = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();

  String name;
  String ap;
  String am;
  String tel;
  String email;
  String clave;
  int currentUserId;
  bool is_typing = false;

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = dbHelper.getNameStudent(searchcontroller.text.toUpperCase());
    });
  }

  void cleanData() {
    searchcontroller.text = "";
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
        ],
        rows: Studentss.map((student) => DataRow(cells: [
          DataCell(Text(student.name.toString().toUpperCase())),
          DataCell(Text(student.ap.toString().toUpperCase())),
          DataCell(Text(student.am.toString().toUpperCase())),
          DataCell(Text(student.tel.toString().toUpperCase())),
          DataCell(Text(student.email.toString().toUpperCase())),
          DataCell(Text(student.clave.toString().toUpperCase())),
          DataCell(Convertir.imageFromBase64String(student.photoName)),
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
        title: is_typing
            ? TextField(
            decoration: InputDecoration(
                hintText: "Search By Name",
                hintStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            autofocus: true,
            controller: searchcontroller,
            onChanged: (text) {
              refreshList();
            })
            : Text(
          'Select Operation',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(is_typing ? Icons.done : Icons.search),
          onPressed: () {
            print("Is typing " + is_typing.toString());
            setState(() {
              is_typing = !is_typing;
              searchcontroller.text = "";
            });
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: new Container(
        child: new Padding(
          padding: (EdgeInsets.all(20.0)),
          child: new Column(children: <Widget>[
            list(),
          ]),
        ),
      ),
    );
  }
}

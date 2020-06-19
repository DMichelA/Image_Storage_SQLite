import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'students.dart';
import 'dart:async';
import 'convertidor.dart';
import 'package:imagestorage/CardStudent.dart';

class homePageresults extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePageresults> {
  Future<List<Student>> Studentss;
  var dbHelper;
  TextEditingController searchcontroller = TextEditingController();
  bool is_typing = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    getStudents();
  }

  void getStudents() {
    setState(() {
      Studentss = dbHelper.getNameStudent(searchcontroller.text.toUpperCase());
    });
  }

  void cleanData() {
    searchcontroller.text = "";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: is_typing
            ? TextField(
                decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                autofocus: true,
                controller: searchcontroller,
                onChanged: (text) {
                  getStudents();
                })
            : Text(
                'Search Students',
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: FutureBuilder(
            future: Studentss,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return snapshot.data[index].name.contains(searchcontroller.text)
                        ? ListTile(
                            leading: CircleAvatar(
                              backgroundImage: Convertir.imageFromBase64String(snapshot.data[index].photoName).image,),
                            title: new Text(
                              snapshot.data[index].name+" "+snapshot.data[index].ap+" "+snapshot.data[index].am.toString(),
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          //subtitle: new Text(snapshot.data[index].clave.toString()),
                            onTap: () {
                              Navigator.push(context,
                                  new MaterialPageRoute(builder: (context) => SendCard (snapshot.data[index])));
                            },
                          )
                        : Container();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

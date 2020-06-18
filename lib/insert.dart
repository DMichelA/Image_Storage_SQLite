import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'students.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'convertidor.dart';

class homePageinsert extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePageinsert> {
  Future<List<Student>> Studentss;
  TextEditingController onecontroller = TextEditingController();
  TextEditingController twocontroller = TextEditingController();
  TextEditingController threecontroller = TextEditingController();
  TextEditingController fourcontroller = TextEditingController();
  TextEditingController fivecontroller = TextEditingController();
  TextEditingController sixcontroller = TextEditingController();
  TextEditingController sevencontroller = TextEditingController();

  String name;
  String ap;
  String am;
  String tel;
  String email;
  String clave;
  int currentUserId;
  String imagenString;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating; //Saber el estado actual de la consulta
  bool disabled1;
  bool disabled2;
  bool disabled3;
  bool disabled4;
  bool disabled5;
  bool disabled6;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

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

  void inserted() {
    setState(() {
      _showSnackbar(context, "Inserted Data!");
    });
  }

  void cleanData() {
    onecontroller.text = "";
    twocontroller.text = "";
    threecontroller.text = "";
    fourcontroller.text = "";
    fivecontroller.text = "";
    sixcontroller.text = "";
    sevencontroller.text = "";
  }


  void dataValidate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name, ap, am, tel, email, clave, imagenString);
        dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(null, name, ap, am, tel, email, clave, imagenString);
        dbHelper.insert(stu);
      }
      //Limpia despues de ejecutar de la consulta
      cleanData();
      refreshList();
    }
  }

  void busquedaMatriculaInsert () async {
    List matricula = await dbHelper.busqueda();
    print(matricula);
    if (matricula.length == 0) {
      dataValidate();
      inserted();
    }
    else if (matricula.length !=0){
      for (int i = 0; i < matricula.length; i++) {
        if (matricula[i] == sixcontroller.text) {
          _showSnackbar(context, "It already exists");
        } else {
          dataValidate();
          inserted();
        }
      }
    }
  }

  pickImagefromGallery(){
    ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640).then((imgFile){
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      imagenString = imgString;
      sevencontroller.text = "Archivo Imagen Estudiante";
      return imagenString;
    });
  }

  pickImagefromCamera(){
    ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640).then((imgFile){
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      imagenString = imgString;
      sevencontroller.text = "Archivo Imagen Estudiante";
      return imagenString;
    });
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Tomar foto'),
                    onTap: pickImagefromCamera,
                  ),

                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  GestureDetector(
                    child: Text('Seleccionar foto'),
                    onTap: pickImagefromGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }

//Formulario
  Widget form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new SizedBox(height: 10.0),
            TextFormField(
              enabled: disabled1 ? false : true,
              controller: onecontroller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Student Name"),
              validator: (val) => val.length == 0 ? 'Enter name' : null,
              onSaved: (val) => name = val,
            ),
            new SizedBox(
              height: 10.0,
            ),
            TextFormField(
              enabled: disabled2 ? false : true,
              controller: twocontroller,
              keyboardType: TextInputType.text,
              decoration:
              InputDecoration(labelText: "Student Paternal surname"),
              validator: (val) =>
              val.length == 0 ? 'Enter Paternal surname' : null,
              onSaved: (val) => ap = val,
            ),
            new SizedBox(
              height: 10.0,
            ),
            TextFormField(
              enabled: disabled3 ? false : true,
              controller: threecontroller,
              keyboardType: TextInputType.text,
              decoration:
              InputDecoration(labelText: "Student Maternal surname"),
              validator: (val) =>
              val.length == 0 ? 'Enter Maternal surname' : null,
              onSaved: (val) => am = val,
            ),
            new SizedBox(
              height: 10.0,
            ),
            TextFormField(
              enabled: disabled4 ? false : true,
              controller: fourcontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Student Phone"),
              validator: (val) => val.length == 0 ? 'Enter phone' : null,
              onSaved: (val) => tel = val,
            ),
            new SizedBox(
              height: 10.0,
            ),
            TextFormField(
              enabled: disabled5 ? false : true,
              controller: fivecontroller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Student E-Mail"),
              validator: (val) => val.length == 0
                  ? 'Enter E-mail'
                  : val.contains("@") == false ? "Not a valid E-mail" : null,
              onSaved: (val) => email = val,
            ),
            new SizedBox(
              height: 10.0,
            ),
            TextFormField(
              enabled: disabled6 ? false : true,
              controller: sixcontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Student Enrollment"),
              validator: (val) => val.length == 0 ? 'Enter Enrollment' : null,
              onSaved: (val) => clave = val,
            ),
            new SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: sevencontroller,
              decoration: InputDecoration(labelText: "Student Image" , suffixIcon: IconButton(
                  icon: Icon(Icons.add), onPressed: _optionsDialogBox),
              ),
              validator: (val) => val.length == 0 ? 'Enter Image' : val.length > 0 ?
              sevencontroller.text == "Archivo Imagen Estudiante" ? null : "Solo se puede imagenes" : null,
            ),
            SizedBox(height: 30),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  color: Colors.indigoAccent,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.indigoAccent),
                  ),
                  onPressed: busquedaMatriculaInsert,
                  child: Text(isUpdating == true ? 'Update' : 'Add Data'),
                ),
                MaterialButton(
                  color: Colors.indigoAccent,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.indigoAccent),
                  ),
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    cleanData();
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldkey,
      appBar: new AppBar(
        title: Text('Insert Operation',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            form(),
            //list(),
          ],
        ),
      ),
    );
  }

  _showSnackbar(BuildContext context, String texto) {
    final snackBar = SnackBar(
        backgroundColor: Colors.indigoAccent,
        content: new Text(texto,
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Schyler',
              fontWeight: FontWeight.bold,
            )));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}
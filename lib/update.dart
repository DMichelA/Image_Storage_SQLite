import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'students.dart';
import 'dart:async';
import 'convertidor.dart';
import 'package:image_picker/image_picker.dart';

class homePageupdate extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePageupdate> {
  //Variables referentes al manejo de la BD
  Future<List<Student>> Studentss;
  TextEditingController controller = TextEditingController();
  TextEditingController controllerimagen = TextEditingController();

  String name;
  String ap;
  String am;
  String tel;
  String email;
  String clave;
  String imagenString;

  int currentUserId;
  int op;
  String valor;

  String descriptive_text = "Student Name";

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating; //Saber el estado actual de la consulta
  bool change;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    change = true;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = dbHelper.getStudents();
    });
  }

  void updated() {
    setState(() {
      _showSnackbar(context, "Updated Data!");
    });
  }

  void cleanData() {
    controller.text = "";
    controllerimagen.text = "";
  }

  pickImagefromGallery(){
    ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640).then((imgFile){
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      imagenString = imgString;
      controllerimagen.text = "Archivo Imagen Estudiante";
      valor = imgString;
      return valor;
    });
  }

  pickImagefromCamera(){
    ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640).then((imgFile){
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      imagenString = imgString;
      controllerimagen.text = "Archivo Imagen Estudiante";
      valor = imgString;
      return valor;
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

  void updateData(){
    print("Valor de Opción");
    print(op);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(name);
      print(ap);
      print(am);
      print(tel);
      print(email);
      print(clave);
      print(imagenString);
      print(valor);
      if (op==1) {
        Student stu = Student(currentUserId, valor, ap, am, tel, email, clave, imagenString);
        dbHelper.update(stu);
      }
      else if (op==2) {
        Student stu = Student(currentUserId, name, valor, am, tel, email, clave, imagenString);
        dbHelper.update(stu);
      }
      else if (op==3) {
        Student stu = Student(currentUserId, name, ap, valor, tel, email, clave, imagenString);
        dbHelper.update(stu);
      }
      else if (op==4) {
        Student stu = Student(currentUserId, name, ap, am, valor, email, clave, imagenString);
        dbHelper.update(stu);
      }
      else if (op==5) {
        Student stu = Student(currentUserId, name, ap, am, tel, valor, clave, imagenString);
        dbHelper.update(stu);
      }
      else if (op==6) {
        Student stu = Student(currentUserId, name, ap, am, tel, email, valor, imagenString);
        dbHelper.update(stu);
      }
      else if (op==7) {
        Student stu = Student(currentUserId, name, ap, am, tel, email, clave, valor);
        dbHelper.update(stu);
      }
      cleanData();
      refreshList();
      updated();
    }
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
            new SizedBox(height: 50.0),
            TextFormField(
              enabled: true,
              controller: change ? controller : controllerimagen,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: descriptive_text , suffixIcon: IconButton(
                  icon: Icon(Icons.add), onPressed: _optionsDialogBox),),
              validator: (val) => change == false ? val.length == 0 ? 'Enter Data' : controllerimagen.text != "Archivo Imagen Estudiante"
                  ? "Solo se puede imagenes" : null : val.length == 0 ? 'Enter Data' : null,
              onSaved: (val) => change ? valor = controller.text : valor = imagenString,
            ),
            SizedBox(height: 30,),
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
                  onPressed: updateData,
                  //child: Text(isUpdating  ? 'Update Data' : 'Add Data'),
                  child: Text(isUpdating ? 'Update Data' : 'Select a Field'),
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
                    refreshList();
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
          DataCell(Text(student.name.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              change = true;
              descriptive_text = "Name";
              currentUserId = student.controlnum;
              name = student.name;
              ap = student.ap;
              am = student.am;
              tel = student.tel;
              email = student.email;
              clave = student.clave;
              imagenString = student.photoName;
              op=1;
            });
            controller.text = student.name;
          }),
          DataCell(Text(student.ap.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              change = true;
              descriptive_text = "P-Surname";
              currentUserId = student.controlnum;
              name = student.name;
              ap = student.ap;
              am = student.am;
              tel = student.tel;
              email = student.email;
              clave = student.clave;
              imagenString = student.photoName;
              op=2;
            });
            controller.text = student.ap;
          }),
          DataCell(Text(student.am.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              change = true;
              descriptive_text = "M-Surname";
              currentUserId = student.controlnum;
              name = student.name;
              ap = student.ap;
              am = student.am;
              tel = student.tel;
              email = student.email;
              clave = student.clave;
              imagenString = student.photoName;
              op=3;
            });
            controller.text = student.am;
          }),
          DataCell(Text(student.tel.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              change = true;
              descriptive_text = "Phone";
              currentUserId = student.controlnum;
              name = student.name;
              ap = student.ap;
              am = student.am;
              tel = student.tel;
              email = student.email;
              clave = student.clave;
              imagenString = student.photoName;
              op=4;
            });
            controller.text = student.tel;
          }),
          DataCell(Text(student.email.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              change = true;
              descriptive_text = "E-Mail";
              currentUserId = student.controlnum;
              name = student.name;
              ap = student.ap;
              am = student.am;
              tel = student.tel;
              email = student.email;
              clave = student.clave;
              imagenString = student.photoName;
              op=5;
            });
            controller.text = student.email;
          }),
          DataCell(Text(student.clave.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              change = true;
              descriptive_text = "Enrollment";
              currentUserId = student.controlnum;
              name = student.name;
              ap = student.ap;
              am = student.am;
              tel = student.tel;
              email = student.email;
              clave = student.clave;
              imagenString = student.photoName;
              op=6;
            });
            controller.text = student.clave;
          }),
          DataCell(Convertir.imageFromBase64String(student.photoName), onTap: () {
            setState(() {
              isUpdating = true;
              change = false;
              descriptive_text = "Image";
              currentUserId = student.controlnum;
              name = student.name;
              ap = student.ap;
              am = student.am;
              tel = student.tel;
              email = student.email;
              clave = student.clave;
              imagenString = student.photoName;
              op=7;
            });
            _optionsDialogBox;
            controllerimagen.text = "Archivo Imagen Estudiante";
          }),
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
      resizeToAvoidBottomPadding: false,
      key: _scaffoldkey,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: Text('Update Operation',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
            list(),
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

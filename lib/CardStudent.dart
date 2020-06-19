import 'package:flutter/material.dart';
import 'package:imagestorage/results.dart';
import 'students.dart';
import 'convertidor.dart';

class SendCard extends StatelessWidget {
  final Student stu;

  SendCard(this.stu);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.indigoAccent,
        appBar: AppBar(
          automaticallyImplyLeading: false, //Quitar boton retroceso
          title: Text(
            "About Me",
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black26,
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width - 19,
              left: 10.0,
              top: MediaQuery.of(context).size.height * 0.10,
              child: Container(
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          height: 200.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 5.0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              backgroundImage:
                              Convertir.imageFromBase64String(stu.photoName)
                                  .image,
                            ),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        RaisedButton.icon(
                          onPressed: (){},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          label: Text(stu.name+" "+stu.ap+" " +stu.am.toString(),
                            style: TextStyle(color: Colors.black, fontSize: 20.0,),),
                          icon: Icon(Icons.person, color:Colors.black,),
                          textColor: Colors.white,
                        ),
                        new Padding(
                          padding: EdgeInsets.all(4.0),
                        ),
                        RaisedButton.icon(
                          onPressed: (){},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          label: Text(stu.tel,
                            style: TextStyle(color: Colors.black, fontSize: 20.0,),),
                          icon: Icon(Icons.phone, color:Colors.black,),
                          textColor: Colors.white,
                        ),
                        new Padding(
                          padding: EdgeInsets.all(4.0),
                        ),
                        RaisedButton.icon(
                          onPressed: (){},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          label: Text(stu.email,
                            style: TextStyle(color: Colors.black, fontSize: 20.0,),),
                          icon: Icon(Icons.mail, color:Colors.black,),
                          textColor: Colors.white,
                        ),
                        new Padding(
                          padding: EdgeInsets.all(4.0),
                        ),
                        RaisedButton.icon(
                          onPressed: (){},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          label: Text(stu.clave,
                            style: TextStyle(color: Colors.black, fontSize: 20.0,),),
                          icon: Icon(Icons.assignment_ind, color:Colors.black,),
                          textColor: Colors.white,
                        ),
                        new Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

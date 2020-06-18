import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'students.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'controlnum';
  static const String NAME = 'name';
  static const String AP = 'ap';
  static const String AM = 'am';
  static const String TEL = 'tel';
  static const String EMAIL = 'email';
  static const String CLAVE = 'clave';
  static const String photoName = 'photoName';
  static const String TABLE = 'Students';
  static const String DB_NAME = 'students02.db';

  //Creacion de la base de datos (Verificar existencia)
  Future<Database> get db async {
    //Si diferente de null retornara la base de datos
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;

    }
  }

  //Database Creation
  initDb() async {
    io.Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory);
    String path = join(appDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, $AP TEXT, $AM TEXT, $TEL TEXT, $EMAIL TEXT, $CLAVE TEXT, $photoName BLOB)");
  }

  //Select
  Future<List<Student>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, AP, AM, TEL, EMAIL, CLAVE, photoName]);
    List<Student> studentss = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        studentss.add(Student.fromMap(maps[i]));
      }
    }
    return studentss;
  }

  //Save o Insert
  Future<Student> insert (Student student) async{
    var dbClient = await db;
    student.controlnum = await dbClient.insert(TABLE, student.toMap());
    return student;
  }

  //Delete
  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  //Update
  Future<int> update(Student student) async{
    var dbClient = await db;
    return await dbClient.update(TABLE, student.toMap(),
        where: '$ID = ?', whereArgs: [student.controlnum]);
  }

  //Busqueda matricula
  Future<List> busqueda() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, AP, AM, TEL, EMAIL, CLAVE]);
    List matricula = [];
    List<Student> String = [];
    for (int i = 0; i < maps.length; i++) {
      matricula.add(maps[i]['clave']);
    }
    return matricula;
  }

  //Select LIKE
  Future<List<Student>>getNameStudent(String letra) async {
    var dbClient = await db;
    //Busque Student cuyo nombre inicie con letra proporcionada
    List<Map> maps  = await dbClient.rawQuery("SELECT * FROM $TABLE WHERE $NAME LIKE '$letra%'");
    List<Student> studentss = [];
    print(maps);
    if (maps.length > 0){
      for (int i = 0; i<maps.length; i++){
        studentss.add(Student.fromMap(maps[i]));
      }
    }
    return studentss;
  }


  //Close Database
  Future closedb()async{
    var dbClient = await db;
    dbClient.close();
  }
}



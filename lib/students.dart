class Student{
  int controlnum;
  String name;
  String ap;
  String am;
  String tel;
  String email;
  String clave;
  String photoName;

  Student (this.controlnum, this.name, this.ap, this.am, this.tel, this.email, this.clave, this.photoName);
  Map<String,dynamic>toMap(){
    var map = <String,dynamic>{
      'controlnum': controlnum,
      'name': name,
      'ap': ap,
      'am': am,
      'tel': tel,
      'email': email,
      'clave': clave,
      'photoName' : photoName,
    };
    return map;
  }
  Student.fromMap(Map<String,dynamic> map){
    controlnum = map['controlnum'];
    name = map['name'];
    ap = map['ap'];
    am = map['am'];
    tel = map['tel'];
    email = map['email'];
    clave = map['clave'];
    photoName = map['photoName'];
  }
}
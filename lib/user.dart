import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class User{
  String _email;
  String _password;
  String _name;
  String _type;
  String _ic; 
  String _uid;
  static String currentUserName='genbingS';
  static String currentUserEmail='genbingS@hotmail.com';
  User(this._email, this._password, this._name, this._type, this._ic);
  Future <bool> registerUser() async{
    try{
      AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      FirebaseUser currentUser=result.user;
      Firestore.instance.collection('User').document(currentUser.uid).setData(
        {'Email':this._email, 'Password': this._password,'Name':this._name, 'Type':this._type, 'IC':this._ic}
        );
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
  String getType(){
    return _type;
  }
  String displayUser(){
    return 'Email: $_email \nName: $_name \nRole: $_type';
  }
  String getEmail(){
    return _email;
  }

  Future <bool> deleteUser(String uid) async{
    try{
      Firestore.instance.collection('User').document(uid).delete();
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
  
  void setUID(String _uid){
    this._uid=_uid;
  }
  String getUID(){
    return _uid;
  }
}

class Student extends User{
  String _faculty;
  String _major;
  int _year;
  Student(String _email, String _password, String _name, String _type, String _ic, this._faculty, this._major, this._year)
  :super(_email, _password, _name, _type, _ic);
  @override
  Future <bool> registerUser() async{
    if (await super.registerUser()==false)
      return false;
    try{
      final FirebaseUser currentUser=await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection('User').document(currentUser.uid).updateData(
        {'Faculty':this._faculty, 'Major':this._major, 'Year':this._year}
        );
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }
}

class Lecturer extends User{
  String _faculty;
  String _position;
  Lecturer(String _email, String _password, String _name, String _type, String _ic, this._faculty, this._position)
  :super(_email, _password, _name, _type, _ic);
  @override
  Future <bool> registerUser() async{
    if (await super.registerUser()==false)
      return false;
    try{
      final FirebaseUser currentUser=await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection('User').document(currentUser.uid).updateData(
        {'Faculty':this._faculty, 'Position':this._position}
        );
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }
}

class Parent extends User{
  String _childName;
  Parent(String _email, String _password, String _name, String _type, String _ic, this._childName)
  :super(_email, _password, _name, _type, _ic);
  @override
  Future <bool> registerUser() async{
    if (await super.registerUser()==false)
      return false;
    try{
      final FirebaseUser currentUser=await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection('User').document(currentUser.uid).updateData(
        {'ChildName':this._childName}
        );
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }
}

class Admin extends User{
  String _position;
  Admin(String _email, String _password, String _name, String _type, String _ic, this._position)
  :super(_email, _password, _name, _type, _ic);
  @override
  Future <bool> registerUser() async{
    if (await super.registerUser()==false)
      return false;
    try{
      final FirebaseUser currentUser=await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection('User').document(currentUser.uid).updateData(
        {'Position':this._position}
        );
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }
}
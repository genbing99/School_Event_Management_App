import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/eventMainPage.dart';
import 'screenSize.dart';
import 'registerPage.dart';
import 'eventMainPage.dart';
import 'forgetPasswordPage.dart';
import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  bool _isLoading=false;
  final formKey = GlobalKey<FormState>();
  String _email='';
  String _password='';
  static FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  @override
  void initState() {
    super.initState();
    _read();
  }
  void _loginFromCache() async{
    setState( (){
      _isLoading=true;
    });
    bool b = await _loginUser(_email, _password);
    setState( ()=> _isLoading=false);
    if (b==true){
      _save();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => EventMainPage()));
    }
  }
  Future <bool> _loginUser(String email, String password) async{
    try{
      assert(email!=null);
      AuthResult result=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,password: password);
      FirebaseUser user=result.user;
      if (user==null)
        return false;
      final FirebaseUser currentUser=await _auth.currentUser();
      assert(user.uid==currentUser.uid);
      Firestore.instance.collection('User').snapshots().listen((data){
        data.documents.forEach((doc) {
          if (doc['Email']==email){
            User.currentUserName=doc['Name'];
            User.currentUserEmail=doc['Email'];
          }
        });});
      return true;
    }on PlatformException catch(e)//Login Error
    {
      print(e);
      return false;
    }
  }
  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'emailKey';
    final key1 = 'passwordKey';
    prefs.setString(key, _email);
    prefs.setString(key1, _password);
  }
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'emailKey';
    final key1 = 'passwordKey';
    final value = prefs.getString(key) ?? 0;
    final value1 = prefs.getString(key1) ?? 0;
    if (value!=0)
      _email=value;
    if (value1!=0)
      _password=value1;
    if (value!=0 && value1!=0 && _email.length>0 && _email.length>0)
      _loginFromCache();
  }
  @override
  Widget build(BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar:AppBar(title:Text("Login Page")),
      body: 
      Container(
        height : SizeConfig.blockSizeVertical * 100,
        width : SizeConfig.blockSizeHorizontal * 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage("assets/Front.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
        child:Form(
          key:formKey,
        child:_isLoading
          ? CircularProgressIndicator()
          :ListView(
            children: <Widget>[
              new Column(
                children:<Widget>[
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                    height : SizeConfig.blockSizeVertical * 20,
                    width : SizeConfig.blockSizeHorizontal * 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: new AssetImage("assets/DreamEvent.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    height : SizeConfig.blockSizeVertical * 52,
                    width : SizeConfig.blockSizeHorizontal * 88,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.0)),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8, left: SizeConfig.blockSizeHorizontal*3),
                              height : SizeConfig.blockSizeVertical * 6,
                              width : SizeConfig.blockSizeHorizontal * 25,
                              child: Text('Email:', style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3,),textAlign: TextAlign.center,)
                            ),
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 6),
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 55,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.white, 
                              ),
                              child: TextFormField(
                              decoration: InputDecoration(labelText: ''),
                              validator: (val) => !EmailValidator.validate(val, true)
                                  ? 'Not a valid email.'
                                  : null,
                              onSaved: (val) => _email = val,
                            ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3, left: SizeConfig.blockSizeHorizontal*3),
                              height : SizeConfig.blockSizeVertical * 6,
                              width : SizeConfig.blockSizeHorizontal * 25,
                              child: Text('Password:', style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),)
                            ),
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 55,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.white,
                              ),
                              child:TextFormField(
                                decoration: InputDecoration(labelText: ''),
                                onSaved: (val) => _password = val,
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                        Container(                
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                          height : SizeConfig.blockSizeVertical * 5,
                          width : SizeConfig.blockSizeHorizontal * 27,
                          child: RaisedButton(
                            child:Text("Login"),
                            color:Colors.blue,
                            onPressed: () async {
                              if (formKey.currentState.validate()){
                                formKey.currentState.save();
                                setState( (){
                                  _isLoading=true;
                                });
                                bool b = await _loginUser(_email, _password);
                                setState( ()=> _isLoading=false);
                                if (b==true){
                                  _save();
                                  Navigator.of(context).push(MaterialPageRoute<Null>(
                                    builder: (BuildContext context){
                                      return new EventMainPage();
                                    }));
                                } else{
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Invalid email or password")));
                                  }
                                }
                              },
                            ),
                        ),
                        Container(                
                          height : SizeConfig.blockSizeVertical * 5,
                          width : SizeConfig.blockSizeHorizontal * 27,
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                          child: RaisedButton(
                            child:Text("Register"),
                            color:Colors.green,
                            onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute<Null>(
                                  builder: (BuildContext context){
                                    return new RegisterPage();
                                  }));
                            },
                            ),
                        ),
                        Container(                
                          height : SizeConfig.blockSizeVertical * 5,
                          width : SizeConfig.blockSizeHorizontal * 50,
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                          child: RaisedButton(
                            child:Text("Forgot Password ?"),
                            color:Colors.grey.withOpacity(0.1),
                            onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute<Null>(
                                  builder: (BuildContext context){
                                    return new ForgetPasswordPage();
                                  }));
                            },
                            ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
          ),])
      ),
      )
    ));
  }
}

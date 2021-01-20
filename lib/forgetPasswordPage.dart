import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'screenSize.dart';

class ForgetPasswordPage extends StatefulWidget{
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>{
  String _email, _ic, _myPassword;
  int _wrongPw=0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  Future getPassword() async{
    Firestore.instance.collection('User').snapshots().listen((data){
      data.documents.forEach((doc) {
        if (doc['Email']==_email)
          if (doc['IC']==_ic){
            if (mounted)
              setState((){
                _myPassword=doc['Password'];
              });
          }
          else
            setState(()=>_wrongPw=1);
        
  });});
  }
  @override
  Widget build(BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar:AppBar(title:Text("Forget Password Page")),
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
        child: ListView(
          children: <Widget>[
            new Column(
              children:<Widget>[
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                  height : SizeConfig.blockSizeVertical * 9,
                  width : SizeConfig.blockSizeHorizontal * 80,
                  child:Text(
                    'Forget Password?',
                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height : SizeConfig.blockSizeVertical * 6,
                  width : SizeConfig.blockSizeHorizontal * 80,
                  child:Text(
                    'Please enter the email that you had registered.',
                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.6),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8, left: SizeConfig.blockSizeHorizontal*3),
                      height : SizeConfig.blockSizeVertical * 6,
                      width : SizeConfig.blockSizeHorizontal * 30,
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
                      validator: (String val) {
                        if (val.length<1)
                          return 'Please enter your email';
                        else 
                          return null;
                      },
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
                      width : SizeConfig.blockSizeHorizontal * 30,
                      child: Text('IC/Passport:', style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),)
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
                        onSaved: (val) => _ic = val,
                      ),
                    ),
                    
                  ],
                ),
                Container(                
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                  height : SizeConfig.blockSizeVertical * 5,
                  width : SizeConfig.blockSizeHorizontal * 40,
                  child: RaisedButton(
                    child:Text("Get Password"),
                    color:Colors.blue.withOpacity(0.6),
                    onPressed: () async {
                      if (formKey.currentState.validate()){
                        formKey.currentState.save();
                        getPassword();
                        if (_wrongPw==1){
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Please retry, Email or IC is wrong")));
                          setState(()=>_wrongPw=0);
                        }
                      }
                    }
                  ),
                ),
                ConditionalBuilder(
                  condition: (_myPassword!=null),
                  builder: (context){
                    return Container(
                      height : SizeConfig.blockSizeVertical * 7,
                      width : SizeConfig.blockSizeHorizontal * 60,
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10),
                      child: Text(
                        'Your Password: $_myPassword',style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3)

                      )
                    );
                }),
              ]
        )]))
        )
    ));
  }
}

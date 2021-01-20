import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'screenSize.dart';
import 'loginPage.dart';
import 'user.dart';
import 'package:conditional_builder/conditional_builder.dart';

class RegisterPage extends StatefulWidget{
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  String _email, _password, _name, _type, _ic;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title:Text("Register Page")),
      body:Container(
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
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 70,
                    child:Text(
                      'Create Account',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Container(
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                    decoration: InputDecoration(labelText: '**Email'),
                    validator: (val) => !EmailValidator.validate(val, true)
                        ? 'Not a valid email.'
                        : null,
                    onSaved: (val) => _email = val,
                  ),
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child:TextFormField(
                      decoration: InputDecoration(labelText: '**Password'),
                      validator: (String val){
                        if (val.length<8)
                          return 'At least 8 characters long!'; 
                        else 
                          return null;
                      },
                      onSaved: (val) => _password = val,
                      obscureText: true,
                    ),
                  ),
                Container(
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child:TextFormField(
                      decoration: InputDecoration(labelText: '**Name'),
                      onSaved: (val) => _name = val,
                      validator: (String val){
                        if (val.length<1)
                          return 'Please enter this field';
                        else
                          return null;
                      }
                    ),
                  ),
                Container(
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child:TextFormField(
                      decoration: InputDecoration(labelText: '**IC/Passport Num'),
                      onSaved: (val) => _ic= val,
                      validator: (String val){
                        if (val.length<1)
                          return 'Please enter this field';
                        else
                          return null;
                      }
                    ),
                  ),
                Container(
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: DropdownButton<String>(
                      hint: Text('**Please choose your role'), 
                      value: _type,
                      onChanged: (newValue) {
                        setState(() {
                          _type = newValue;
                        });
                      },
                      items: <String>['Student', 'Lecturer', 'Parent', 'Admin'].map<DropdownMenuItem<String>>((String _type){
                        return DropdownMenuItem<String>(
                          value: _type,
                          child: Text(_type),
                        );
                      }).toList(),
                    ),
                  ),
                Container(                
                    height : SizeConfig.blockSizeVertical * 5,
                    width : SizeConfig.blockSizeHorizontal * 25,
                    child: RaisedButton(
                      child:Text("Continue"),
                      color:Colors.blue,
                      onPressed: () async {
                        if (formKey.currentState.validate() && _type!=null ){
                          formKey.currentState.save();
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new RegisterPageTwo(_email, _password, _name, _type, _ic);
                          }));
                      }
                      else
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Please enter all required information")));
                      }
                      ),
                  ),
              ]
        )])))
    ));
  }
}

class RegisterPageTwo extends StatefulWidget{
  final String email, password, name, type, ic;
  RegisterPageTwo(this.email, this.password, this.name, this.type, this.ic);
  @override
  _RegisterPageTwoState createState() => _RegisterPageTwoState();
}

class _RegisterPageTwoState extends State<RegisterPageTwo>{
  List inputList = new List(3);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    List fieldNameList = createfieldNameList(widget.type);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title:Text("Register Page Two")),
      body:Container(
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
        child: ListView( //Prevent bottom overflow
          children: <Widget>[
            new Column(
              children:<Widget>[
                Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                    height : SizeConfig.blockSizeVertical * 15,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child:Text(
                      widget.type,
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 6, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Container(
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child:TextFormField(
                      decoration: InputDecoration(labelText: fieldNameList[0]),
                      onSaved: (val) => inputList[0]=val,
                    ),
                  ),
                ConditionalBuilder(
                  condition: (widget.type=='Lecturer' || widget.type=='Student'),
                  builder: (context){
                      return Container(
                        height : SizeConfig.blockSizeVertical * 10,
                        width : SizeConfig.blockSizeHorizontal * 60,
                        child:TextFormField(
                        decoration: InputDecoration(labelText: fieldNameList[1]),
                        onSaved: (val) => inputList[1]=val,
                    ),
                  );
                  },
                ),
                ConditionalBuilder(
                  condition: (widget.type=='Student'),
                  builder: (context){
                      return Container(
                        height : SizeConfig.blockSizeVertical * 10,
                        width : SizeConfig.blockSizeHorizontal * 60,
                        child:TextFormField(
                        decoration: InputDecoration(labelText: fieldNameList[2]),
                        onSaved: (val) => inputList[2]=val,
                    ),
                  );
                  },
                ),
                Container(                
                    height : SizeConfig.blockSizeVertical * 5,
                    width : SizeConfig.blockSizeHorizontal * 25,
                    child: RaisedButton(
                      child:Text("Sign Up"),
                      color:Colors.blue,
                      onPressed: () async {
                        if (formKey.currentState.validate()){
                          formKey.currentState.save();
                          User currentUser;
                          if (widget.type=='Lecturer')
                            currentUser = new Lecturer(widget.email, widget.password, widget.name, widget.type, widget.ic, inputList[0], inputList[1]);
                          else if (widget.type=='Student')
                            currentUser = new Student(widget.email, widget.password, widget.name, widget.type, widget.ic, inputList[0], inputList[1], int.parse(inputList[2]));
                          else if (widget.type=='Parent')
                            currentUser = new Parent(widget.email, widget.password, widget.name, widget.type, widget.ic, inputList[0]);
                          else 
                            currentUser = new Admin(widget.email, widget.password, widget.name, widget.type, widget.ic, inputList[0]);
                          bool b = await currentUser.registerUser();
                          if (b==true){
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context){
                                return new LoginPage();
                              }));
                          } else{
                            _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Repeated Email! Please change your email")));
                          }}}
                      ),
                  ),
              ]
        )])))
    ));
  }
  List createfieldNameList(String role)
  {
    List fieldNameList = new List(3);
    if (role=='Lecturer'){
      fieldNameList[0]='Faculty';
      fieldNameList[1]='Position';
    }
    else if (role=='Student'){
      fieldNameList[0]='Faculty';
      fieldNameList[1]='Major';
      fieldNameList[2]='Year Intake';
    }
    else if (role=='Parent'){
      fieldNameList[0]='Child\'s Name';
    }
    else{
      fieldNameList[0]='Position';
    }
    return fieldNameList;
  } 
}

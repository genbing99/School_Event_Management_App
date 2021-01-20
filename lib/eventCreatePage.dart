import 'package:flutter/material.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'notificationPage.dart';
import 'profilePage.dart';
import 'resourcesPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'event.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'team.dart';
import 'user.dart';

class EventCreatePage extends StatefulWidget{
  @override
  _EventCreatePageState createState() => _EventCreatePageState();
}

class _EventCreatePageState extends State<EventCreatePage>
{
  String _teamID, _role, _userEmail=User.currentUserEmail;
  var userEmailList= new List<String>();
  var _addedUserEmailList=new List<String>();
  var _addedUserRoleList=new List<String>();
  var _teamIDController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  int index=0;
  @override
  void initState(){
    super.initState();
    getUserList();
    _userEmail=User.currentUserEmail;
  }
  Future getUserList() async{
    Firestore.instance.collection('User').snapshots().listen((data) =>
        data.documents.forEach((doc) {
        
        setState(()=>userEmailList.add(doc['Email']));
        }));
  }
  @override
  Widget build (BuildContext context){
    SizeConfig().init(context);
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        title: new Image.asset('assets/Dream.png',
              fit: BoxFit.cover,
        ),
        backgroundColor: Color(0xFFFFFFFF),
        actions: [
          new IconButton(
            icon: Image.asset('assets/QRScan.png'),
            tooltip: 'QR Code', //Change
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new QRPage();
                            }));
            },
          ),
          new IconButton(
            icon: Image.asset('assets/ChatRoom.png'),
            tooltip: 'Chat Room', //Change
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new ChatRoomPage();
                            }));
            },
          )
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (int index) {
            switch (index){
            case 0:  Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new EventMainPage();//Change
                            }));
                    break;
            case 1:  Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new NotificationPage();//Change
                            }));
                    break;
            case 2:  Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new ResourcesPage();//Change
                            }));
                    break;
            case 3: Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new ProfilePage1();//Change
                            }));
                    break;
            }
          },
        items:[
          BottomNavigationBarItem(
           icon: Image.asset('assets/Event.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Event'),
         ),
         BottomNavigationBarItem(
           icon: Image.asset('assets/Notification.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Notification'),
         ),
         BottomNavigationBarItem(
           icon: Image.asset('assets/Resources.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Resource'),
         ),
         BottomNavigationBarItem(
           icon: Image.asset('assets/Profile.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Profile'),
         ),
         
        ]
      ),
      body:Container(
        height : SizeConfig.blockSizeVertical * 100,
        width : SizeConfig.blockSizeHorizontal * 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage("assets/Event.jpg"),
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
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child:Text(
                      'Create Event',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Container(
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                    decoration: InputDecoration(labelText: '**Team ID'),
                    controller: _teamIDController,
                    onSaved: (val) => _teamID = val,
                    validator: (String val){
                        if (val.length<1)
                          return 'Please enter this field';
                        else
                          return null;
                    }
                  ),
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 5,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    margin: EdgeInsets.only(right: SizeConfig.blockSizeVertical * 15),
                    child:Text(
                      'Team Member',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                ),
                ConditionalBuilder(
                  condition: (_userEmail.length>0),
                  builder: (context){
                    return Container(
                        height : SizeConfig.blockSizeVertical * 7,
                        width : SizeConfig.blockSizeHorizontal * 60,
                        child: DropdownButton<String>(
                          hint: Text('User Email'), 
                          value: _userEmail,
                          onChanged: (newValue) {
                            setState(() {
                              _userEmail = newValue;
                            });
                          },
                          items: userEmailList.map<DropdownMenuItem<String>>((String _userEmail){
                            return DropdownMenuItem<String>(
                              value: _userEmail,
                              child: Text(_userEmail),
                            );
                          }).toList(),
                        ),
                      );
                  }),
                Container(
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                    decoration: InputDecoration(labelText: 'Role'),
                    onSaved: (val) => _role = val,
                  ),
                ),
                new Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                      height : SizeConfig.blockSizeVertical * 7,
                      width : SizeConfig.blockSizeHorizontal * 60,
                      child:Text(
                        'Member List',
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height : SizeConfig.blockSizeVertical * 5,
                      width : SizeConfig.blockSizeHorizontal * 25,
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      child: RaisedButton(
                        child:Text("Add"),
                        color:Colors.blue,
                        onPressed: () async{
                          if (formKey.currentState.validate()){
                          formKey.currentState.save();
                          setState((){
                            _addedUserEmailList.add(_userEmail);
                            _addedUserRoleList.add(_role);
                            formKey.currentState.reset();
                            userEmailList.remove(_userEmail);
                            _userEmail=userEmailList[0];
                            _teamIDController.text=_teamID;
                            });
                          } else{
                            _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Please enter valid information")));
                            }
                        }
                      ),
                    ),
                  ]
                ),
                ConditionalBuilder(
                  condition: (_addedUserEmailList.length>0),
                  builder: (context){
                    return Container(
                      height : SizeConfig.blockSizeVertical * 20,
                      width : SizeConfig.blockSizeHorizontal * 75,
                      child: ListView.builder(
                        itemCount:_addedUserEmailList.length,
                        itemBuilder: (context, i) {
                          return ListTile(title: Text("${i+1} . ${_addedUserEmailList[i]}"));}),
                    );
                  },
                ),
                ConditionalBuilder(
                  condition: (_addedUserEmailList.length>0),
                  builder: (context){
                    return Container(
                      height : SizeConfig.blockSizeVertical * 5,
                      width : SizeConfig.blockSizeHorizontal * 25,
                      margin: EdgeInsets.only(left: SizeConfig.blockSizeVertical * 30),
                      child: RaisedButton(
                        child:Text("Continue"),
                        color:Colors.green,
                        onPressed:() {
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context){
                                  return new EventCreatePageTwo(_addedUserEmailList, _addedUserRoleList, _teamID);
                          }));
                        }
                      ),
                    );
                  }
                ),
              ]
        )])))
    ));
  }
}

class EventCreatePageTwo extends StatefulWidget{
  final String _teamID;
  final List<String> _addedUserEmailList;
  final List<String> _addedUserRoleList;
  EventCreatePageTwo(this._addedUserEmailList, this._addedUserRoleList, this._teamID);
  @override
  _EventCreatePageTwoState createState() => _EventCreatePageTwoState();
}

class _EventCreatePageTwoState extends State<EventCreatePageTwo>
{
  FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadPic(_eventID) async {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);  
      StorageReference reference = _storage.ref().child(_eventID);
      StorageUploadTask uploadTask = reference.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String location = await taskSnapshot.ref.getDownloadURL();
      print(location);
      return location.toString();
   }
  int index=0;
  String _imageUrl="", _type, _name, _eventID="event", _description;
  int _maxSubgroup, _maxSubgroupMember;
  double _fees;
  DateTime _startTime, _endTime;
  TextEditingController eventIDController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  final format = DateFormat("yyyy-MM-dd HH:MM");
  @override
  Widget build (BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        title: new Image.asset('assets/Dream.png',
              fit: BoxFit.cover,
        ),
        backgroundColor: Color(0xFFFFFFFF),
        actions: [
          new IconButton(
            icon: Image.asset('assets/QRScan.png'),
            tooltip: 'QR Code', //Change
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new QRPage();
                            }));
            },
          ),
          new IconButton(
            icon: Image.asset('assets/ChatRoom.png'),
            tooltip: 'Chat Room', //Change
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new ChatRoomPage();
                            }));
            },
          )
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (int index) {
            switch (index){
            case 0:  Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new EventMainPage();//Change
                            }));
                    break;
            case 1:  Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new NotificationPage();//Change
                            }));
                    break;
            case 2:  Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new ResourcesPage();//Change
                            }));
                    break;
            case 3: Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new ProfilePage1();//Change
                            }));
                    break;
            }
          },
        items:[
          BottomNavigationBarItem(
           icon: Image.asset('assets/Event.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Event'),
         ),
         BottomNavigationBarItem(
           icon: Image.asset('assets/Notification.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Notification'),
         ),
         BottomNavigationBarItem(
           icon: Image.asset('assets/Resources.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Resource'),
         ),
         BottomNavigationBarItem(
           icon: Image.asset('assets/Profile.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Profile'),
         ),
         
        ]
      ),
      body:Container(
        height : SizeConfig.blockSizeVertical * 100,
        width : SizeConfig.blockSizeHorizontal * 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage("assets/Event.jpg"),
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
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3), 
                    height : SizeConfig.blockSizeVertical * 5,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child:Text(
                      'Create Event',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: DropdownButton<String>(
                      hint: Text('**Event Type'), 
                      value: _type,
                      onChanged: (newValue) {
                        setState(() {
                          _type = newValue;
                        });
                      },
                      items: <String>['Engineering', 'IT', 'Language', 'Management', 'Multimedia', 'Science'].map<DropdownMenuItem<String>>((String _type){
                        return DropdownMenuItem<String>(
                          value: _type,
                          child: Text(_type),
                        );
                      }).toList(),
                    ),
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                    decoration: InputDecoration(labelText: '**Event Name'),
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
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                    controller: eventIDController,
                    decoration: InputDecoration(labelText: '**Event ID'),
                    onSaved: (val) => _eventID = val,
                    
                    validator: (String val){
                        if (val.length<1)
                          return 'Please enter this field';
                        else
                          return null;
                    }
                  ),
                ),
                new Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 12), 
                      height : SizeConfig.blockSizeVertical * 5,
                      width : SizeConfig.blockSizeHorizontal * 30,
                      child:Text(
                        'Start Time: ',
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height : SizeConfig.blockSizeVertical * 6,
                      width : SizeConfig.blockSizeHorizontal * 45,
                      child: DateTimeField(
                        format: format,
                        onShowPicker: (context, currentValue) async{
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2019),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2030));
                          if (date!=null){
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(currentValue??DateTime.now()),
                            );
                            setState(() {
                              _startTime=DateTimeField.combine(date,time);
                            });
                            print(_startTime);
                            return _startTime;
                          }
                          else {
                            return currentValue;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 12), 
                      height : SizeConfig.blockSizeVertical * 5,
                      width : SizeConfig.blockSizeHorizontal * 30,
                      child:Text(
                        'End Time: ',
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height : SizeConfig.blockSizeVertical * 7,
                      width : SizeConfig.blockSizeHorizontal * 45,
                      child: DateTimeField(
                        format: format,
                        onShowPicker: (context, currentValue) async{
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2019),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2030));
                          if (date!=null){
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(currentValue??DateTime.now()),
                            );
                            setState(() {
                              _endTime=DateTimeField.combine(date,time);
                            });
                            print(_endTime);
                            return _endTime;
                          }
                          else {
                            return currentValue;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 6,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText:"**Fees per admission: RM", 
                          hintText: "0.0",
                      ),
                      onSaved: (val) => _fees = double.parse(val)
                  )
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                    decoration: InputDecoration(labelText: '**Event Description'),
                    onSaved: (val) => _description = val,
                    validator: (String val){
                        if (val.length<1)
                          return 'Please enter this field';
                        else
                          return null;
                    }
                  ),
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 6,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText:"**Max Subgroup, 0 if not allowed", 
                          hintText: "0",
                      ),
                      onSaved: (val) => _maxSubgroup = int.parse(val)
                  )
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 6,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText:"**Max Subgroup Member", 
                          hintText: "0",
                      ),
                      onSaved: (val) => _maxSubgroupMember = int.parse(val)
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 0.5), 
                  height : SizeConfig.blockSizeVertical * 5,
                  width : SizeConfig.blockSizeHorizontal * 40,
                  child: RaisedButton(
                    child:Text("**Event Poster File"), 
                    color:Colors.grey,
                    onPressed:() async{
                      _imageUrl = await uploadPic(eventIDController.text);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Image submit successfully")));
                    }
                  )
                ),
                Container(
                    margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 0.5, left:SizeConfig.blockSizeHorizontal * 40),                 
                    height : SizeConfig.blockSizeVertical * 5,
                    width : SizeConfig.blockSizeHorizontal * 25,
                    child: RaisedButton(
                      child:Text("Submit"),
                      color:Colors.blue,
                      onPressed: () async {
                        if (formKey.currentState.validate() && _startTime.isBefore(_endTime)){
                          formKey.currentState.save();
                          Event event = new Event(_eventID, _name, _startTime, _endTime, _fees, _type, _description, widget._teamID, _imageUrl, _maxSubgroup, _maxSubgroupMember);
                          event.storeEvent();
                          Team team = new Team(_eventID, widget._addedUserEmailList, widget._addedUserRoleList);
                          team.storeTeam();
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new EventMainPage();
                            }));
                      }
                      else
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Please check your input before submit")));
                      }
                      ),
                  ),
            ]
        )])))
    ));
  }
}

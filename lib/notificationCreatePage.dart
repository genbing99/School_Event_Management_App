import 'package:flutter/material.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'profilePage.dart';
import 'resourcesPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'notificationPage.dart';
import 'user.dart';
import 'notification.dart';

class NotificationCreatePage extends StatefulWidget{
  @override
  _NotificationCreatePageState createState() => _NotificationCreatePageState();
}

class _NotificationCreatePageState extends State<NotificationCreatePage>{
  int index=0;
  int _notiLevel=0;
  String _description;
  final formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
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
            image: new AssetImage("assets/NotificationBG.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      child: Center(
        child:Form(
        key:formKey,
        child: ListView(
          children:<Widget>[
            new Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                  child:Text(
                      'Create Notification',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                ),
                Container(
                  height : SizeConfig.blockSizeVertical * 3,
                  width : SizeConfig.blockSizeHorizontal * 75,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 4, left: SizeConfig.blockSizeHorizontal * 3), 
                  child:Text(
                      'Enter Notification Details:',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.7),
                      textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height : SizeConfig.blockSizeVertical * 27,
                  width : SizeConfig.blockSizeHorizontal * 75,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3, top: SizeConfig.blockSizeVertical * 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 15,
                    decoration: InputDecoration(labelText: ''),
                    validator: (String val){
                        if (val.length<1)
                          return 'Please enter this field';
                        else if (val.length>120)
                          return 'Exceed Maximum 120 characters';
                        else
                          return null;
                    },
                    onSaved: (val) => _description = val
                  ),
                ),
                Container(
                  height : SizeConfig.blockSizeVertical * 3,
                  width : SizeConfig.blockSizeHorizontal * 75,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3), 
                  child:Text(
                      '**Maximum 5 lines',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.7),
                      textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height : SizeConfig.blockSizeVertical * 3,
                  width : SizeConfig.blockSizeHorizontal * 75,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 4, left: SizeConfig.blockSizeHorizontal * 3), 
                  child:Text(
                      'Notification Level:',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.7),
                      textAlign: TextAlign.left,
                    ),  
                ),
                new Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                          Container(
                            height : SizeConfig.blockSizeVertical * 3,
                            width : SizeConfig.blockSizeHorizontal * 15,
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2,left: SizeConfig.blockSizeHorizontal * 7), 
                            child: Radio(
                            value: 1,
                            groupValue: _notiLevel,
                            onChanged: (int val) => setState(()=> _notiLevel=val),
                          ),
                          ),
                          Container(
                            height : SizeConfig.blockSizeVertical * 3,
                            width : SizeConfig.blockSizeHorizontal * 60,
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                            child: Text(
                            'Critical',
                            style: new TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),
                          ),
                          )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            height : SizeConfig.blockSizeVertical * 3,
                            width : SizeConfig.blockSizeHorizontal * 15,
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1,left: SizeConfig.blockSizeHorizontal * 7), 
                            child: Radio(
                            value: 2,
                            groupValue: _notiLevel,
                            onChanged: (int val) => setState(()=> _notiLevel=val),
                          ),
                          ),
                          Container(
                            height : SizeConfig.blockSizeVertical * 3,
                            width : SizeConfig.blockSizeHorizontal * 60,
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1), 
                            child: Text(
                            'Important/Reminder',
                            style: new TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),
                          ),
                          )
                      ]
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            height : SizeConfig.blockSizeVertical * 3,
                            width : SizeConfig.blockSizeHorizontal * 15,
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1,left: SizeConfig.blockSizeHorizontal * 7), 
                            child: Radio(
                            value: 3,
                            groupValue: _notiLevel,
                            onChanged: (int val) => setState(()=> _notiLevel=val),
                          ),
                          ),
                          Container(
                            height : SizeConfig.blockSizeVertical * 3,
                            width : SizeConfig.blockSizeHorizontal * 60,
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1), 
                            child: Text(
                            'Normal/Announcement',
                            style: new TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),
                          ),
                          )
                      ]
                    ),
                    
                  ],
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 5,
                    width : SizeConfig.blockSizeHorizontal * 25,
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    child: RaisedButton(
                      child:Text("Submit"),
                      color:Colors.blue.withOpacity(0.6),
                      onPressed: () async{
                        if (formKey.currentState.validate() && _notiLevel!=0){
                          formKey.currentState.save();
                          Notification1 notification = new Notification1(User.currentUserEmail, _notiLevel,_description);
                          notification.storeNotification();
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new NotificationPage();
                          }));
                        } else{
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Please enter all required information")));
                        }
                    }
                  ),
                ),
              ],
            )
          ]
        )
      )
    )));
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'notificationPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'resourcesPage.dart';
import 'profilePage.dart';
import 'user.dart';
import 'profileAttendingEventPage.dart';
import 'profileLentItemPage.dart';
import 'profileBorrowedItem.dart';
import 'profileManageEvent.dart';
import 'profileManageUser.dart';
import 'loginPage.dart';

class ProfilePage extends StatefulWidget{
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  int index=3;
  var _userList = new List<User>();
  User _userCurrent;
  @override
  void initState(){
    super.initState();
    getUserList();
  }
  Future getUserList() async{
    String _email, _password, _name, _type, _ic, _faculty, _major, _position, _childName;
    int _year;
    User user;
    Firestore.instance.collection('User').snapshots().listen((data){
      data.documents.forEach((doc) {
        _email=doc['Email'];
        _password=doc['Password'];
        _name=doc['Name'];
        _type=doc['Type'];
        _ic=doc['IC'];
        if (_type=='Admin'){
          _position=doc['Position'];
          user = new Admin(_email, _password, _name, _type, _ic, _position);
        }
        else if(_type=='Student'){
          _major=doc['Major'];
          _year=doc['Year'];
          _faculty=doc['Faculty'];
          user = new Student(_email, _password, _name, _type, _ic, _faculty, _major, _year);
        }
        else{
          _childName=doc['ChildName'];
          user = new Parent(_email, _password, _name, _type, _ic, _childName);
        }
        _userList.add(user);
        if (User.currentUserEmail==doc['Email']){
          setState(()=>_userCurrent=user);
        }
      });});
  }
  @override
  Widget build (BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
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
            image: new AssetImage("assets/ProfileBG.png"),
            fit: BoxFit.fill,
          ),
        ),
      child: Center(
        child: ListView(
          children:<Widget>[
            new Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 3), 
                  child:Text(
                      User.currentUserName,
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 5),
                      textAlign: TextAlign.center,
                    ),
                ),
                Container(
                  margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 2), 
                  child:Text(
                      User.currentUserEmail,
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2),
                      textAlign: TextAlign.center,
                    ),
                ),
                ConditionalBuilder(
                  condition: (_userCurrent!=null),
                  builder: (context){
                    return Container(
                      margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 3), 
                      height : SizeConfig.blockSizeVertical * 70,
                      width : SizeConfig.blockSizeHorizontal * 70,
                      child: new Column(
                        children: <Widget>[
                          Container(
                            height : SizeConfig.blockSizeVertical * 5,
                            width : SizeConfig.blockSizeHorizontal * 80,
                            child: Text(
                              _userCurrent.getType(),
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3.5),
                              textAlign: TextAlign.center,
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3), 
                            child: FlatButton.icon(
                              label:Text('Attending Event'), //Change assets
                              icon: Image.asset('assets/AttendingEvent.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
                              onPressed:() {
                                Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context){
                                  return new ProfileAttendingEventPage();//Change
                                }));
                                
                              },
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                            child: FlatButton.icon(
                              label:Text('Lent Item'), //Change assets
                              icon: Image.asset('assets/LentItem.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
                              onPressed:() {
                                Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context){
                                  return new ProfileLentItemPage();//Change
                                }));
                                
                              },
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                            child: FlatButton.icon(
                              label:Text('Borrowed Item'), //Change assets
                              icon: Image.asset('assets/BorrowedItem.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
                              onPressed:() {
                                Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context){
                                  return new ProfileBorrowedItemPage();//Change
                                }));
                                
                              },
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                            child: FlatButton.icon(
                              label:Text('Log Out'), //Change assets
                              icon: Image.asset('assets/LogOut.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
                              onPressed:() {
                                Navigator
                                .of(context)
                                .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                              },
                              )
                          ),
                          ConditionalBuilder(
                            condition: (_userCurrent.getType()=='Admin'),
                            builder: (context){
                              return Container(
                                margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 1), 
                                height : SizeConfig.blockSizeVertical * 20,
                                width : SizeConfig.blockSizeHorizontal * 80,
                                child: new Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                                      child: FlatButton.icon(
                                        label:Text('Manage User'), //Change assets
                                        icon: Image.asset('assets/ManageUser.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
                                        onPressed:() {
                                          Navigator.of(context).push(MaterialPageRoute<Null>(
                                          builder: (BuildContext context){
                                            return new ProfileManageUserPage();//Change
                                          }));
                                
                                        },
                                        )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                                      child: FlatButton.icon(
                                        label:Text('Manage Event'), //Change assets
                                        icon: Image.asset('assets/ManageEvent.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
                                        onPressed:() {
                                          Navigator.of(context).push(MaterialPageRoute<Null>(
                                          builder: (BuildContext context){
                                            return new ProfileManageEventPage();//Change
                                          }));
                                
                                        },
                                        )
                                    ),
                                  ]
                              ),
                            );
                          }),
                        ]
                      ),
                      
                    );
                }),
              ],
            )
          ]
        )
      )
    ));
  }
}
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

class ProfileManageUserPage extends StatefulWidget{
  @override
  _ProfileManageUserPageState createState() => _ProfileManageUserPageState();
}

class _ProfileManageUserPageState extends State<ProfileManageUserPage>{
  int index=3;
  var _userList = new List<User>();
  var _duplicateUserList = new List<User>();
  @override
  void initState(){
    super.initState();
    getUserList();
  }
  Future getUserList() async{
  String _email, _password, _name, _type, _ic;
    Firestore.instance.collection('User').snapshots().listen((data){
        data.documents.forEach((doc) {
          _email=doc['Email'];
          _name = doc['Name'];
          _password=doc['Password'];
          _type=doc['Type'];
          _ic=doc['IC'];
          User user = new Student(_email, _password, _name, _type, _ic, '', '', 0);
          user.setUID(doc.documentID);
          setState(()=>_userList.add(user));
          _duplicateUserList.add(user);
  });});}
  void filterSearchResults(String query) {
    List<User> dummySearchList = List<User>();
    dummySearchList.addAll(_userList);
    if(query.isNotEmpty) {
      List<User> dummyListData = List<User>();
      dummySearchList.forEach((item) {
        if(item.getEmail().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _userList.clear();
        _userList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _userList.clear();
        _userList.addAll(_duplicateUserList);
      });
    }

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
            child:Form(
            child: ListView(
              children:<Widget>[
                new Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 3), 
                      child:Text(
                          'Manage User',
                          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal * 6), 
                          child:Text(
                              'User Email:',
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                        ),
                        Container(
                          height : SizeConfig.blockSizeVertical * 4,
                          width : SizeConfig.blockSizeHorizontal * 45,
                          margin: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal * 4, top:SizeConfig.blockSizeHorizontal*1), 
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          child: TextField(
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    ConditionalBuilder(
                      condition: (_userList.length>0),
                      builder: (context){
                        return Container(
                          height : SizeConfig.blockSizeVertical * 65,
                          width : SizeConfig.blockSizeHorizontal * 90,
                          child: ListView.builder(
                            itemCount:_userList.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                title: new Container(
                                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                                  height : SizeConfig.blockSizeVertical * 11,
                                  width : SizeConfig.blockSizeHorizontal * 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*0.5, top: SizeConfig.blockSizeVertical*0.5),
                                        height : SizeConfig.blockSizeVertical * 11,
                                        width : SizeConfig.blockSizeHorizontal * 50,
                                        child: Text(
                                        '${_userList[i].displayUser()}',
                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.0),
                                        textAlign: TextAlign.left,
                                        )
                                      ),
                                      Container(
                                        height : SizeConfig.blockSizeVertical * 7,
                                        width : SizeConfig.blockSizeHorizontal * 30,
                                        child: FlatButton.icon(
                                          label:Text(''),
                                          icon: Image.asset('assets/Delete.png', fit: BoxFit.fill, height : SizeConfig.blockSizeVertical * 5, width : SizeConfig.blockSizeHorizontal * 9,),
                                          onPressed:() {
                                            _userList[i].deleteUser(_userList[i].getUID());
                                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                            builder: (BuildContext context){
                                              return new ProfileManageUserPage();//Change
                                            }));
                                          },
                                        )
                                      ),
                                  ],)
                                ),
                              );
                            }
                          ),
                        );
                    }),
                  ],
                )
              ]
            )
            )
          )
    ));
  }
}
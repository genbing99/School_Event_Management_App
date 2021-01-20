import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'notificationPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'resourcesPage.dart';
import 'profilePage.dart';
import 'user.dart';
import 'resources.dart';

class ProfileBorrowedItemPage extends StatefulWidget{
  @override
  _ProfileBorrowedItemPageState createState() => _ProfileBorrowedItemPageState();
}

class _ProfileBorrowedItemPageState extends State<ProfileBorrowedItemPage>{
  int index=3;
  var _resourcesList = new List<Resource>();
  final formatter = DateFormat("yyyy-MM-dd");
  @override
  void initState(){
    super.initState();
    getResourceList();
  }
  Color getEventColor(int i){
    if (_resourcesList[i].getLenderEmail().length>0)
      return Colors.grey.withOpacity(0.8);
    else
      return Colors.grey.withOpacity(0.4);
  }
  Future getResourceList() async{
    String _resourceID, _name, _type, _status, _borrowerEmail, _teamID, _userEmail;
    DateTime _expiredDate;
    Firestore.instance.collection('Resource').snapshots().listen((data){
        data.documents.forEach((doc) {
          _resourceID=doc.documentID;
          _name=doc['Name'];
          _type=doc['Type'];
          _status=doc['Status'];
          _borrowerEmail=doc['BorrowerEmail'];
          _teamID=doc['TeamID'];
          _userEmail=doc['LenderEmail'];
          _expiredDate= doc['ExpiredDate'].toDate();
          Resource resource = new Resource(_resourceID, _name, _type, _status, _expiredDate, _borrowerEmail, _teamID, _userEmail);
          if (_borrowerEmail==User.currentUserEmail){
            if (mounted)
              setState(()=>_resourcesList.add(resource));
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
                      'Borrowed Item',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                ),
                ConditionalBuilder(
                  condition: (_resourcesList.length>0),
                  builder: (context){
                    return Container(
                      height : SizeConfig.blockSizeVertical * 75,
                      width : SizeConfig.blockSizeHorizontal * 90,
                      child: ListView.builder(
                        itemCount:_resourcesList.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: new Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                              height : SizeConfig.blockSizeVertical * 16.5,
                              width : SizeConfig.blockSizeHorizontal * 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: getEventColor(i),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*0.5, top: SizeConfig.blockSizeVertical*0.5),
                                height : SizeConfig.blockSizeVertical * 16.5,
                                width : SizeConfig.blockSizeHorizontal * 60,
                                child: Text(
                                '${_resourcesList[i].displayBorrowedResources()}',
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.0),
                                textAlign: TextAlign.left,
                                )
                              ),
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
    ));
  }
}
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

class ProfileAttendingEventPage extends StatefulWidget{
  @override
  _ProfileAttendingEventPageState createState() => _ProfileAttendingEventPageState();
}

class _ProfileAttendingEventPageState extends State<ProfileAttendingEventPage>{
  int index=3;
  var _eventNameList1 = List<String>();
  var _eventStartTimeList1 = List<DateTime>();
  var _eventNameList = List<String>();
  var _eventStartTimeList = List<DateTime>();
  final formatter = DateFormat("yyyy-MM-dd");
  @override
  void initState(){
    super.initState();
    getEventList();
  }
  Future getAttendeeList(int i, String _eventID) async{
    Firestore.instance.collection('Event').document(_eventID).collection('Attendee').snapshots().listen((data){
      data.documents.forEach((doc) {
        if (User.currentUserEmail==doc.documentID){
          setState((){
            _eventNameList.add(_eventNameList1[i]);
            _eventStartTimeList.add(_eventStartTimeList1[i]);
          });
        }
      });});
  }
  Future getEventList() async{
    String _eventID;
    int i=0;
    Firestore.instance.collection('Event').snapshots().listen((data){
        data.documents.forEach((doc) {
          _eventID=doc.documentID;
          _eventNameList1.add(doc['Name']);
          _eventStartTimeList1.add(doc['StartTime'].toDate());
          getAttendeeList(i, _eventID);
          i++;
    });});
  }
  Color getEventColor(int i){
    if (_eventStartTimeList[i].isBefore(DateTime.now()))
      return Colors.grey.withOpacity(0.8);
    else
      return Colors.grey.withOpacity(0.4);
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
                      'Attending Event',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                ),
                ConditionalBuilder(
                  condition: (_eventNameList.length>0),
                  builder: (context){
                    return Container(
                      height : SizeConfig.blockSizeVertical * 75,
                      width : SizeConfig.blockSizeHorizontal * 90,
                      child: ListView.builder(
                        itemCount:_eventNameList.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: new Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                              height : SizeConfig.blockSizeVertical * 7,
                              width : SizeConfig.blockSizeHorizontal * 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: getEventColor(i),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2, top: SizeConfig.blockSizeVertical*0.5),
                                    height : SizeConfig.blockSizeVertical * 5,
                                    width : SizeConfig.blockSizeHorizontal * 48,
                                    child: Text(
                                    '${_eventNameList[i]}',
                                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.8),
                                    textAlign: TextAlign.left,
                                    )
                                  ),
                                  Spacer(),
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1, top: SizeConfig.blockSizeVertical*0.5),
                                    height : SizeConfig.blockSizeVertical * 4,
                                    width : SizeConfig.blockSizeHorizontal * 30,
                                    child: Text(
                                    '${formatter.format(_eventStartTimeList[i])}',
                                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.8),
                                    textAlign: TextAlign.left,
                                    )
                                  ),
                                ],
                              )
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
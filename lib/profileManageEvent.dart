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
import 'event.dart';

class ProfileManageEventPage extends StatefulWidget{
  @override
  _ProfileManageEventPageState createState() => _ProfileManageEventPageState();
}

class _ProfileManageEventPageState extends State<ProfileManageEventPage>{
  int index=3;
  var _eventList = new List<Event>();
  var _duplicateEventList = new List<Event>();
  @override
  void initState(){
    super.initState();
    getEventList();
  }
  Future getEventList() async{
  String _eventID, _name, _type, _description, _teamID, _image;
  DateTime _startTime, _endTime;
  int _maxSubgroup, _maxSubgroupMember;
  double _fees;
    Firestore.instance.collection('Event').snapshots().listen((data){
        data.documents.forEach((doc) {
          _eventID = doc.documentID;
          _name = doc['Name'];
          _description=doc['Description'];
          _endTime=doc['EndTime'].toDate();
          _fees = doc['Fees'];
          _image = doc['Image'];
          _maxSubgroup = doc['Max Subgroup'];
          _maxSubgroupMember=doc['MaxSubgroupMember'];
          _startTime=doc['StartTime'].toDate();
          _type=doc['Type'];
          _teamID=doc['TeamID'];
          Event event = new Event(_eventID, _name, _startTime, _endTime, _fees, _type, _description, _teamID, _image, _maxSubgroup, _maxSubgroupMember);
          if (mounted)
            setState(()=>_eventList.add(event));
          _duplicateEventList.add(event);
  });});}
  void filterSearchResults(String query) {
    List<Event> dummySearchList = List<Event>();
    dummySearchList.addAll(_eventList);
    if(query.isNotEmpty) {
      List<Event> dummyListData = List<Event>();
      dummySearchList.forEach((item) {
        if(item.getEventID().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _eventList.clear();
        _eventList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _eventList.clear();
        _eventList.addAll(_duplicateEventList);
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
            child: ListView(
              children:<Widget>[
                new Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 3), 
                      child:Text(
                          'Manage Event',
                          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal * 6), 
                          child:Text(
                              'Event ID:',
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
                      condition: (_eventList.length>0),
                      builder: (context){
                        return Container(
                          height : SizeConfig.blockSizeVertical * 65,
                          width : SizeConfig.blockSizeHorizontal * 90,
                          child: ListView.builder(
                            itemCount:_eventList.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                title: new Container(
                                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                                  height : SizeConfig.blockSizeVertical * 17.5,
                                  width : SizeConfig.blockSizeHorizontal * 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*0.5, top: SizeConfig.blockSizeVertical*0.5),
                                        height : SizeConfig.blockSizeVertical * 17.5,
                                        width : SizeConfig.blockSizeHorizontal * 50,
                                        child: Text(
                                        '${_eventList[i].displayManageList()}',
                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.0),
                                        textAlign: TextAlign.left,
                                        )
                                      ),
                                      Container(
                                        height : SizeConfig.blockSizeVertical * 7,
                                        width : SizeConfig.blockSizeHorizontal * 30,
                                        child: FlatButton.icon(
                                          label:Text(''),
                                          icon: Image.asset('assets/Delete.png', fit: BoxFit.fill, height : SizeConfig.blockSizeVertical * 6, width : SizeConfig.blockSizeHorizontal * 10,),
                                          onPressed:() {
                                            _eventList[i].deleteEvent();
                                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                            builder: (BuildContext context){
                                              return new ProfileManageEventPage();//Change
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
    );
  }
}
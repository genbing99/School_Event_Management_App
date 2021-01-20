import 'package:flutter/material.dart';
import 'screenSize.dart';
import 'notificationPage.dart';
import 'profilePage.dart';
import 'resourcesPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'eventCreatePage.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_image/network.dart';
import 'event.dart';
import 'eventJoinPage.dart';

class EventMainPage extends StatefulWidget{
  @override
  _EventMainPageState createState() => _EventMainPageState();
}

class _EventMainPageState extends State<EventMainPage>{
  int index=0;
  var _eventList = new List<Event>();
  var _duplicateEventList = new List<Event>();
  String _eventType;
  int _filter=0;
  @override
  void initState(){
    super.initState();
    getEventList();
  }
  void filterSearchResults(String query) {
    List<Event> dummySearchList = List<Event>();
    dummySearchList.addAll(_eventList);
    if(query.isNotEmpty) {
      List<Event> dummyListData = List<Event>();
      dummySearchList.forEach((item) {
        if(item.getType()==query) {
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
  Future getEventList() async{
    Firestore.instance.collection('Event').snapshots().listen((data){
        data.documents.forEach((doc) {
          Event event=new Event.empty(0);
          event.setEventID(doc.documentID);
          event.setName(doc['Name']);
          event.setDescription(doc['Description']);
          event.setEndTime(doc['EndTime'].toDate());
          event.setFees(doc['Fees']);
          event.setImage(doc['Image']);
          event.setMaxSubgroup(doc['Max Subgroup']);
          event.setMaxSubgroupMember(doc['MaxSubgroupMember']);
          event.setStartTime(doc['StartTime'].toDate());
          event.setType(doc['Type']);
          event.setTeamID(doc['TeamID']);
          _duplicateEventList.add(event);
          if (mounted)
            setState(()=>_eventList.add(event));
  });});}
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
            image: new AssetImage("assets/Event.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      child: Center(
        child: ListView(
          children:<Widget>[
            new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                      child: FlatButton.icon(
                        label:Text('Filter'), //Change assets
                        icon: Image.asset('assets/Filter.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
                        onPressed:() {
                          if (_filter==0)
                            setState(()=>_filter=1);
                          else
                            setState(()=>_filter=0);
                          },
                        )
                    ),
                    Spacer(),
                    Container(
                    child:Text(
                        'Event',
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                      child: FlatButton.icon(
                        label:Text('Add Event'), //Change assets
                        icon: Image.asset('assets/Event.png', width: SizeConfig.blockSizeHorizontal * 12, height:SizeConfig.blockSizeVertical * 6),
                        onPressed:() {
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context){
                                return new EventCreatePage();
                              }));
                          },
                        )
                    ),
                  ]
                ),
                ConditionalBuilder(
                  condition: (_filter==1),
                  builder: (context){
                    return Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      height : SizeConfig.blockSizeVertical * 40,
                      width : SizeConfig.blockSizeHorizontal * 90,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(0.2)),
                        color: Colors.blue.withOpacity(0.1),
                      ),
                      child:new Column(
                        children: <Widget>[
                          Container(
                            height : SizeConfig.blockSizeVertical * 3,
                            width : SizeConfig.blockSizeHorizontal * 80,
                            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2,left: SizeConfig.blockSizeHorizontal * 7), 
                            child: Text('Event Type', style: new TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.7),)
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                height : SizeConfig.blockSizeVertical * 3,
                                width : SizeConfig.blockSizeHorizontal * 15,
                                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2,left: SizeConfig.blockSizeHorizontal * 7), 
                                child: Radio(
                                  value: 'Engineering',
                                  groupValue: _eventType,
                                  onChanged: (String val) => setState(()=> _eventType=val),
                                ),
                              ),
                              Container(
                                height : SizeConfig.blockSizeVertical * 3,
                                width : SizeConfig.blockSizeHorizontal * 60,
                                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                                child: Text(
                                'Engineering',
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
                                  value: 'IT',
                                  groupValue: _eventType,
                                  onChanged: (String val) => setState(()=> _eventType=val),
                                ),
                                ),
                                Container(
                                  height : SizeConfig.blockSizeVertical * 3,
                                  width : SizeConfig.blockSizeHorizontal * 60,
                                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1), 
                                  child: Text(
                                  'IT',
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
                                  value: 'Language',
                                  groupValue: _eventType,
                                  onChanged: (String val) => setState(()=> _eventType=val),
                                ),
                                ),
                                Container(
                                  height : SizeConfig.blockSizeVertical * 3,
                                  width : SizeConfig.blockSizeHorizontal * 60,
                                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1), 
                                  child: Text(
                                  'Language',
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
                                  value: 'Management',
                                  groupValue: _eventType,
                                  onChanged: (String val) => setState(()=> _eventType=val),
                                ),
                                ),
                                Container(
                                  height : SizeConfig.blockSizeVertical * 3,
                                  width : SizeConfig.blockSizeHorizontal * 60,
                                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1), 
                                  child: Text(
                                  'Management',
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
                                  value: 'Multimedia',
                                  groupValue: _eventType,
                                  onChanged: (String val) => setState(()=> _eventType=val),
                                ),
                                ),
                                Container(
                                  height : SizeConfig.blockSizeVertical * 3,
                                  width : SizeConfig.blockSizeHorizontal * 60,
                                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1), 
                                  child: Text(
                                  'Multimedia',
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
                                  value: 'Science',
                                  groupValue: _eventType,
                                  onChanged: (String val) => setState(()=> _eventType=val),
                                ),
                                ),
                                Container(
                                  height : SizeConfig.blockSizeVertical * 3,
                                  width : SizeConfig.blockSizeHorizontal * 60,
                                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1), 
                                  child: Text(
                                  'Science',
                                  style: new TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),
                                ),
                                )
                            ]
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                height : SizeConfig.blockSizeVertical * 5,
                                width : SizeConfig.blockSizeHorizontal * 25,
                                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2, left: SizeConfig.blockSizeHorizontal*12),
                                child: RaisedButton(
                                  child:Text("Clear"),
                                  color:Colors.blue.withOpacity(0.4),
                                  onPressed: () async{
                                    setState((){
                                      _eventType='';
                                      _eventList.clear();
                                      _eventList.addAll(_duplicateEventList);
                                      });
                                }
                              ),
                              ),
                              Container(
                                height : SizeConfig.blockSizeVertical * 5,
                                width : SizeConfig.blockSizeHorizontal * 25,
                                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2, left: SizeConfig.blockSizeHorizontal*8),
                                child: RaisedButton(
                                  child:Text("Submit"),
                                  color:Colors.blue.withOpacity(0.4),
                                  onPressed: () async{
                                    setState(() {
                                     _eventList.clear();
                                     _eventList.addAll(_duplicateEventList);
                                    });
                                    filterSearchResults(_eventType);
                                }
                              ),
                              ),
                          ],)
                          
                        ],
                      ),
                    );
                  }
                ),
                
                ConditionalBuilder(
                  condition: (_eventList.length>0),
                  builder: (context){
                    return Container(
                      height : SizeConfig.blockSizeVertical * 70,
                      width : SizeConfig.blockSizeHorizontal * 95,
                      child: ListView.builder(
                        itemCount:_eventList.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: new FlatButton.icon(
                                label:Text(''),
                                icon: new Image(image:NetworkImageWithRetry(_eventList[i].getImage()), width: SizeConfig.blockSizeHorizontal * 70, height:SizeConfig.blockSizeVertical * 20, fit: BoxFit.fill),
                                onPressed:() {
                                  Navigator.of(context).push(MaterialPageRoute<Null>(
                                    builder: (BuildContext context){
                                      return new EventJoinPage(_eventList[i]);
                                    }));
                                },
                                )
                          );
                        }
                      ),
                    );
                  }
                ),
              ],
            )
          ]
        )
      )
    ));
  }
}

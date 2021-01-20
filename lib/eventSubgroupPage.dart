import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/subgroup.dart';
import 'package:flutter_app/subgroupMember.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'profilePage.dart';
import 'notificationPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'resourcesPage.dart';
import 'event.dart';
import 'eventSubgroupDetailsPage.dart';
import 'eventCreateSubgroupPage.dart';
import 'user.dart';

class EventSubgroupPage extends StatefulWidget{
  final Event _eventClicked;
  EventSubgroupPage(this._eventClicked);
  @override
  _EventSubgroupPageState createState() => _EventSubgroupPageState();
}

class _EventSubgroupPageState extends State<EventSubgroupPage>{
  int index=0;
  Subgroup _subgroupFirst;
  String _name;
  String _memberName;
  int _totalMember;
  var _subgroupList = new List<Subgroup>();
  @override
  void initState(){
    super.initState();
    getSubgroupList();
  }
  Future getSubgroupList() async{
    Firestore.instance.collection('Event').document(widget._eventClicked.getEventID()).collection('Subgroup').snapshots().listen((data){
        data.documents.forEach((doc) {
          _name = doc['Name'];
          _totalMember = doc['TotalMember'];
          Subgroup subgroup = new Subgroup(widget._eventClicked.getEventID(), _name, _totalMember);
          Firestore.instance.collection('Event').document(widget._eventClicked.getEventID()).collection('Subgroup').document(_name).collection('SubgroupMember').snapshots().listen((data){
              data.documents.forEach((doc) {
                _memberName = doc.documentID;
                SubgroupMember member = new SubgroupMember(widget._eventClicked.getEventID(), _memberName, _name);
                subgroup.addSubgroupMember(member);
                if (mounted)
                  setState(()=>_subgroupFirst=_subgroupList[0]);
              });});          
          _subgroupList.add(subgroup);
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
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child:Text(
                      'Event: ${widget._eventClicked.getName()}',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                    child: FlatButton.icon(
                      label:Text('Add'), //Change assets
                      icon: Image.asset('assets/Event.png', width: SizeConfig.blockSizeHorizontal * 15, height:SizeConfig.blockSizeVertical * 8),
                      onPressed:() {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new EventCreateSubgroupPage(widget._eventClicked);
                            }));
                        },
                      )
                  ),
                ]),
                ConditionalBuilder(
                  condition: (_subgroupFirst!=null),
                  builder: (context){
                    return Container(
                      height : SizeConfig.blockSizeVertical * 70,
                      width : SizeConfig.blockSizeHorizontal * 90,
                      child: ListView.builder(
                        itemCount:_subgroupList.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: new Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                              height : SizeConfig.blockSizeVertical * 9,
                              width : SizeConfig.blockSizeHorizontal * 40,
                              child: Row(
                                children: <Widget>[
                                  RaisedButton(
                                    color:Colors.grey.withOpacity(0.3),
                                    onPressed:() {
                                      Navigator.of(context).push(MaterialPageRoute<Null>(
                                        builder: (BuildContext context){
                                          return new EventSubgroupDetailsPage(_subgroupList[i]);
                                        }));
                                    },
                                    child:Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1, top: SizeConfig.blockSizeVertical*1),
                                          height : SizeConfig.blockSizeVertical * 4,
                                          width : SizeConfig.blockSizeHorizontal * 40,
                                          child: Text(
                                          '${_subgroupList[i].getName()}: ',
                                          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.7, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                          )
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1),
                                          height : SizeConfig.blockSizeVertical * 4,
                                          width : SizeConfig.blockSizeHorizontal * 40,
                                          child: Text(
                                            '${_subgroupList[i].getSubgroupMemberList().length}/${_subgroupList[i].getTotalMember()} Members',
                                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.7),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                    ],)
                                  ),
                                  Spacer(),
                                  FlatButton.icon(
                                    label:Text(''),
                                    icon: Image.asset('assets/JoinSubgroup.png', width: SizeConfig.blockSizeHorizontal * 15, height:SizeConfig.blockSizeVertical * 7, fit: BoxFit.fill),
                                    onPressed:() {
                                      SubgroupMember subgroupMember = new SubgroupMember(widget._eventClicked.getEventID(), User.currentUserName, _subgroupList[i].getName());
                                      subgroupMember.storeSubgroupMember();
                                      Navigator.of(context).push(MaterialPageRoute<Null>(
                                        builder: (BuildContext context){
                                          return new EventMainPage();
                                        }));
                                    },
                                  )
                              ],
                                
                              )
                            ),
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
    )));

  }
}
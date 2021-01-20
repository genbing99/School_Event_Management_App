import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'profilePage.dart';
import 'resourcesPage.dart';
import 'chatRoomPage.dart';
import 'notificationPage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'user.dart';
import 'QRPage.dart';

class QRGeneratePage extends StatefulWidget{
  @override
  _QRGeneratePageState createState() => _QRGeneratePageState();
}

class _QRGeneratePageState extends State<QRGeneratePage>{
  int index=0;
  String _eventID='';
  var _eventIDList = List<String>();
  var _eventIDList1 = List<String>();
  int _generateQR=0;
  @override
  void initState(){
    super.initState();
    getEventList();
  }
  Future getEventList() async{
    int i=0;
    String _eventID;
    Firestore.instance.collection('Event').snapshots().listen((data){
        data.documents.forEach((doc) {
          _eventID=doc.documentID;
          _eventIDList1.add(_eventID);
          getEventList1(i, _eventID);
          i++;
    });});
  }
  Future getEventList1(int i, String _eventID1)async{
    Firestore.instance.collection('Event').document(_eventID1).collection('Team').snapshots().listen((data){
      data.documents.forEach((doc) {
        if (User.currentUserEmail==doc['UserEmail']){
          _eventIDList.add(_eventIDList1[i]);
          setState(()=>_eventID=_eventIDList[0]);
      }});});
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
            image: new AssetImage("assets/QR.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      child:Center(
        child: Column(
          children: <Widget>[                  
            Row(
              children: <Widget>[
                ConditionalBuilder(
                  condition: (_eventID.length>0),
                  builder: (context){
                    return Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8), 
                      height : SizeConfig.blockSizeVertical * 5,
                      width : SizeConfig.blockSizeHorizontal * 40,
                      child : Text(
                        'Event ID:',
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),     
                ConditionalBuilder(
                  condition: (_eventID.length>0),
                  builder: (context){
                    return Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8), 
                      height : SizeConfig.blockSizeVertical * 5,
                      width : SizeConfig.blockSizeHorizontal * 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ),
                      child: DropdownButton<String>(
                        value: _eventID,
                        onChanged: (newValue) {
                          setState(() {
                            _eventID = newValue;
                          });
                        },
                        items: _eventIDList.map<DropdownMenuItem<String>>((String _eventID){
                          return DropdownMenuItem<String>(
                            value: _eventID,
                            child: Text(_eventID),
                          );
                        }).toList(),
                      ),
                    );
                  }),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 3, left:SizeConfig.blockSizeHorizontal * 40),                 
              height : SizeConfig.blockSizeVertical * 6,
              width : SizeConfig.blockSizeHorizontal * 25,
              child: RaisedButton(
                child:Text("Create",
                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),),
                color:Colors.green,
                onPressed: () async {
                  setState(()=>_generateQR=1);
                }
              ),
            ),
            ConditionalBuilder(
              condition: (_generateQR==1 && _eventID.length>0),
              builder: (context){
                return Container(
                  child: QrImage(
                    data: _eventID, size: SizeConfig.blockSizeVertical*40,
                  )
                );
            })
        ],),
      )
      ),
    );
  }
}
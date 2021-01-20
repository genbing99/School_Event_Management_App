import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/notificationCreatePage.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'profilePage.dart';
import 'resourcesPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'notification.dart';

class NotificationPage extends StatefulWidget{
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>{
  int index=1;
  Notification1 _notificationFirst;
  var _notificationList = List<Notification1>();
  @override
  void initState(){
    super.initState();
    getNotificationList();
  }
  Future getNotificationList() async{
    int _notiLevel;
    String _issuerEmail, _description;
    Firestore.instance.collection('Notification').snapshots().listen((data){
        data.documents.forEach((doc) {
          _issuerEmail = doc['IssuerEmail'];
          _notiLevel = doc['Level'];
          _description = doc['Details'];
          Notification1 notification = new Notification1(_issuerEmail, _notiLevel, _description);
          _notificationList.add(notification);
          setState(()=>_notificationFirst=_notificationList[0]);
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
            image: new AssetImage("assets/NotificationBG.jpg"),
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
                      margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 15), 
                      child:Text(
                          'Notification',
                          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                      child: FlatButton.icon(
                        label:Text('Add'), //Change assets
                        icon: Image.asset('assets/Event.png', width: SizeConfig.blockSizeHorizontal * 14, height:SizeConfig.blockSizeVertical * 8),
                        onPressed:() {
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context){
                                return new NotificationCreatePage();
                              }));
                          },
                      )
                    ),
                  ],
                ),
                ConditionalBuilder(
                  condition: (_notificationFirst!=null),
                  builder: (context){
                    return Container(
                      height : SizeConfig.blockSizeVertical * 65,
                      width : SizeConfig.blockSizeHorizontal * 90,
                      child: ListView.builder(
                        itemCount:_notificationList.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: new Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                              height : SizeConfig.blockSizeVertical * 16.5,
                              width : SizeConfig.blockSizeHorizontal * 90,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.grey.withOpacity(0.6),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*0.5, top: SizeConfig.blockSizeVertical*0.5),
                                    height : SizeConfig.blockSizeVertical * 16.5,
                                    width : SizeConfig.blockSizeHorizontal * 60,
                                    child: Text(
                                    '${_notificationList[i].getDetails()}',
                                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),
                                    textAlign: TextAlign.left,
                                    )
                                  ),
                                  ConditionalBuilder(
                                    condition: (_notificationList[i].getLevel()==1),
                                    builder: (context){
                                      return Container(
                                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                        height : SizeConfig.blockSizeVertical * 7,
                                        width : SizeConfig.blockSizeHorizontal * 13,
                                        child: Image.asset('assets/NotificationCritical.png', fit: BoxFit.fill,),
                                      );
                                    }
                                  ),
                                  ConditionalBuilder(
                                    condition: (_notificationList[i].getLevel()==2),
                                    builder: (context){
                                      return Container(
                                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                        height : SizeConfig.blockSizeVertical * 7,
                                        width : SizeConfig.blockSizeHorizontal * 13,
                                        child: Image.asset('assets/NotificationImportant.png', fit: BoxFit.fill,),
                                      );
                                    }
                                  ),
                                  ConditionalBuilder(
                                    condition: (_notificationList[i].getLevel()==3),
                                    builder: (context){
                                      return Container(
                                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2.5),
                                        height : SizeConfig.blockSizeVertical * 7,
                                        width : SizeConfig.blockSizeHorizontal * 13,
                                        child: Image.asset('assets/NotificationNormal.png', fit: BoxFit.fill,),
                                      );
                                    }
                                  ),
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
      )
    ));
  }
}
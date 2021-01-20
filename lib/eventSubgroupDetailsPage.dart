import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'profilePage.dart';
import 'notificationPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'resourcesPage.dart';
import 'subgroup.dart';

class EventSubgroupDetailsPage extends StatefulWidget{
  final Subgroup _subgroup;
  EventSubgroupDetailsPage(this._subgroup);
  @override
  _EventSubgroupDetailsPageState createState() => _EventSubgroupDetailsPageState();
}

class _EventSubgroupDetailsPageState extends State<EventSubgroupDetailsPage>{
  int index=0;
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
              Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                height : SizeConfig.blockSizeVertical * 7,
                width : SizeConfig.blockSizeHorizontal * 60,
                child:Text(
                  'Event: ${widget._subgroup.getName()}',
                  style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              ConditionalBuilder(
                  condition: (widget._subgroup.getSubgroupMemberList().length>0),
                  builder: (context){
                    return Container(
                      height : SizeConfig.blockSizeVertical * 70,
                      width : SizeConfig.blockSizeHorizontal * 95,
                      child: ListView.builder(
                        itemCount:widget._subgroup.getSubgroupMemberList().length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title:  Text(
                                '${i+1}. ${widget._subgroup.getSubgroupMemberList()[i].getName()}',
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3),
                              ),
                          );
                        }
                      ),
                    );
                  }
                ),
            ]
          )
        )
      )
      );
  }
}
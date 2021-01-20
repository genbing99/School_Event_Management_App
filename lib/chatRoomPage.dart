import 'package:flutter/material.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'profilePage.dart';
import 'resourcesPage.dart';
import 'QRPage.dart';
import 'notificationPage.dart';

class ChatRoomPage extends StatefulWidget{
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage>{
  int index=0;
  String _message;
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
        child: Center(
          child: ListView(
            children:<Widget>[
              new Column(
                children: <Widget>[
                  Container(
                    height : SizeConfig.blockSizeVertical * 70,
                    width : SizeConfig.blockSizeHorizontal * 100,
                    child:(
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Spacer(),
                              Container(
                                height : SizeConfig.blockSizeVertical * 5.5,
                                width : SizeConfig.blockSizeHorizontal * 70,
                                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1, top: SizeConfig.blockSizeVertical * 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: Colors.blue.withOpacity(0.8),
                                ),
                                child: Text('Problem regarding log in issue, emergency'),
                              ),
                              Container(
                                height : SizeConfig.blockSizeVertical * 5.5,
                                width : SizeConfig.blockSizeHorizontal * 10,
                                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1, top: SizeConfig.blockSizeVertical * 8),
                                child: Text('ME'),
                              ),
                          ],),
                          Row(
                            children: <Widget>[
                              Container(
                                height : SizeConfig.blockSizeVertical * 5.5,
                                width : SizeConfig.blockSizeHorizontal * 14,
                                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4, top: SizeConfig.blockSizeVertical * 5),
                                child: Text('Admin'),
                              ),
                              Container(
                                height : SizeConfig.blockSizeVertical * 5.5,
                                width : SizeConfig.blockSizeHorizontal * 70,
                                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1, top: SizeConfig.blockSizeVertical * 2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: Colors.blue.withOpacity(0.8),
                                ),
                                child: Text('Good Afternoon, may I know in details?'),
                              ),
                              Spacer(),
                          ],)
                      ],)
                    )
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height : SizeConfig.blockSizeVertical * 4,
                        width : SizeConfig.blockSizeHorizontal * 70,
                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10, top: SizeConfig.blockSizeVertical * 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                        decoration: InputDecoration(labelText: 'Message'),
                        onSaved: (val) => _message = val
                        ),
                      ),
                      Spacer(),
                      Container(                
                        height : SizeConfig.blockSizeVertical * 5,
                        width : SizeConfig.blockSizeHorizontal * 18,
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                        child: RaisedButton(
                          shape: new CircleBorder(),
                          child:Text("SEND",
                          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.6, fontWeight: FontWeight.bold),
                          ),
                          color:Colors.green.withOpacity(0.7),
                          onPressed: () async {
                          },
                          ),
                      ),
                    ]
                  ),
          ],)])
          )
      ),
      
    );
  }
}
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
import 'user.dart';

class EventCreateSubgroupPage extends StatefulWidget{
  final Event _eventClicked;
  EventCreateSubgroupPage(this._eventClicked);
  @override
  _EventCreateSubgroupPageState createState() => _EventCreateSubgroupPageState();
}

class _EventCreateSubgroupPageState extends State<EventCreateSubgroupPage>{
  int index=0;
  String _name;
  int _totalMember;
  final formKey = GlobalKey<FormState>();
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
        child:Form(
        key:formKey,
        child: ListView(
          children: <Widget>[
            new Column(
              children:<Widget>[
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                  height : SizeConfig.blockSizeVertical * 7,
                  width : SizeConfig.blockSizeHorizontal * 80,
                  child:Text(
                    'Create Subgroup',
                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7), 
                  height : SizeConfig.blockSizeVertical * 4,
                  width : SizeConfig.blockSizeHorizontal * 80,
                  child:Text(
                    'Subgroup Name:',
                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.5),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                    onSaved: (val) => _name = val,
                    validator: (String val){
                        if (val.length<1)
                          return 'Please enter this field';
                        else
                          return null;
                    }
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7), 
                  height : SizeConfig.blockSizeVertical * 4,
                  width : SizeConfig.blockSizeHorizontal * 80,
                  child:Text(
                    'Total Number of Members:',
                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _totalMember = int.parse(val),
                      validator: (String val){
                        if (val.length<1)
                          return 'Please enter this field';
                        else if (int.parse(val)>widget._eventClicked.getMaxSubgroupMember())
                          return 'Exceed maximum members allowed';
                        else
                          return null;
                    }
                  ),
                ),
                Container(                
                    height : SizeConfig.blockSizeVertical * 6,
                    width : SizeConfig.blockSizeHorizontal * 25,
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                    child: RaisedButton(
                      child:Text("SUBMIT",
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.6, fontWeight: FontWeight.bold),
                      ),
                      color:Colors.blue.withOpacity(0.5),
                      onPressed: () {
                        if (formKey.currentState.validate()){
                          formKey.currentState.save();
                          Subgroup subgroup = new Subgroup(widget._eventClicked.getEventID(), _name, _totalMember);
                          subgroup.storeSubgroup();
                          SubgroupMember subgroupMember = new SubgroupMember(widget._eventClicked.getEventID(), User.currentUserName, _name);
                          subgroupMember.storeSubgroupMember();
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new EventMainPage();
                            }));
                        }
                      },
                      ),
                  ),
            ]
        )])))
    ));
    
  }
}
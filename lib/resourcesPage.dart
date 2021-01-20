import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'profilePage.dart';
import 'notificationPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'package:intl/intl.dart';
import 'resources.dart';
import 'user.dart';

class ResourcesPage extends StatefulWidget{
  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage>{
  int pageChange=1;
  int index=2;
  var _teamIDList = List<String>();
  var _teamIDList1 = List<String>();
  var _resourcesList = List<Resource>();
  Resource _resourceFirst;
  final format = DateFormat("yyyy-MM-dd");
  String _itemID, _teamID='', _itemName, _itemType;
  DateTime _expiredDate;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  @override
  void initState(){
    super.initState();
    getResourcesList();
    getTeamList();
  }
  Future getResourcesList() async{
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
          if (DateTime.now().isBefore(_expiredDate) && _status=='Waiting'){
            _resourcesList.add(resource);
            if (mounted)
              setState(()=>_resourceFirst=_resourcesList[0]);
          }
    });});
  }
  Future getTeamList() async{
    String _eventID;
    int i=0;
    Firestore.instance.collection('Event').snapshots().listen((data){
        data.documents.forEach((doc) {
          _eventID=doc.documentID;
          _teamIDList1.add(doc['TeamID']);
          getTeamList1(i, _eventID);
          i++;
    });});
  }
  Future getTeamList1(int i, String _eventID)async{
    Firestore.instance.collection('Event').document(_eventID).collection('Team').snapshots().listen((data){
      data.documents.forEach((doc) {
        if (User.currentUserEmail==doc['UserEmail']){
          _teamIDList.add(_teamIDList1[i]);
          setState(()=>_teamID=_teamIDList[0]);
        }
      });});
  }

  @override
  Widget build (BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
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
            image: new AssetImage("assets/ResourcesBG.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      child: Center(
        child:Form(
        key:formKey,
        child: ListView(
          children:<Widget>[
            new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    Container(
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 49.5,
                    child: RaisedButton(
                      child:Text("LEND",
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3, fontWeight: FontWeight.bold),
                      ),
                      color:Colors.green.withOpacity(0.4),
                      onPressed: () async{
                        setState(()=>pageChange=1);
                        }
                      ),
                    ),
                    Spacer(),
                    Container(
                    height : SizeConfig.blockSizeVertical * 10,
                    width : SizeConfig.blockSizeHorizontal * 49.5,
                    child: RaisedButton(
                      child:Text("REQUEST",
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3, fontWeight: FontWeight.bold),),
                      color:Colors.green.withOpacity(0.4),
                      onPressed: () async{
                        if (_teamIDList.length<1)
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("You are not member of any event team")));
                        else
                          setState(()=>pageChange=2);
                      }
                      ),
                    ),
                  ],
                ),
                ConditionalBuilder(
                  condition: (pageChange==1),
                  builder: (context){
                    return Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                          height : SizeConfig.blockSizeVertical * 7,
                          width : SizeConfig.blockSizeHorizontal * 60,
                          child:Text(
                            'Lend Item',
                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ConditionalBuilder(
                          condition: (_resourceFirst!=null),
                          builder: (context){
                            return Container(
                              height : SizeConfig.blockSizeVertical * 55,
                              width : SizeConfig.blockSizeHorizontal * 90,
                              child: ListView.builder(
                                itemCount:_resourcesList.length,
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
                                            margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1, top: SizeConfig.blockSizeVertical*0.5),
                                            height : SizeConfig.blockSizeVertical * 16.5,
                                            width : SizeConfig.blockSizeHorizontal * 50,
                                            child: Text(
                                            '${_resourcesList[i].displayResources()}',
                                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.6),
                                            textAlign: TextAlign.left,
                                            )
                                          ),
                                          Container(
                                            height : SizeConfig.blockSizeVertical * 7,
                                            width : SizeConfig.blockSizeHorizontal * 29,
                                            child: FlatButton.icon(
                                              label:Text(''),
                                              icon: Image.asset('assets/Lend.png', fit: BoxFit.fill, height : SizeConfig.blockSizeVertical * 7, width : SizeConfig.blockSizeHorizontal * 13,),
                                              onPressed:() {
                                                _resourcesList[i].updateLender();
                                                Navigator.of(context).push(MaterialPageRoute<Null>(
                                                builder: (BuildContext context){
                                                  return new ResourcesPage();
                                                }));
                                              },
                                            )
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
                    ],);
                  }
                ),
                ConditionalBuilder(
                  condition: (pageChange==2 && _teamIDList.length>0),
                  builder: (context){
                    return Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5), 
                          height : SizeConfig.blockSizeVertical * 7,
                          width : SizeConfig.blockSizeHorizontal * 60,
                          child:Text(
                            'Request Item',
                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 40,
                              child : Text(
                                'Item ID:',
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                onSaved: (val) => _itemID = val,
                                validator: (String val){
                                    if (val.length<1)
                                      return 'Please enter this field';
                                    else
                                      return null;
                                }
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 40,
                              child : Text(
                                'Team ID:',
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ConditionalBuilder(
                              condition: (_teamID.length>0),
                              builder: (context){
                                return Container(
                                  height : SizeConfig.blockSizeVertical * 5,
                                  width : SizeConfig.blockSizeHorizontal * 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButton<String>(
                                    value: _teamID,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _teamID = newValue;
                                      });
                                    },
                                    items: _teamIDList.map<DropdownMenuItem<String>>((String _teamID){
                                      return DropdownMenuItem<String>(
                                        value: _teamID,
                                        child: Text(_teamID),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 40,
                              child : Text(
                                'Item Name:',
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                onSaved: (val) => _itemName = val,
                                validator: (String val){
                                    if (val.length<1)
                                      return 'Please enter this field';
                                    else
                                      return null;
                                }
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 40,
                              child : Text(
                                'Item Type:',
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                onSaved: (val) => _itemType = val,
                                validator: (String val){
                                    if (val.length<1)
                                      return 'Please enter this field';
                                    else
                                      return null;
                                }
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3), 
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 40,
                              child : Text(
                                'Expired Date:',
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.white,
                              ),
                              child: DateTimeField(
                                format: format,
                                onShowPicker: (context, currentValue) async{
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2019),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2030));
                                  setState(()=>_expiredDate=date);
                                  return _expiredDate;
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 3, left:SizeConfig.blockSizeHorizontal * 40),                 
                          height : SizeConfig.blockSizeVertical * 6,
                          width : SizeConfig.blockSizeHorizontal * 25,
                          child: RaisedButton(
                            child:Text("Submit",
                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),),
                            color:Colors.green,
                            onPressed: () async {
                              if (formKey.currentState.validate() && _expiredDate!=null){
                                formKey.currentState.save();
                                Resource resource = new Resource(_itemID, _itemName, _itemType, 'Waiting', _expiredDate, User.currentUserEmail, _teamID, '');
                                resource.storeResource();
                                Navigator.of(context).push(MaterialPageRoute<Null>(
                                  builder: (BuildContext context){
                                    return new ResourcesPage();
                                  }));
                              }
                              else{
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Please check your input before submit")));
                              }
                            }
                          ),
                        ),
                      ],
                    );
                    
                  }
                ),
              ],
            )
          ]
        )
      )
    )));
  }
}
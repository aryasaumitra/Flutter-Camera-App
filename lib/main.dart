import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SecondPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field App',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State <StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Field Staff Name'),
              accountEmail: Text('Field Staff Email'),
              //currentAccountPicture: ,
            ),
            ListTile(
              title: Text('Clients'),
              trailing: Icon(Icons.account_box),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Flutter App')
      ),
      body:Container(
        padding: EdgeInsets.all(10.0),
        child:StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('CustomerData').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents.map((DocumentSnapshot document){
                      return ListTile(
                        contentPadding: EdgeInsets.all(5.0),
                        title: Text(document['customerName']),
                        subtitle: Text(document['businessName']),
                        onTap: (){

                        },
                      );
                    }).toList(),
                  );
              }
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add Customer',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecondPage()
            )
          );
        },
      ),
    );
  }
}
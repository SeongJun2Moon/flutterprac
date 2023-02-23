import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // 변수
  var a = 1;
  List<Contact> names = [];
  var value = "";

  // 함수
  addnames(String value) {
    var newContact = Contact();
    setState(() async {
      if (value==""){
        return;
      } else {
        newContact.givenName = value;
        ContactsService.addContact(newContact);
        setContacts();
      }
    });
  }

  deleteNames(value) async {
    var contacts = await ContactsService.getContacts();
    setState((){
      names.remove(value);
      names = contacts;
      ContactsService.deleteContact(value);
      setContacts();
    });
  }

  setContacts() async {
    var contacts = await ContactsService.getContacts();
    setState(() {
      names = contacts;
    });
  }

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print("허락됨");
      setContacts();
    } else if (status.isDenied) {
      print("거절됨");
      Permission.contacts.request();
    }
  }


  // 어플 위젯
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogUI(addnames : addnames);
              });
        },
      ),
      appBar: AppBar(
          title: Text("생활기록부"),
          actions: [
            // IconButton(onPressed: (){sortedNames();}, icon: Icon(Icons.sort)),
            IconButton(onPressed: (){getPermission();}, icon: Icon(Icons.contacts))
          ]
      ),
      body: Recods(names : names, deleteNames : deleteNames),
      bottomNavigationBar: BottomAppBar(
        child: Bottom(),
      ),
    );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addnames}) : super(key: key);

  final addnames;
  var inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      padding: EdgeInsets.all(20),
      height: 300,
      width: 300,
      child: Column(
        children: [
          TextField(controller: inputData),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                addnames(inputData.text);
              },
              child: Text("확인")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"))
        ],
      ),
    ));
  }
}

class Recods extends StatelessWidget {
  Recods({Key? key, this.names, this.deleteNames}) : super(key: key);
  var names;
  var deleteNames;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        child: ListView.builder(
            itemCount: names.length,
            itemBuilder: (c, i) {
              return ListTile(
                leading: Icon(Icons.home),
                title: Text(names[i].displayName ?? "이름 없는 놈"),
                trailing: IconButton(onPressed: (){deleteNames(names[i]);}, icon: Icon(Icons.delete),),
              );
            }));
  }
}

class Bottom extends StatelessWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.phone),
          Icon(Icons.message),
          Icon(Icons.file_copy),
        ],
      ),
    );
  }
}



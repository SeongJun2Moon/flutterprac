import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var a = 1;
  var names = ['문성준', "엄준식", "홍명보", "김춘식", "군것질"];
  var value;

  addnames(value){
    setState(() {
      names.add(value);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.warning),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogUI(addnames : addnames);
              });
        },
      ),
      appBar: AppBar(title: Text("생활기록부")),
      body: HGD(names : names),
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
          TextField(controller: inputData,),
          TextButton(
              onPressed: () {
                addnames(inputData.text);
                // print(inputData.text);
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

class HGD extends StatelessWidget {
  HGD({Key? key, this.names}) : super(key: key);
  var names;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: ListView.builder(
            itemCount: names.length,
            itemBuilder: (c, i) {
              return ListTile(
                leading: Icon(Icons.home),
                title: Text(names[i]),
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

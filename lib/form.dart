import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/album.dart';

Future<Album> createAlbum(String title) async {
  final response =  await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      headers:  <String,String> {
        'Content-Type' :  'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String> {
        'title': title,
      })
  );
  if(response.statusCode == 201){
    return Album.fromJson(jsonDecode(response.body));
  }else{
    throw Exception('Arrive pas ');
  }

}
class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulaire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Formulaire'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        )
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        ElevatedButton(onPressed: () => {
          setState(() {
            _futureAlbum = createAlbum(_controller.text);
          })
        }, child: const Text('Create Album')),
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
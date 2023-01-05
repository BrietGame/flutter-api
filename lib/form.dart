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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,

        )
      ],
    );
  }
}
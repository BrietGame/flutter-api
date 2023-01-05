import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:api/form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/album.dart';

void main() {
  runApp(const MyApp());
}

Future <Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

FutureOr<List<Album>> parseAlbum(String message) {
  final parsed = jsonDecode(message).cast<Map<String, dynamic>>();
  return parsed.map<Album>((json) => Album.fromJson(json)).toList();
}

Future<List<Album>> fetchAllAlbum() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
  log(response.body);
  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body);
    return compute(parseAlbum, response.body);
  } else {
    throw Exception('Failed to load album');
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Album> futureAlbum;
  late Future<List<Album>> futureAllAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    futureAllAlbum = fetchAllAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormWidget()
                ));
          },
          child: const Icon(
            Icons.menu,
          ),
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Album>>(
          future: futureAllAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].title),
                    subtitle: Row(
                      children: [
                        Text(snapshot.data![index].userId.toString()),
                        Text(snapshot.data![index].id.toString()),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          }
        ),
      ),
    );
  }
}

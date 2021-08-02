import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_page/home_page.dart';
import 'login_model.dart';

String xyz= "https://www.comingsoon.net/anime/news/1172796-dragon-ball-super-movie-2-leak";

Future<LoginModel> createAlbum(String email, String password) async {

  print(email + password);

  final response = await http.post(
    Uri.parse('https://test.zab.ee/api/login'),

    body: {
      'email': '$email',
      'password': '$password'
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.body);
    return LoginModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}


class LoginPage extends StatefulWidget {
  static const String id = 'login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Future<LoginModel>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Enter Title'),

        ),
        TextField(
          controller: _controller2,
          decoration: InputDecoration(hintText: 'Enter password'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum(_controller.text,_controller2.text);
            });
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  FutureBuilder<LoginModel> buildFutureBuilder() {
    return FutureBuilder<LoginModel>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          xyz = snapshot.data!.userid;

          // return Image.network(
          //   xyz,
          //   fit: BoxFit.cover,
          // );
          return Text(snapshot.data!.userid);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();

      },
    );
  }
}

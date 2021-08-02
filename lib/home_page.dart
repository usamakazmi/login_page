import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_page/home_page.dart';
import 'kaygees_model.dart';
import 'chat_page.dart';
import 'login_model.dart';

String xyz =
    "https://www.comingsoon.net/anime/news/1172796-dragon-ball-super-movie-2-leak";

Future<LoginModel> createLoginAlbum(String email, String password) async {
  //print(email + password);

  final response = await http.post(
    Uri.parse('https://test.zab.ee/api/login'),
    body: {'email': '$email', 'password': '$password'},
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

Future<ConversationsModel> createKaygeesAlbum(String email) async {
  final response = await http
      .post(Uri.parse('https://test.zab.ee/api/getMessageList?user_id=$email'));

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    //print(response.body);
    return ConversationsModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  HomePage({this.userId});
  //HomePage({this.name, this.password});
  final userId;
  //final name;
  //final password;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Future<LoginModel>? _futureLoginData;

  Future<ConversationsModel>? _futureConversationsData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Conversations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  //Implement logout functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ),
                  );
                }),
          ],
          //title: Center(child: Text('Conversations')),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureLoginData == null) ? buildColumn() : buildFutureBuilder1(),
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
          key: const Key('email'),
        ),
        TextField(
          controller: _controller2,
          decoration: InputDecoration(hintText: 'Enter password'),
          key: const Key('password'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              //_futureAlbum = createAlbum(_controller.text);
              _futureLoginData =
                  createLoginAlbum(_controller.text, _controller2.text);
            });
          },
          child: Text(
            'Login',
            key: const Key('increment'),
          ),
        ),
      ],
    );
  }

  FutureBuilder<LoginModel> buildFutureBuilder1() {
    return FutureBuilder<LoginModel>(
      future: _futureLoginData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          xyz = snapshot.data!.userid;
          print(snapshot.data);
          //print(xyz);
          _futureConversationsData = createKaygeesAlbum(xyz);
          //print(snapshot.data!.userid);
          return buildFutureBuilder(snapshot.data!.userid.toString());
          // return Image.network(
          //   xyz,
          //   fit: BoxFit.cover,
          // );
          return Text(snapshot.data!.email);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }

  FutureBuilder<ConversationsModel> buildFutureBuilder(String uid) {
    return FutureBuilder<ConversationsModel>(
      future: _futureConversationsData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Result> users = snapshot.data!.result.toSet().toList();
          print(users);
          List<String> sName = [];
          List<int> index = [];

          //List<String> uId = [];
          List<String> uPic = [];

          // for(int i = 0; i<snapshot.data!.rows; i++)
          // {
          //   if(!sName.contains(snapshot.data!.result[i].senderName))
          //   {
          //     sName.add(snapshot.data!.result[i].senderName);
          //     index.add(i);
          //
          //   }
          // }
          // //print('hello');
          // //print(sName.length);
          // sName.asMap();
          // uId.asMap();
          // uPic.asMap();

          // return Image.network(
          //   xyz,
          //   fit: BoxFit.cover,
          // );
          //return Text(snapshot.data!.result[0].userid);
          return Container(
            child: ListView.builder(
                itemCount: snapshot.data!.rows,
                padding: const EdgeInsets.all(2.0),
                itemBuilder: (context, position) {
                  String img;
                  if (snapshot.data!.result[position].userPic == null) {
                    img =
                        "https://dev1.bitneuron.com/kp_service/assets/dams/img/user/no-user.png";
                  } else {
                    img = snapshot.data!.result[position].userPic;
                    img =
                        "https://dev1.bitneuron.com/kp_service/assets/dams/img/user/no-user.png";
                  }
                  //print(uid);
                  //print(uid);

                  //print(xyz);

                  //if(position<sName.length) {
                  // if (index[position] == position) {
                  return GestureDetector(
                    key: Key('$position'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ChatPage(
                          userId: snapshot.data!.result[position].buyerId,
                          // user_pic: snapshot.data!.result[position]
                          //     .userPic,
                          user_pic:
                              "https://dev1.bitneuron.com/kp_service/assets/dams/img/user/no-user.png",
                          sender_name:
                              snapshot.data!.result[position].senderName,
                          loginId: xyz.toString(),
                          sender_id: snapshot.data!.result[position].sellerId,
                          product_variant_id:
                              snapshot.data!.result[position].productVariantId,
                          item_type: snapshot.data!.result[position].itemType,
                          loadLimit: 0,
                          length: 100,
                        );
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: NetworkImage(img),
                                  maxRadius: 40,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data!.result[position]
                                              .senderName,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                            '${snapshot.data!.result[position].productVariantId}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  );
                  //  }
                  //}
                  return Text('');
                  // return Card(
                  //   child: ListTile(
                  //     title: Text(
                  //       '${snapshot.data!.result[position].userid}',
                  //       style: TextStyle(
                  //           fontSize: 18.0,
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //     leading: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: SizedBox(
                  //         child: snapshot.data!.result[position].userPic == null
                  //             ? Image(
                  //           image: AssetImage('assets/logo.png'),
                  //         )
                  //             : Image.network('${snapshot.data!.result[position].userPic}'),
                  //         height: 200.0,
                  //         width: 200.0,
                  //       ),
                  //     ),
                  //     onTap: () => _onTapItem(context, snapshot.data!.result[position]),
                  //   ),
                  // );
                }),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }
}
//
// void _onTapItem(BuildContext context, Result article) {
//   // Navigator.of(context).push(MaterialPageRoute(
//   //     builder: (BuildContext context) => NewsDetails(article, widget.title)));
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:http/http.dart' as http;
import 'package:login_page/home_page.dart';
import 'kaygees_model.dart';
import 'messages_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

sendMessageAlbum(
    String sp_id,
    String message,
    String sender_id,
    String receiver_id,
    String seller_id,
    String buyer_id,
    String product_variant_id,
    String item_type,
    String date) async {
  final response = await http.post(
    Uri.parse('https://test.zab.ee/api/contact_seller'),
    body: {
      'sp_id': '$sp_id',
      'message': '$message',
      'sender_id': '$sender_id',
      'receiver_id': '$receiver_id',
      'seller_id': '$seller_id',
      'buyer_id': '$buyer_id',
      'product_variant_id': '$product_variant_id',
      'item_type': '$item_type',
      'date': '$date',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.body);
    //return ConversationsModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<Map<int, dynamic>> createMessagesAlbum(
    String userId,
    String sender_id,
    String product_variant_id,
    String item_type,
    String loadLimit,
    String length) async {
  //print('wtf');
  final response = await http.post(Uri.parse(
      'https://test.zab.ee/api/getMessages?user_id=$userId&sender_id=$sender_id'
      '&product_variant_id=$product_variant_id&item_type=$item_type&loadLimit=$loadLimit&length=$length'));
  print('server');
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    //print(response.body);
    //print(jsonDecode(response.body));
    List listm = jsonDecode(response.body) as List;
    //print(listm.asMap());
    return listm.reversed.toList().asMap();
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page';
  ChatPage(
      {this.userId,
      this.user_pic,
      this.sender_name,
      this.loginId,
      this.sender_id,
      this.product_variant_id,
      this.item_type,
      this.loadLimit,
      this.length});

  final user_pic;
  final sender_name;

  final userId;
  final sender_id;
  final product_variant_id;
  final item_type;
  final loadLimit;
  final length;

  final loginId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  Future<Map<int, dynamic>>? _futureAlbum;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureAlbum = createMessagesAlbum(
        widget.userId.toString(), //Buyer id coming from home page
        widget.sender_id.toString(), //Message sender id
        widget.product_variant_id.toString(),
        widget.item_type.toString(),
        widget.loadLimit.toString(),
        widget.length.toString());


  }

  @override
  Widget build(BuildContext context) {
    // _futureAlbum = createMessagesAlbum(
    //     widget.userId.toString(), //Buyer id coming from home page
    //     widget.sender_id.toString(), //Message sender id
    //     widget.product_variant_id.toString(),
    //     widget.item_type.toString(),
    //     widget.loadLimit.toString(),
    //     widget.length.toString());

    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) =>  _futureAlbum = createMessagesAlbum(
        widget.userId.toString(), //Buyer id coming from home page
        widget.sender_id.toString(), //Message sender id
        widget.product_variant_id.toString(),
        widget.item_type.toString(),
        widget.loadLimit.toString(),
        widget.length.toString()));

    print('call');
    print(DateTime.now().toUtc().toString());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.grey.shade200,
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
          leading: BackButton(
              onPressed: () {
                //Implement logout functionality
                Navigator.pop(context);
              },
              color: Colors.black),
          title: Center(
              child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user_pic == null
                    ? 'https://dev1.bitneuron.com/kp_service/assets/dams/img/user/no-user.png'
                    : widget.user_pic),
                maxRadius: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Text(widget.sender_name),
            ],
          )),
        ),
        body: Column(
          children: [
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.80,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                //child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
                child: buildFutureBuilder(),
              ),
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),

                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            key: Key('msg'),
                            keyboardType: TextInputType.multiline,
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                            ),
                              maxLines: 5,
                              minLines: 1,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          key: Key('msgbutton'),
                          onPressed: () {
                            print(widget.loginId.toString());
                            print(widget.userId.toString());
                            print(widget.sender_id.toString());
                            //sender is login id
                            setState(() {
                              if (widget.loginId.toString() ==
                                  widget.userId
                                      .toString()) //If logged in user is buyer
                              {
                                sendMessageAlbum(
                                    " ",
                                    _controller.text,
                                    widget.loginId.toString(),
                                    widget.sender_id.toString(),
                                    widget.loginId.toString(),
                                    widget.sender_id.toString(),
                                    widget.product_variant_id.toString(),
                                    widget.item_type.toString(),
                                    DateTime.now().toUtc().toString());

                                // FirebaseFirestore.instance
                                //     .collection('messages')
                                //     .add({'MESSAGE':  _controller.text.toString(),
                                //   'RECEIVERID': widget.sender_id.toString() ,
                                //   'SENDERID': widget.loginId.toString()
                                // });

                              } else //if logged in user is seller
                              {
                                sendMessageAlbum(
                                    " ",
                                    _controller.text,
                                    widget.loginId.toString(),
                                    widget.userId.toString(),
                                    widget.loginId.toString(),
                                    widget.userId.toString(),
                                    widget.product_variant_id.toString(),
                                    widget.item_type.toString(),
                                    DateTime.now().toUtc().toString());

                                // FirebaseFirestore.instance
                                //     .collection('messages')
                                //     .add({'MESSAGE':  _controller.text.toString(),
                                //   'RECEIVERID':  widget.userId.toString() ,
                                //   'SENDERID': widget.loginId.toString()
                                // });

                              }


                              _controller.clear();

                              _futureAlbum = createMessagesAlbum(
                                  widget.userId.toString(), //Buyer id coming from home page
                                  widget.sender_id.toString(), //Message sender id
                                  widget.product_variant_id.toString(),
                                  widget.item_type.toString(),
                                  widget.loadLimit.toString(),
                                  widget.length.toString());
                            });
                            // _futureAlbum = createMessagesAlbum(
                            //     widget.userId
                            //         .toString(), //Buyer id coming from home page
                            //     widget.sender_id.toString(), //Message sender id
                            //     widget.product_variant_id.toString(),
                            //     widget.item_type.toString(),
                            //     widget.loadLimit.toString(),
                            //     widget.length.toString());
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: Colors.blue,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
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
        ElevatedButton(
          onPressed: () {
            setState(() {});
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  FutureBuilder<Map<int, dynamic>> buildFutureBuilder() {
    return FutureBuilder<Map<int, dynamic>>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        //print(snapshot.data!.text);
        //print(snapshot);
        if (snapshot.hasData) {
          //return Text('data');
          return Container(
            child: ListView.builder(
                reverse: true,
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.all(2.0),
                itemBuilder: (context, position) {
                  String img =
                      "https://dev1.bitneuron.com/kp_service/assets/dams/img/user/no-user.png";
                  // if(snapshot.data!.result[position].userid == snapshot.data!.result[position].sellerId)
                  bool isMe;

                  if (widget.sender_name ==
                      snapshot.data![position]['sender_name']) {
                    isMe = false;
                  } else {
                    isMe = true;
                  }

                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data![position]['sender_name'].toString(),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                        Material(
                          borderRadius: isMe
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                )
                              : BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                ),
                          elevation: 10.0,
                          color: isMe ? Colors.lightBlueAccent : Colors.white,
                          child: Uri.parse(snapshot.data![position]['text'])
                                  .isAbsolute
                              ? Container(
                                  height: 220.0,
                                  width: 220.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data![position]['text'],
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: BoxShape.rectangle,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Text(
                                    snapshot.data![position]['text'].toString(),
                                    //snapshot.data!.result[position].message,
                                    //users2[position].message,
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    print('disposed');
    super.dispose();
  }
}

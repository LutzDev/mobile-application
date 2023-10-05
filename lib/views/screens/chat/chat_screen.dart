// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:fancai_client/core/storage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fancai_client/utils/socket.dart';
import 'package:fancai_client/views/screens/chat/chat_message_builder.dart';
import 'package:fancai_client/views/widgets/navigation/sidebar_navigation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:fancai_client/core/constants.dart';

import 'package:dash_chat_2/dash_chat_2.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  WebSocketChannel? channel;
  SocketConnection? connection;
  String? _status;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  static ChatUser user = ChatUser(
    id: '2',
    firstName: 'Charles',
    lastName: 'Leclerc',
    //profileImage: 'assets/images/coaches/fred.png'
  );

  late TabController controller;

  List<ChatMessage> messages = <ChatMessage>[];
  List<ChatMessage> faqMessages = <ChatMessage>[];

  @override
  void initState() {
    super.initState();
    connection = SocketConnection();
    connection!.initSocket(connectListener, messageListener);
    controller = TabController(length: 2, vsync: this);
    _initSpeech();

    controller.addListener(() { setState(() {
    });});
  }

  @override
  void dispose() {
    channel!.sink.close();
    controller.dispose();
    super.dispose();
  }
  var disable_input_text = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('eLan'),
      centerTitle: true,
      bottom: TabBar(
        controller: controller,
        tabs:const [
          Tab(text:'Intervention', icon:Icon(Icons.question_answer)),
          Tab(text:'FaQ', icon: Icon(Icons.question_mark)),
        ],
      ),
    ),
    drawer: const SidebarNavigation(),
    body: TabBarView(
      controller: controller,
      children: [
        Container(
          /*decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/fullscreen.jpg'),
                fit: BoxFit.cover),
          ),*/
          child: DashChat(
            currentUser: user,
            readOnly: disable_input_text,
            onSend: (ChatMessage m) {
              setState(() {
                Map<String, dynamic> answer = {
                  'message': m.text,
                  'type': 'answer',
                };
                disable_input_text = true;
                connection!.sendMessage(json.encode(answer));
                messages.insert(0, m);
              });
            },
            quickReplyOptions: QuickReplyOptions(onTapQuickReply: (QuickReply r) {
              final ChatMessage m = ChatMessage(
                user: user,
                text: r.title,
                createdAt: DateTime.now(),
              );
              setState(() {
                // TODO(naetherm): Send message to server -> This should be JSON
                Map<String, dynamic> answer = {
                  'message': r.value,
                  'type': 'variable',
                };
                connection!.sendMessage(json.encode(answer));
                messages.insert(0, m);
              });
            }),
            messages: messages,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/fullscreen.jpg'),
                fit: BoxFit.cover),
          ),
          child: DashChat(
            currentUser: user,
            onSend: (ChatMessage m) {
              setState(() {
                Map<String, dynamic> answer = {
                  'message': m.text,
                  'type': 'faq',
                };
                connection!.sendMessage(json.encode(answer));
                faqMessages.insert(0, m);
              });
            },
            quickReplyOptions: QuickReplyOptions(onTapQuickReply: (QuickReply r) {
              final ChatMessage m = ChatMessage(
                user: user,
                text: r.title,
                createdAt: DateTime.now(),
              );
              setState(() {
                // TODO(naetherm): Send message to server -> This should be JSON
                Map<String, dynamic> answer = {
                  'message': r.value,
                  'type': 'variable',
                };
                connection!.sendMessage(json.encode(answer));
                faqMessages.insert(0, m);
              });
            }),
            messages: faqMessages,
          ),
        ),
      ],
    ),
  );


  void messageListener(dynamic message) {
    print("===== message listener ===== ");
    dynamic jj = json.decode(message.toString());
    if (jj != null) {
      // TODO(naetherm): In handshake message. PARTICIPANT_UUID must be autogenerated as MongoDB-ObjectID -> not hardcoded in constants
      if (jj["type"] == "handshake") {
        Map<String, dynamic> login_participant = {
          'type': 'login_participant',
          'project_uuid': Constants.PROJECT_UUID,
          'participant_uuid': Constants.PARTICIPANT_UUID
        };
        connection!.sendMessage(json.encode(login_participant));
      } else if (jj["type"] == "register_participant") {
        // TODO(naetherm): Retrieve parameter 'participant_uuid' and save through shared_preferences
        String participant_uuid = jj["participant_uuid"];

        Storage.instance.setStringValue('participant_uuid', participant_uuid);
      } else {
        setState(() {
          for (dynamic chatMessage
          in ChatMessageBuilder.createFromJson(connection, jj)) {
            if(jj["type"] == "faq"){
              faqMessages.insert(0, chatMessage);
            }else{
              if(jj["type"] == "chatbot"){
                disable_input_text = false;
              }else{
                disable_input_text = true;
              }
              print("inside setState()");
              messages.insert(0, chatMessage);
              print("inside setState(); after message.insert");
            }
          }
        });
      }
    }
  }

  void connectListener(bool connected) {
    setState(() {
      _status = "Status: " + (connected ? "Connected" : "Failed to Connect");
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();

    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (_speechToText.isNotListening) {
        ChatMessage m = ChatMessage(
            user: user, createdAt: DateTime.now(), text: _lastWords);
        // TODO(naetherm): Send to server backend -> This should be JSON
        Map<String, dynamic> answer = {
          'message': m.text,
          'type': 'nlp',
        };

        connection!.sendMessage(json.encode(answer));
        messages.insert(0, m);
      }
    });
  }
}

// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'dart:convert';
import 'dart:developer';

import 'package:fancai_client/core/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketConnection {
  static String serverURL = Constants.SERVER_URL;
  static String serverPort = Constants.SERVER_PORT;
  static String serverAPIPath = Constants.SERVER_API_PATH;
  static final String websocketURL = "ws://"+serverURL+":"+serverPort+serverAPIPath;

  // Events
  static const String ON_MESSAGE_RECEIVED = 'receive_message';
  static const String SUB_EVENT_MESSAGE_SENT = 'message_sent_to_user';
  static const String IS_USER_CONNECTED_EVENT = 'is_user_connected';
  static const String IS_USER_ONLINE_EVENT = 'check_online';
  static const String SUB_EVENT_MESSAGE_FROM_SERVER = 'message_from_server';

  WebSocketChannel? channel;

  bool socketInit = false;

  Future<bool> initSocket(
      Function connectListener, Function messageListener) async {
    try {
      print('Connecting to socket');

      channel = WebSocketChannel.connect(Uri.parse(websocketURL));

      channel?.stream.listen((dynamic event) {
        print(json.decode(event));
        messageListener(json.decode(event));
      });
      socketInit = true;
    } catch (e) {
      print(e.toString());
      connectListener(false);
      return false;
    }
    return true;
  }

  void closeSocket() {
    channel?.sink.close();
    channel = null;
  }

  void cleanUp() {
    if (null != channel) {
      closeSocket();
    }
  }

  Future<bool> sendMessage(String message) async {
    try {
      log(message);
      channel?.sink.add(message);
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }
}

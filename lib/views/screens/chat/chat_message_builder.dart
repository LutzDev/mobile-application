// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:fancai_client/core/storage.dart';
import 'package:fancai_client/utils/socket.dart';

class ChatMessageBuilder {
  static ChatUser serverUser = ChatUser(
    id: '1',
    firstName: 'Server',
    lastName: 'Rootrecht',
    // profileImage: 'assets/images/coaches/fred.png'
  );
  static ChatUser meUser = ChatUser(
    id: '2',
    firstName: 'Part',
    lastName: 'Icipant',
    profileImage: 'assets/images/coaches/fred.png'
  );
  static List<ChatMessage> createFromJson(
      SocketConnection? connection, dynamic message) {
    if (message != null) {
      // Determine the message type
      if (message['type'] == 'command') {
        String type = message['type'];
        String value = message['value'];
        String arguments = message['arguments'];
        ChatMessageBuilder.onCommand(connection, type, value, arguments);
      } else {

        // This is not a command, but a message. We only have to determine
        // how to build the correct message
        // "has_media"
        // "buttons"
        ChatUser user = message['sender'] == 'client' ? meUser : serverUser;



        if (message['type']=='text'){
          List<ChatMessage> outMessages = [];
          message["message"].forEach((dynamic m) =>
              outMessages.add(ChatMessage(
                  user: user,
                  createdAt: DateTime.now(),
                  text: m
              )
          ));
          return outMessages;
        }
        else if (message['type']=='chatbot'){
          List<ChatMessage> outMessages = [];
          message["message"].forEach((dynamic m) =>
              outMessages.add(ChatMessage(
                  user: user,
                  createdAt: DateTime.now(),
                  text: m
              )
              ));
          return outMessages;
        }
        else if (message['type']=='button') {
          List<QuickReply> quickReplies = <QuickReply>[];
          message['buttons'].forEach((dynamic reply) =>
              quickReplies.add(
                    QuickReply(
                        title: reply['name'],
                        value: reply['value'],
                    )
              )
          );

          return [
            ChatMessage(
                user: user,
                createdAt: DateTime.now(),
                quickReplies: quickReplies
            )
          ];
        } else if(message['type']== 'video' || message['type'] == 'image' || message['type'] == 'file') {
          List<ChatMedia> chatMedia = <ChatMedia>[];
          MediaType mediaType;
          String ref;
          String fileName;

          if(message['type'] == "video") {
            mediaType = MediaType.video;
            fileName = 'video.mp4';
          } else if (message['type'] == "image"){
            mediaType = MediaType.image;
            fileName =  'image.png';
          }else {
            mediaType = MediaType.file;
            fileName =  'download file';
          }
          ref = message['ref'];

          chatMedia.add(ChatMedia(
            url: ref,
            type: mediaType,
            fileName: fileName,
            isUploading: false,
          ));

          return [
            ChatMessage(
                user: user,
                createdAt: DateTime.now(),
                medias: chatMedia
            )
          ];
        }else {
          List<ChatMessage> outMessages = [];
          List<String> messages = message['data']["message"].toString().split("---");
          for (dynamic m in messages) {
            outMessages.add(ChatMessage(
                user: user,
                createdAt: DateTime.now(),
                text: m
            ));
          }
          return outMessages;
        }
      }
    }

    return [
      ChatMessage(user: serverUser, createdAt: DateTime.now(), text: "ERROR")
    ];
  }

  static void onCommand(SocketConnection? connection, String command_type,
      String value, String arguments) {
    // TODO(naetherm): Add additional commands right here
    switch (command_type) {
      case "authenticate":
        // TODO(naetherm): We should authenticate ourself: Send back project_uuid
        //                 and participant_uuid
        Future<String> participant_uuid =
            Storage.instance.getStringValue('participant_uuid');
        break;
      case "registration":
        // TODO(naetherm): We received a unique participant_uuid, we should keep
        //                 that, thank you server-backend :)
        Storage.instance.setStringValue('participant_uuid', value);
        break;
      default:
      // Unknown command
    }
  }
}

/*
  Example for media-messages
ChatMessage(
              user: serverUser,
              createdAt: DateTime.now(),
              text: jj["content"]["message"],
              medias: <ChatMedia>[
                ChatMedia(
                    url:
                        'https://firebasestorage.googleapis.com/v0/b/molteo-40978.appspot.com/o/memes%2F155512641_3864499247004975_4028017188079714246_n.jpg?alt=media&token=0b335455-93ed-4529-9055-9a2c741e0189',
                    type: MediaType.image,
                    fileName: 'image.png'),
                ChatMedia(
                  url:
                      'https://firebasestorage.googleapis.com/v0/b/molteo-40978.appspot.com/o/chat_medias%2F2GFlPkj94hKCqonpEdf1%2F20210526_162318.mp4?alt=media&token=01b814b9-d93a-4bf1-8be1-cf9a49058f97',
                  type: MediaType.video,
                  fileName: 'video.mp4',
                  isUploading: false,
                ),
              ],
              quickReplies: <QuickReply>[
                QuickReply(title: 'Great!'),
                QuickReply(title: 'Awesome'),
              ],
            ));
*/
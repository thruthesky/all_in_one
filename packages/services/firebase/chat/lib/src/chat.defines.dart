import 'package:firebase_chat/firebase_chat.dart';
import 'package:flutter/material.dart';

typedef FunctionEnter = void Function(String roomId);
typedef FunctionRoomsItemBuilder = Widget Function(ChatDataModel);
typedef MessageBuilder = Widget Function(ChatDataModel);
typedef InputBuilder = Widget Function(Function);

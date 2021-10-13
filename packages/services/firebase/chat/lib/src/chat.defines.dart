import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

typedef FunctionEnter = void Function(String roomId);
typedef FunctionRoomsItemBuilder = Widget Function(DataSnapshot, int, Function);

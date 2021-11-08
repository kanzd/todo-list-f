import 'package:flutter/material.dart';
import "./Screens/home.dart";
void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes:{
      "/":(_)=>Home(),

    }
  ));
}


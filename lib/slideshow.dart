import 'package:a5er_ta3del/LoginScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import 'CreateNewAccount.dart';
//import 'GuestPage.dart';
//import 'HomePage.dart';

//void main() => runApp(LoginScreen());

class SlideShow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slideshow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SlideShowapp(),
    );
  }
}

class SlideShowapp extends StatefulWidget {
  @override
  SlideShowappState createState() => SlideShowappState();
}

class SlideShowappState extends State<SlideShowapp> {
  List<Widget> slides = [
    Image.asset('assets/download1.jpg', fit: BoxFit.cover),
    Image.asset('assets/download3.jpg', fit: BoxFit.cover),
    Image.asset('assets/download5.jpg', fit: BoxFit.cover),
    Image.asset('assets/download7.jpg', fit: BoxFit.cover),
    Image.asset('assets/download9.jpg', fit: BoxFit.cover),
    Image.asset('assets/download11.jpg', fit: BoxFit.cover),
    Image.asset('assets/download13.jpg', fit: BoxFit.cover),
    Image.asset('assets/download15.jpg', fit: BoxFit.cover),
    Image.asset('assets/download4.jpg', fit: BoxFit.cover),
    Image.asset('assets/download6.JPG', fit: BoxFit.cover),
    Image.asset('assets/download8.jpg', fit: BoxFit.cover),
    Image.asset('assets/download10.jpg', fit: BoxFit.cover),
    Image.asset('assets/download12.jpg', fit: BoxFit.cover),
    Image.asset('assets/download14.jpg', fit: BoxFit.cover),
    Image.asset('assets/download2.JPG', fit: BoxFit.cover),
    Image.asset('assets/download16.jpg', fit: BoxFit.cover),
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('SlideShow'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CarouselSlider(
                items: slides,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: screenSize.width / (screenSize.height * 0.77),
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        tooltip: 'LogIn',
        child: const Icon(Icons.login),
      ),
    );
  }
}

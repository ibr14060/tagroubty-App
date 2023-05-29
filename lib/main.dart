import 'package:a5er_ta3del/slideshow.dart';
import 'package:flutter/material.dart';
import 'CommentPage.dart';
import '/HomePage.dart';
import '/LoginScreen.dart';
import 'BeachPage.dart';
import 'CafePage.dart';
import 'CreateNewAccount.dart';
import 'GuestBeachPage.dart';
import 'GuestCafePage.dart';
import 'GuestHotelPage.dart';
import 'GuestMuseumPage.dart';
import 'GuestPage.dart';
import 'GuestRestaurantPage.dart';
import 'HotelPage.dart';
import 'MuseumPage.dart';
import 'PostPage.dart';
import 'RestaurantPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //  home: LoginScreenapp(),
        initialRoute: '/',
        routes: {
          '/': (dummCtx) => SlideShow(),
          '/LoginScreenapp': (dummyCtx) => LoginScreenapp(),
          '/CreateNewAccount': (dummyCtx) => CreateNewAccount(),
          '/GuestPage': (dummyCtx) => GuestPage(
                title: 'Home Page',
              ),
          '/HomePage': (dummyCtx) => HomePage(
                title: 'Home Page',
                username: '_usernameController',
              ),
          '/PostPage': (dummyCtx) => PostPage(
                username: '_usernameController',
              ),
          '/BeachPage': (dummyCtx) => BeachPage(
                title: 'Beach Category',
                username: '_usernameController',
              ),
          '/RestaurantPage': (dummyCtx) => RestaurantPage(
                title: 'Beach Category',
                username: '_usernameController',
              ),
          '/HotelPage': (dummyCtx) => HotelPage(
                title: 'Hotel Category',
                username: '_usernameController',
              ),
          '/MuseumPage': (dummyCtx) => MuseumPage(
                title: 'Museum Category',
                username: '_usernameController',
              ),
          '/CafePage': (dummyCtx) => CafePage(
                title: 'Cafe Category',
                username: '_usernameController',
              ),
          '/GuestBeachPage': (dummyCtx) => GuestBeachPage(
                title: 'Beach Category',
              ),
          '/GuestRestaurantPage': (dummyCtx) => GuestRestaurantPage(
                title: 'Beach Category',
              ),
          '/GuestHotelPage': (dummyCtx) => GuestHotelPage(
                title: 'Hotel Category',
              ),
          '/GuestMuseumPage': (dummyCtx) => GuestMuseumPage(
                title: 'Museum Category',
              ),
          '/GuestCafePage': (dummyCtx) => GuestCafePage(
                title: 'Cafe Category',
              ),
          '/CommentPage': (dummyCtx) => CommentPage(
                title: 'Comment Page',
                postName: 'post1',
                username: '_usernameController',
              )
        });
  }
}

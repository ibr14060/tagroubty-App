import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import '/CommentPage.dart';

import 'BeachPage.dart';
import 'CafePage.dart';
import 'HotelPage.dart';
import 'MuseumPage.dart';
import 'PostPage.dart';
import 'RestaurantPage.dart';

//import 'PostPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.username});

  final String title;
  final String username;
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> postData = [];
  List<Map<String, dynamic>> allusersData = [];
  List<Map<String, dynamic>> usersData = [];

  void initState() {
    super.initState();
    fetchPosts(); // Fetch posts when the page is initialized
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(
          'https://our-first-tagrouba-project-default-rtdb.firebaseio.com/posts.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
//

//
        // Clear existing post data
        postData.clear();

        jsonData.forEach((key, value) {
          final Map<String, dynamic> post = {
            'id': key,
            '_image': value['_image'],
            'experience': value['experience'],
            'rating': value['rating'],
            'latitude': value['Location']['coordinates'][0],
            'longitude': value['Location']['coordinates'][1],
            'category': value['category'],
            'name': value['name'],
            'timestamp': value['timestamp'],
            'username': value['username'],
          };

          postData.add(post);
        });
        // var responseData = json.decode(response.body);
        // var username = responseData['name'];

        setState(() {});
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

  //

  //

  Future<void> fetchPostsofsearch(String name) async {
    try {
      final response = await http.get(Uri.parse(
          'https://our-first-tagrouba-project-default-rtdb.firebaseio.com/posts.json'));
//?orderBy="name"&equalTo="$name"
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Clear existing post data
        postData.clear();

        jsonData.forEach((key, value) {
          final String name_to_search_with = value['name'];
          if (name == name_to_search_with) {
            final Map<String, dynamic> post = {
              'id': key,
              '_image': value['_image'],
              'experience': value['experience'],
              'rating': value['rating'],
              'latitude': value['Location']['coordinates'][0],
              'longitude': value['Location']['coordinates'][1],
              'category': value['category'],
              'name': value['name'],
              'timestamp': value['timestamp'],
              'username': value['username'],
            };

            postData.add(post);
          }
        });

        setState(() {});
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

  void navigatetobeach() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const BeachPage(
                title: 'Beach Category',
                username: '_usernameController',
              )),
    );
  }

  void navigatetoRestaurant() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const RestaurantPage(
                title: 'Restaurant Category',
                username: '_usernameController',
              )),
    );
  }

  void navigatetoHotel() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const HotelPage(
                title: 'Hotel Category',
                username: '_usernameController',
              )),
    );
  }

  void navigatetoCafe() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CafePage(
                title: 'Cafe Category',
                username: '_usernameController',
              )),
    );
  }

  void navigatetoMuseum() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const MuseumPage(
                title: 'Museum Category',
                username: '_usernameController',
              )),
    );
  }

  bool isLiked = false;
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void sortPostsByName() {
    setState(() {
      postData.sort((a, b) => a['name'].compareTo(b['name']));
    });
  }

  void sortPostsByRating() {
    setState(() {
      postData.sort((b, a) => a['rating'].compareTo(b['rating']));
    });
  }

  void sortPostsByTimeStamp() {
    setState(() {
      postData.sort((b, a) {
        final aTimestamp = a['timestamp'];
        print(aTimestamp);
        final bTimestamp = b['timestamp'];

        if (aTimestamp == null && bTimestamp == null) {
          print('object');
          return 0;
        } else if (aTimestamp == null) {
          print('object1');
          return 1; // Treat null as greater than non-null values
        } else if (bTimestamp == null) {
          print('object2');
          return -1; // Treat null as greater than non-null values
        }

        return aTimestamp.compareTo(bTimestamp);
      });
    });
  }

  String searchText = '';
  bool isSearchFocused = false;

  List<Map<String, dynamic>> buttonData = [
    {
      'name': 'Cafe',
      'icon': Icons.local_cafe,
      'onPressed': () {
        print('Cafe button clicked');
      },
    },
    {
      'name': 'Museum',
      'icon': Icons.museum,
      'onPressed': () {
        print('Museum button clicked');
      },
    },
    {
      'name': 'Hotel',
      'icon': Icons.hotel,
      'onPressed': () {
        print('Hotel button clicked');
      },
    },
    {
      'name': 'Restaurant',
      'icon': Icons.restaurant,
      'onPressed': () {
        print('Restaurant button clicked');
      },
    },
    {
      'name': 'Beach',
      'icon': Icons.beach_access,
      'onPressed': () {
        //  navigatetobeach();
        print('Beach button clicked');
      },
    },
  ];
  List<Map<String, dynamic>> SortData = [
    {
      'name': 'Time(Latest)',
      'icon': Icons.access_time,
      'onPressed': () {
        print('Time button clicked');
      },
    },
    {
      'name': 'Alphabetical(A -> Z)',
      'icon': Icons.sort_by_alpha,
      'onPressed': () {
        //  navigatetobeach();
        print('Alphabet button clicked');
      },
    },
    {
      'name': 'Rating(5 -> 1)',
      'icon': Icons.star,
      'onPressed': () {
        //  navigatetobeach();
        print('Rating button clicked');
      },
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchFocused = true;
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
        backgroundColor: Colors.blue,
        title: isSearchFocused
            ? TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                onSubmitted: (value) {
                  fetchPostsofsearch(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              )
            : Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: buttonData.length,
              itemBuilder: (context, index) {
                final button = buttonData[index];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      //button['onPressed']
                      if (button['name'] == "Beach") {
                        navigatetobeach();
                      } else if (button['name'] == "Restaurant") {
                        navigatetoRestaurant();
                      } else if (button['name'] == "Hotel") {
                        navigatetoHotel();
                      } else if (button['name'] == "Museum") {
                        navigatetoMuseum();
                      } else {
                        navigatetoCafe();
                      }
                    },
                    icon: Icon(button['icon']),
                    label: Text(button['name']),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            '  ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Sort by ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // SizedBox(height: 16),
            ],
          ),
          SizedBox(
            height: 54,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: SortData.length,
              itemBuilder: (context, index) {
                final button = SortData[index];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      //button['onPressed']
                      if (button['name'] == "Alphabetical(A -> Z)") {
                        sortPostsByName();
                      } else if (button['name'] == "Time(Latest)") {
                        sortPostsByTimeStamp();
                      } else {
                        sortPostsByRating();
                      }
                    },
                    icon: Icon(button['icon']),
                    label: Text(button['name']),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              itemCount: postData.length,
              itemBuilder: (context, index) {
                final post = postData[index];
                //     final useer = usersData[postData.length];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8.0),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.person_2),
                              onPressed: toggleLike,
                            ),
                            Flexible(
                              child: Text(
                                'UserName',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Text(
                              ' :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            // const SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                post['username'],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          // SizedBox(width: 16.0),
                          Text(
                            post['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
/*
                          SizedBox(width: 16.0),
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 50.0,
                            ),
                            onPressed: toggleLike,
                          ),
                          */
                        ]),
                        SizedBox(height: 8),
                        Text(
                          'Experience: ${post['experience']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Location: (${post['latitude']}, ${post['longitude']})',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'category: ${post['category']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.memory(
                            base64Decode(post['_image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              initialRating: post['rating'].toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 35,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                print(post['name']);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentPage(
                                            title: 'Comment Page',
                                            postName: post['name'],
                                            username: widget
                                                .username, // Pass the post['name'] as an attribute
                                          )),
                                );

                                // Handle the comment button click
                                print('Comment button clicked');
                              },
                              icon: Icon(Icons.comment),
                              label: Text('Comment'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostPage(
                    username:
                        widget.username // Pass the post['name'] as an attribute
                    )),
          );
        },
        tooltip: 'Write post',
        child: const Icon(Icons.post_add),
      ),
    );
  }
}

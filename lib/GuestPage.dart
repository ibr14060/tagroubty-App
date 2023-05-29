import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import 'CreateNewAccount.dart';
import 'GuestBeachPage.dart';
import 'GuestCafePage.dart';
import 'GuestHotelPage.dart';
import 'GuestMuseumPage.dart';
import 'GuestRestaurantPage.dart';
//import 'MuseumPage.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({Key? key, required this.title});

  final String title;

  @override
  State<GuestPage> createState() => GuestPageState();
}

class GuestPageState extends State<GuestPage> {
  List<Map<String, dynamic>> postData = [];

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

        // Clear existing post data
        postData.clear();

        jsonData.forEach((key, value) {
          final Map<String, dynamic> post = {
            'id': key,
            'name': value['name'],
            '_image': value['_image'],
            'experience': value['experience'],
            'rating': value['rating'],
            'latitude': value['Location']['coordinates'][0],
            'longitude': value['Location']['coordinates'][1],
            'category': value['category'],
            'timestamp': value['timestamp'],
          };

          postData.add(post);
        });

        setState(() {});
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

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
          builder: (context) => const GuestBeachPage(
                title: 'Beach Category',
              )),
    );
  }

  void navigatetoRestaurant() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GuestRestaurantPage(
                title: 'Restaurant Category',
              )),
    );
  }

  void navigatetoHotel() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GuestHotelPage(
                title: 'Hotel Category',
              )),
    );
  }

  void navigatetoCafe() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GuestCafePage(
                title: 'Cafe Category',
              )),
    );
  }

  void navigatetoMuseum() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GuestMuseumPage(
                title: 'Museum Category',
              )),
    );
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

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0),
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
                        Text(
                          post['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                            Text(
                              'Location: (${post['latitude']}, ${post['longitude']})',
                              style: TextStyle(fontSize: 16),
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
            MaterialPageRoute(builder: (context) => const CreateNewAccount()),
          );
        },
        tooltip: 'sign up',
        child: const Icon(Icons.new_label),
      ),
    );
  }
}

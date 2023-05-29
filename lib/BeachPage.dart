import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import 'CommentPage.dart';

class BeachPage extends StatefulWidget {
  const BeachPage({Key? key, required this.title, required this.username});

  final String title;
  final String username;

  @override
  State<BeachPage> createState() => BeachPageState();
}

class BeachPageState extends State<BeachPage> {
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
          final String category = value['category'];
          if (category == 'Beach') {
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
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: postData.length,
              itemBuilder: (context, index) {
                final post = postData[index];

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
                        Text(
                          post['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Experience: ${post['experience']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
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
    );
  }
}

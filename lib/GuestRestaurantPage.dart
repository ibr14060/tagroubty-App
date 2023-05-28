import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class GuestRestaurantPage extends StatefulWidget {
  const GuestRestaurantPage({Key? key, required this.title});

  final String title;

  @override
  State<GuestRestaurantPage> createState() => GuestRestaurantPageState();
}

class GuestRestaurantPageState extends State<GuestRestaurantPage> {
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
          if (category == 'Restaurant') {
            final Map<String, dynamic> post = {
              'id': key,
              'name': value['name'],
              '_image': value['_image'],
              'experience': value['experience'],
              'rating': value['rating'],
              'latitude': value['Location']['coordinates'][0],
              'longitude': value['Location']['coordinates'][1],
              'category': value['category'],
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

  String searchText = '';
  bool isSearchFocused = false;

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

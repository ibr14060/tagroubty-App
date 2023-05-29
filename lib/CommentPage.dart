import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentPage extends StatefulWidget {
  const CommentPage({
    Key? key,
    required this.title,
    required this.postName,
  });

  final String title;
  final String postName;
  @override
  State<CommentPage> createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  List<Map<String, dynamic>> commentData = [];
  String experience = '';
  File? _image;
  int rating = 1;

  void initState() {
    super.initState();
    fetchcomments(); // Fetch posts when the page is initialized
  }

  Future<void> postComment() async {
    try {
      String imageBase64 = '';

      if (_image != null) {
        List<int> imageBytes = await _image!.readAsBytes();
        imageBase64 = base64Encode(imageBytes);
      }

      final response = await http.post(
        Uri.parse(
            'https://our-first-tagrouba-project-default-rtdb.firebaseio.com/comments.json'),
        body: json.encode({
          'experience': experience,
          '_image': imageBase64,
          'rating': rating,
          'postname': widget.postName,
        }),
      );
      /*
      String returnusername() {
        var responseData = json.decode(response.body);
        var username = responseData['name'];
        return username;
      }
*/
      if (response.statusCode == 200) {
        sendNotificationToUser();
        // Comment posted successfully
        print('Comment posted successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Comment Posted successfully.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        // You can fetch the updated comments again by calling fetchcomments() if needed
      } else {
        print('Failed to post comment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error posting comment: $error');
    }
  }

  Future<void> fetchcomments() async {
    try {
      final response = await http.get(Uri.parse(
          'https://our-first-tagrouba-project-default-rtdb.firebaseio.com/comments.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Clear existing post data
        commentData.clear();

        jsonData.forEach((key, value) {
          final String postname = value['postname'];
          if (postname == widget.postName) {
            final Map<String, dynamic> comment = {
              'id': key,
              'experience': value['experience'],
              '_image': value['_image'],
              'rating': value['rating'],
            };

            commentData.add(comment);
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

  //
  Future<void> sendNotificationToUser() async {
    try {
      final response = await http.get(
          Uri.parse('https://your-firebase-project.firebaseio.com/users.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        jsonData.forEach((key, value) async {
          // Replace `postOwnerId` with the ID of the user who posted the commented post
          if (key == widget.postName) {
            final String fcmToken = value['fcmToken'];

            final message = {
              'notification': {
                'title': 'New Comment',
                'body': 'Someone commented on your post.',
              },
              'token': fcmToken,
            };

            final response = await http.post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'key=YOUR_SERVER_KEY',
              },
              body: json.encode(message),
            );

            if (response.statusCode == 200) {
              print('Notification sent successfully.');
            } else {
              print('Failed to send notification: ${response.statusCode}');
            }
          }
        });
      } else {
        print('Failed to fetch users: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }

//
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: commentData.length,
              itemBuilder: (context, index) {
                final post = commentData[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: Color.fromARGB(255, 153, 153, 153),
                      width: 1,
                    ),
                  ),
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Comment: ${post['experience']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        if (post['_image'] != null && post['_image'] != '')
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
                          children: [
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 218, 200, 46),
                              size: 22,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Rating: ${post['rating']} out of 5',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Add comment form
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Add A Comment',
                  ),
                  onChanged: (value) {
                    setState(() {
                      experience = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Choose Image Source'),
                              content: Text('Select the source for the image'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Camera'),
                                  onPressed: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Gallery'),
                                  onPressed: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.attach_file),
                      label: Text('Attach Photo'),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.center,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              height: 150.0,
                              width: 150.0,
                            )
                          : SizedBox.shrink(),
                    ),
                    if (_image != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: _removeImage,
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Rating:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    DropdownButton<int>(
                      value: rating,
                      onChanged: (value) {
                        setState(() {
                          rating = value!;
                        });
                      },
                      items: [1, 2, 3, 4, 5].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    postComment();
                  },
                  child: Text('Post Comment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

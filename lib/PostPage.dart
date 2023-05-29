import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'location_selection_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.username});
  final String username;
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _rating = 0.0;
  final TextEditingController _textController = TextEditingController();
  File? _image;
  final bool _isLoggedIn = false; // Set to true if the user is logged in
  LatLng _selectedLocation = LatLng(0, 0); // Initial location (0, 0)
  String _selectedLocationName = '';

  List<String> categories = ['Hotel', 'Restaurant', 'Museum', 'Cafe', 'Beach'];
  String? _selectedCategory = 'Hotel';
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: _rating).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _updateRating(double value) {
    setState(() {
      _rating = value;
      _animation = Tween<double>(begin: _animation.value, end: _rating).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
      _animationController.forward(from: 0);
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

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

  Future<void> _selectLocation(BuildContext context) async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute<LatLng>(
        builder: (context) =>
            LocationSelectionPage(initialLocation: _selectedLocation),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = LatLng(
          double.parse(selectedLocation.latitude.toStringAsFixed(6)),
          double.parse(selectedLocation.longitude.toStringAsFixed(6)),
        );
      });
    }
  }

  Future<void> postData() async {
    var url = Uri.parse(
        'https://our-first-tagrouba-project-default-rtdb.firebaseio.com/posts.json'); // Replace with your API endpoint
    var response = await http.post(url,
        body: json.encode({
          'x': _selectedLocation.latitude,
          'y': _selectedLocation.longitude,
        }));

    if (response.statusCode == 200) {
      // Request successful
      print('POST request successful');
      print(response.body);
    } else {
      // Request failed
      print('POST request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {
                    _selectedLocationName = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Location Name',
                  labelText: 'Location Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    key: Key(category),
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Select Location:',
                style: TextStyle(fontSize: 18.0),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _selectLocation(context);
                },
                icon: const Icon(Icons.location_on),
                label: const Text('Select Location'),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Rate your experience:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Container(
                width: double.infinity,
                height: 60.0,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 159, 159, 159),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          width: _animation.value *
                              (MediaQuery.of(context).size.width - 320.0),
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < 5; i++)
                          IconButton(
                            icon: Icon(
                              Icons.star,
                              color: _rating >= (i + 1)
                                  ? Colors.yellow
                                  : Colors.grey[400],
                            ),
                            onPressed: () => _updateRating(i + 1),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Write your experience:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  _isLoggedIn
                      ? CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[600],
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.grey[600],
                          ),
                        ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Enter your experience',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Choose Image Source'),
                            content:
                                const Text('Select the source for the image'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Camera'),
                                onPressed: () {
                                  _pickImage(ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Gallery'),
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
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach Photo'),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.center,
                    child: _image != null
                        ? Image.file(
                            _image!,
                            height: 150.0,
                            width: 150.0,
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (_image != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: _removeImage,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_image == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Please attach a photo before submitting.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return; // Stop the execution of the onPressed callback
                    }
                    // Save the post to database or perform other actions
                    String experience = _textController.text;
                    double rating = _rating;
                    List<int> imageBytes = await _image!.readAsBytes();
                    String base64Image = base64Encode(imageBytes);
                    Map<String, dynamic> postData = {
                      'experience': experience,
                      'rating': rating,
                      'Location': _selectedLocation,
                      '_image': base64Image,
                      'category': _selectedCategory,
                      'name': _selectedLocationName,
                      'timestamp': formatTimestamp(Timestamp.now()),
                      'username': widget.username,
                      // Include other fields as needed
                    };

                    // Convert the data to JSON
                    String jsonPostData = json.encode(postData);
                    // TODO: Implement saving the post to database or perform other actions
                    print('Experience: $experience');
                    print('Rating: $rating');
                    print('Image: $_image');
                    print('Location: $_selectedLocation');
                    try {
                      // Send a POST request to the Firebase Realtime Database
                      final response = await http.post(
                        Uri.parse(
                            'https://our-first-tagrouba-project-default-rtdb.firebaseio.com/posts.json'),
                        body: jsonPostData,
                      );

                      if (response.statusCode == 200) {
                        // Data was successfully posted
                        print('Post saved successfully.');

                        // Show a success message
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Success'),
                              content: const Text('Post saved successfully.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Error occurred while posting data
                        print('Failed to save post.');
                      }
                    } catch (error) {
                      // Exception occurred while sending the request
                      print('Error: $error');

                      // Show an error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('An error occurred.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
void main() {
  runApp(const MaterialApp(
    home: PostPage(),
  ));
}
*/
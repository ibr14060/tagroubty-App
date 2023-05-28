import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({Key? key}) : super(key: key);

  @override
  State<CreateNewAccount> createState() => CreateNewAccountState();
}

class CreateNewAccountState extends State<CreateNewAccount> {
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration:
            const Duration(seconds: 2), // Adjust the duration as per your needs
      ),
    );
  }

  void showUserName(String username) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Name'),
          content: Text(
              'your user name is:( $username ) please save it to login with'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String selectedGender = ''; // Variable to store selected gender
  String value_of_day = '';
  String value_of_month = '';
  String value_of_year = '';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String dropdownValue = '1';
  String dropdownValueOfMonths = 'Jan';
  String dropdownValueOfYears = '1990';
  Future<void> postData() async {
    var url = Uri.parse(
        'https://our-first-tagrouba-project-default-rtdb.firebaseio.com/create_new_account.json'); // Replace with your API endpoint
    if (passwordController.text == confirmPasswordController.text) {
      var response = await http.post(url,
          body: json.encode({
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'mobileNumber': mobileNumberController.text,
            'userName': userNameController.text,
            'email': emailController.text,
            'password': passwordController.text,
            'confirmPassword': confirmPasswordController.text,
            'gender': selectedGender,
            'day': value_of_day,
            'month': value_of_month,
            'year': value_of_year,
          }));
      var responseData = json.decode(response.body);
      var username = responseData['name'];

      if (response.statusCode == 200) {
        // Request successful
        print('POST request successful');
        print(response.body);
        print('User NAME: $username');
        showUserName(username);
        //print('nameController.text');
      } else {
        // Request failed
        print('POST request failed with status: ${response.statusCode}');
      }
    } else {
      showErrorMessage('make sure that confirm password same as password');
      print('make sure that confirm password same as password');
    }
  }

  bool validateFields() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        mobileNumberController.text.isEmpty ||
        userNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        selectedGender.isEmpty ||
        value_of_day.isEmpty ||
        value_of_month.isEmpty ||
        value_of_year.isEmpty) {
      showErrorMessage('Please fill in all fields');
      return false; // At least one field is empty
    } else {
      if (!emailController.text.contains('@')) {
        showErrorMessage('Please enter a valid email address');
        print('enter a valid E-mail address');
        return false;
      } else {
        return true; // All fields are filled
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Account'),
      ),
      //  backgroundColor: Colors.blue,
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Tagroubty',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Last Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mobile Number',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Address',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gender',
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
              items: <String>['', 'Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: dropdownValueOfMonths,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Month',
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueOfMonths = newValue!;
                        value_of_month = dropdownValueOfMonths;
                      });
                    },
                    items: <String>[
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: dropdownValue,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Day',
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        value_of_day = dropdownValue;
                      });
                    },
                    items: <String>[
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                      '10',
                      '11',
                      '12',
                      '13',
                      '14',
                      '15',
                      '16',
                      '17',
                      '18',
                      '19',
                      '20',
                      '21',
                      '22',
                      '23',
                      '24',
                      '25',
                      '26',
                      '27',
                      '28',
                      '29',
                      '30',
                      '31'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: dropdownValueOfYears,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Year',
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueOfYears = newValue!;
                        value_of_year = dropdownValueOfYears;
                      });
                    },
                    items: <String>[
                      '1990',
                      '1991',
                      '1992',
                      '1993',
                      '1994',
                      '1995',
                      '1996',
                      '1997',
                      '1998',
                      '1999',
                      '2000',
                      '2001',
                      '2002',
                      '2003',
                      '2004',
                      '2005',
                      '2006',
                      '2007',
                      '2008',
                      '2009',
                      '2010',
                      '2011',
                      '2012',
                      '2013',
                      '2014',
                      '2015',
                      '2016',
                      '2017',
                      '2018',
                      '2019',
                      '2020',
                      '2021',
                      '2022',
                      '2023'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: const Text('Create Account'),
              onPressed: () {
                if (validateFields()) {
                  String firstName = firstNameController.text;
                  String lastName = lastNameController.text;
                  String mobileNumber = mobileNumberController.text;
                  String userName = userNameController.text;
                  String email = emailController.text;
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  // Use the extracted data as needed
                  print('First Name: $firstName');
                  print('Last Name: $lastName');
                  print('Mobile Number: $mobileNumber');
                  print('User Name: $userName');
                  print('Email: $email');
                  print('Password: $password');
                  print('Confirm Password: $confirmPassword');
                  print('Selected Day: $dropdownValue');
                  print('Selected Month: $dropdownValueOfMonths');
                  print('Selected Year: $dropdownValueOfYears');
                  print('Selected Gender: $selectedGender');
                  postData();
                } else {
                  // Show an error or display a message indicating that all fields must be filled
                  print(
                      'Please fill in all fields OR check if the E-mail is valid');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

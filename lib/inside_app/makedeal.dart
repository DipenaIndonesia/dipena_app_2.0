import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class MakeDeal extends StatefulWidget {
  @override
  _MakeDealState createState() => _MakeDealState();
}

// class Category {
//   int category_id;
//   String category_name;
//   String category_description;

//   Category(
//     this.category_id,
//     this.category_name,
//     this.category_description,
//   );

//   static List<Category> getCategories() {
//     return <Category>[
//       Category(
//         1,
//         'Art',
//         'Kesenian',
//       ),
//       Category(
//         2,
//         'Design',
//         'INI DESAIN',
//       ),
//       Category(
//         3,
//         'Photography',
//         'TENTANG POTO',
//       ),
//       Category(
//         4,
//         'Brand',
//         'INI BRAND',
//       ),
//     ];
//   }
// }

class _MakeDealState extends State<MakeDeal> {
  String user_id,
      post_user_id,
      post_cat_id,
      post_sub_cat_id,
      post_title,
      post_offer,
      post_description,
      post_location;
  final _key = new GlobalKey<FormState>();

  List<String> category = ['Art', 'Design', 'Photography', 'Brand'];
  String _category = 'Art';
  File _imageFile;

  final TextEditingController controller = new TextEditingController();
  String result = '';
  // List<Category> _categories = Category.getCategories();
  // List<DropdownMenuItem<Category>> _dropdownMenuItems;
  // Category _selectedCategory;

  @override
  void initState() {
    // ,
    this.getSWData();
    super.initState();
    getPref();
  }

  _pilihGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  _pilihCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  // List<DropdownMenuItem<Category>> buildDropdownMenuItems(List categories) {
  //   List<DropdownMenuItem<Category>> items = List();
  //   for (Category category_id in categories) {
  //     items.add(
  //       DropdownMenuItem(
  //         value: category_id,
  //         child: Text(category_id.category_name),
  //       ),
  //     );
  //   }
  //   return items;
  // }

  // onChangedDropdownMenuItem(Category selectedCategory) {
  //   setState(() {
  //     _selectedCategory = selectedCategory;
  //   });
  // }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      post_user_id = preferences.getString("user_id");
      user_id = preferences.getString("user_id");
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  bool loading;
  submit() async {
    setState(() {
      loading = true;
    });
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse("https://dipena.com/flutter/api/post/addPost.php");
      final request = http.MultipartRequest("POST", uri);
      request.fields['post_user_id'] = user_id;
      request.fields['user_id'] = user_id;
      request.fields['post_title'] = post_title;
      request.fields['post_location'] = post_location;
      request.fields['post_offer'] = post_offer;
      request.fields['post_description'] = post_description;
      request.fields['post_cat_id'] = _mySelection;

      request.files.add(http.MultipartFile("post_img", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("Image uploaded");
        setState(() {
          loading = false;
          Navigator.pop(context);
        });
      } else {
        print("Image failed to be upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }

    // await getPref();
    // final response = await http
    //     .post("http://dipena.com/flutter/api/post/addPost.php", body: {
    //   "post_user_id": user_id,
    //   "user_id": user_id,
    //   // "post_cat_id" : post_cat_id,
    //   "post_title": post_title,
    //   "post_location": post_location,
    //   "post_offer": post_offer,
    //   "post_description": post_description,
    // });
    // final data = jsonDecode(response.body);
    // int value = data['value'];
    // String pesan = data['message'];
    // if (value == 1) {
    //   print(pesan);
    //   setState(() {
    //     Navigator.pop(context);
    //   });
    // } else {
    //   print(pesan);
    // }
  }

  String _mySelection;

  final String url = "http://dipena.com/flutter/api/post/selectCat.php";

  List data = List();

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var placeholder = Container(
      width: width,
      height: 265,
      child: Image.asset('./img/placeholder.png'),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(62),
        child: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Color.fromRGBO(244, 217, 66, 1),
          title: Text(
            'Create Deal',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          children: <Widget>[
            Container(
              height: 900,
              child: Column(
                children: <Widget>[
                  // Padding(
                  // padding: const EdgeInsets.only(top: 30, bottom: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        top: BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        left: BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        right: BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    height: 265,
                    // width: width,
                    child: _imageFile == null
                        ? placeholder
                        : Image.file(_imageFile),
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Camera',
                          style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                        onPressed: () {
                          _pilihCamera();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Gallery',
                          style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                        onPressed: () {
                          _pilihGallery();
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        // right: 180,
                      ),
                      child: DropdownButton(
                        items: data.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['category_name']),
                            value: item['category_id'].toString(),
                          );
                        }).toList(),
                        hint: Text('Select Category'),
                        onChanged: (newVal) {
                          setState(() {
                            _mySelection = newVal;
                          });
                        },
                        value: _mySelection,
                      ),
                    ),
                  ),

                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     top: 30,
                  //     right: 210,
                  //   ),
                  //   child: DropdownButton(
                  //     items: category.map((String value){
                  //       return new DropdownMenuItem(
                  //         value: value,
                  //         child: new Text(value)
                  //       );
                  //     }).toList()
                  //     // value: _selectedCategory,
                  //     // items: _dropdownMenuItems,
                  //     // onChanged: onChangedDropdownMenuItem,
                  //   ),
                  // ),
                  SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Please Insert Title";
                        }
                      },
                      onSaved: (e) => post_title = e,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Please Insert Location";
                        }
                      },
                      onSaved: (e) => post_location = e,
                      decoration: InputDecoration(
                        labelText: 'Location',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      onSaved: (e) => post_description = e,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Please Insert Service Deals";
                        }
                      },
                      // controller: controller,
                      // keyboardType: TextInputType.multiline,
                      // maxLines: null,
                      onSaved: (e) => post_offer = e,
                      decoration: InputDecoration(
                        labelText: 'Service Deals',  hintText: "e.g landscape"
                      ),
                      // onFieldSubmitted:
                      // (String str) {
                      //   setState(() {
                      //     result = result + '\n' + str;
                      //   });
                      //   controller.text = '';
                      // },
                      // onSubmitted: (String str) {
                      //   setState(() {
                      //     result = result + '\n' + str;
                      //   });
                      //   controller.text = '';
                      // },
                      // controller: controller,
                    ),
                  ),
                  // new Text(text),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    child: Container(
                      width: 200,
                      child: RaisedButton(
                        elevation: 5,
                        splashColor: Colors.purpleAccent,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Color.fromRGBO(244, 217, 66, 1),
                        child: Text(
                          'DONE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.pop(context);
                          check();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

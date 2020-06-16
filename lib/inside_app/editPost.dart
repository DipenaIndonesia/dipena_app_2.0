import 'dart:convert';
import 'dart:io';

import 'package:dipena/model/post.dart';
import 'package:dipena/model/tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditPost extends StatefulWidget {
  final PostContent model;
  final VoidCallback reload;
  EditPost(this.model, this.reload);
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
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

  // final TextEditingController controller = new TextEditingController();
  // String result = '';
  // List<Category> _categories = Category.getCategories();
  // List<DropdownMenuItem<Category>> _dropdownMenuItems;
  // Category _selectedCategory;

  TextEditingController txtTitle, txtLocation, txtDescription, txtService;

  setup(){
    txtTitle = TextEditingController(text: widget.model.post_title);
    txtLocation = TextEditingController(text: widget.model.post_location);
    txtDescription = TextEditingController(text: widget.model.post_description);
    txtService = TextEditingController(text: widget.model.post_offer);
    _mySelection = widget.model.post_cat_id;

    
  
  }

  changeImage(){
    if (_imageFile != null) {
      return Image.file(_imageFile);
      // CircleAvatar(
      //   radius: 60,
      //   // backgroundImage: NetworkImage("https://dipena.com/flutter/image_profile/"+user_img),
      //   backgroundImage: new FileImage(_imageFile),
      // );
    } else if (widget.model.post_img != null) {
      return Image.network(
            "https://dipena.com/flutter/image_content/" + widget.model.post_img);
      // CircleAvatar(
      //   radius: 60,
      //   backgroundImage: NetworkImage(
      //       "https://dipena.com/flutter/image_content/" + widget.model.post_img),
      // );
    } else if (_imageFile == null) {
      return Container(
      width: MediaQuery.of(context).size.width,
      height: 265,
      child: Image.asset('./img/placeholder.png'),
    );
      // backgroundImage: new FileImage(_imageFile),;
    }
  }

  @override
  void initState() {
    // ,
    this.getSWData();
    this.getSWData1();
    super.initState();
    setup();
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
    // setState(() {
    //   loading = true;
    // });
    if(widget.model.post_img != null && _imageFile == null){
      try {
      // var stream =
      //     http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      // var length = await _imageFile.length();
      var uri = Uri.parse("https://dipena.com/flutter/api/post/updatePostOnly.php");
      final request = http.MultipartRequest("POST", uri);
      // request.fields['post_user_id'] = user_id;
      request.fields['user_id'] = user_id;
      request.fields['post_id'] = widget.model.post_id;
      request.fields['post_title'] = post_title;
      request.fields['post_location'] = post_location;
      request.fields['post_offer'] = post_offer;
      request.fields['post_description'] = post_description;
      request.fields['post_cat_id'] = _mySelection;
      request.fields['post_img'] = widget.model.post_img;

      // request.files.add(http.MultipartFile("post_img", stream, length,
      //     filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("Image uploaded");
        setState(() {
          widget.reload();
          // loading = false;
          Navigator.pop(context);
        });
      } else {
        print("Image failed to be upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
    } else if(_imageFile != null) {
      try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse("https://dipena.com/flutter/api/post/updatePost.php");
      final request = http.MultipartRequest("POST", uri);
      // request.fields['post_user_id'] = user_id;
      request.fields['user_id'] = user_id;
      request.fields['post_id'] = widget.model.post_id;
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
          // loading = false;
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("Image failed to be upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
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

  String _mySelection1;

  final String url1 = "https://dipena.com/flutter/api/tags/showTags.php";

  List data1 = List();

  Future<String> getSWData1() async {
    var res1 = await http
        .get(Uri.encodeFull(url1), headers: {"Accept": "application/json"});
    var resBody = json.decode(res1.body);

    setState(() {
      data1 = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  // List<Tag> _tags=[];

   Widget _popUpGallery(BuildContext context) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
            content: Container()
        //     Column(
        //   // mainAxisAlignment: MainAxisAlignment.start,
        //   children: <Widget>[
        //     Text(
        //       "WELCOME TO DIPENA!",
        //       style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(18.0),
        //       child: Text(
        //         user_username,
        //         style:
        //             new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        //       ),
        //     ),
        //     Text(
        //         "Ready to Share what you could or Take what you should and change the world ?"),
        //     Padding(
        //       padding: const EdgeInsets.only(top: 18.0),
        //       child: FlatButton(
        //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //         padding: EdgeInsets.all(0),
        //         color: Colors.green,
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             new MaterialPageRoute(
        //               builder: (context) => Login(),
        //             ),
        //           );
        //         },
        //         textColor: Colors.white,
        //         shape: RoundedRectangleBorder(
        //             side: BorderSide(
        //                 color: Colors.blue, width: 1, style: BorderStyle.none),
        //             borderRadius: BorderRadius.circular(50)),
        //         child: Align(
        //             alignment: Alignment.bottomCenter, child: Text("Ready")),
        //       ),
        //     ) // Container()
        //   ],
        // )
        ),
      ),
    );
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
            'Edit Post',
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
                    child: changeImage(),
                    // _imageFile == null
                    //     ? placeholder
                    //     : Image.file(_imageFile),
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
                            child: new Text(item['category_name'] ?? '') ,
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
                      controller: txtTitle,
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
                      controller: txtLocation,
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
                      controller: txtDescription,
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
                          return "Please Insert Service";
                        }
                      },
                      // controller: controller,
                      // keyboardType: TextInputType.multiline,
                      // maxLines: null,
                       controller: txtService,
                      onSaved: (e) => post_offer = e,
                      decoration: InputDecoration(
                        labelText: 'Service',
                        
                          // hintText: "e.g landscape"
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
                          // Navigator.push(context, new MaterialPageRoute(builder: (context) => FilterChipDisplay()));
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


// class Tags extends StatefulWidget {
//   @override
//   _TagsState createState() => _TagsState();
// }

// class _TagsState extends State<Tags> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//     );
//   }
// }



class FilterChipDisplay extends StatefulWidget {
  @override
  _FilterChipDisplayState createState() => _FilterChipDisplayState();
}

class _FilterChipDisplayState extends State<FilterChipDisplay> {

  String _mySelection1;

  final String url1 = "https://dipena.com/flutter/api/tags/showTags.php";

  List data1 = List();

  Future<String> getSWData1() async {
    var res1 = await http
        .get(Uri.encodeFull(url1), headers: {"Accept": "application/json"});
    var resBody = json.decode(res1.body);

    setState(() {
      data1 = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    // ,
    // this.getSWData();
    // this.getSWData1();
    super.initState();
    _lihatDataPost();
  }

  // }

  var loading = false;
  final list = new List<TagsModel>();
  Future<void> _lihatDataPost() async {
    // await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post("https://dipena.com/flutter/api/tags/showTags.php");
    if (response.contentLength == 2) {
      //   await getPref();
      // final response =
      //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
      //   "user_id": user_id,
      //   "location_country": location_country,
      //   "location_city": location_city,
      //   "location_user_id": user_id
      // });

      // final data = jsonDecode(response.body);
      // int value = data['value'];
      // String message = data['message'];
      // String changeProf = data['changeProf'];
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new TagsModel(
          api['tag_id'],
          api['category_id'],
          api['tag_title'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.times, color: Colors.white,),
            onPressed: () {}),
        title: Text("Service", style: TextStyle(color: Colors.white,),),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.home, color: Colors.white,),
              onPressed: () {
                //
              }),
        ],
      ),
      body: Column(
        children: <Widget>[
          Align
            (
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _titleContainer("Choose Service"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Align
              (
              alignment: Alignment.centerLeft,
              child: Container(
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 3.0,
                    children: <Widget>[
                      for(var i = 0; i < list.length; i++)
                      filterChipWidget(chipName: list[i].tag_title),
                      // filterChipWidget(chipName: 'Washer/Dryer'),
                      // filterChipWidget(chipName: 'Fireplace'),
                      // filterChipWidget(chipName: 'Dogs ok'),
                      // filterChipWidget(chipName: 'Cats ok'),
                      // filterChipWidget(chipName: data1.map((item {

                      // });
                      // )
                      // ),
                     

                    ],
                  )
              ),
            ),
          ),
          Divider(color: Colors.blueGrey, height: 10.0,),
          Align
            (
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _titleContainer('Choose Neighborhoods'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Align
              (
              alignment: Alignment.centerLeft,
              child: Container(
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: <Widget>[
                    filterChipWidget(chipName: 'Upper Manhattan'),
                    filterChipWidget(chipName: 'Manhattanville'),
                    filterChipWidget(chipName: 'Harlem'),
                    filterChipWidget(chipName: 'Washington Heights'),
                    filterChipWidget(chipName: 'Inwood'),
                    filterChipWidget(chipName: 'Morningside Heights'),
                  ],
                ),
              ),
            ),
          ),
          Divider(color: Colors.blueGrey, height: 10.0,),
        ],
      ),
    );
  }

}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}

class filterChipWidget extends StatefulWidget {
  final String chipName;

  filterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  var _isSelected = false;
  
  // Widget hey() {
  //   if(_isSelected == true){
  //     print(widget.chipName);
  //   }
  // }

  // _saveQtyValue(id) async {
  //   if(_isSelected == true){
    
  //   final prefs = await SharedPreferences.getInstance();

  //   List<String> show_id = prefs.getStringList(widget.chipName) ?? List<String>();  // <-EDITED HERE
  //   print('id====$show_id');

  //   List<String> list = show_id;
  //   list.add(id);
  //   prefs.setStringList(widget.chipName, list);

  //   print('list id=====$list');
  //   }
  //   // / 5d9890c7773be00ab5b41701


  //   // final prefs = await SharedPreferences.getInstance();

  //   // List<String> show_id = prefs.getStringList(widget.chipName) ?? List<String>();  // <-EDITED HERE
  //   // print('id====$show_id');

  //   // List<String> list = show_id;
  //   // list.add(id);
  //   // prefs.setStringList(widget.chipName, list);

  //   // print('list id=====$list');


  // }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(color: Color(0xff6200ee),fontSize: 16.0,fontWeight: FontWeight.bold),
      selected: _isSelected,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            30.0),),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
          // print(widget.chipName);
          // hey();
          // _saveQtyValue(widget.chipName);
        });
      },
      // value: 
      selectedColor: Color(0xffeadffd),);
  }
}


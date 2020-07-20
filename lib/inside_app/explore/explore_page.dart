// import 'dart:convert';

// import 'package:dipena/inside_app/explore/explore_click.dart';
// import 'package:dipena/model/explore/exploreModel.dart';
// import 'package:dipena/model/post.dart';
// import 'package:dipena/url.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ExplorePage extends StatefulWidget {
//   @override
//   _ExplorePageState createState() => _ExplorePageState();
// }

// class _ExplorePageState extends State<ExplorePage> {
//   int selectedIndex = 0;

//   final List<String> categories = [
//     "Art",
//     "Design",
//     "Photography",
//     "Other",
//   ];

//   Items item1 = new Items(
//     icon: "assets/img/icon_one.jpg",
//     name: "Sasha Witt",
//     username: "@sasha",
//     post1: "assets/img/post_two.jpg",
//     post2: "assets/img/post_two.jpg",
//   );

//   Items item2 = new Items(
//     icon: "assets/img/icon_one.jpg",
//     name: "Fariha",
//     username: "@fariha",
//     post1: "assets/img/post_two.jpg",
//     post2: "assets/img/post_two.jpg",
//   );
//   Items item3 = new Items(
//     icon: "assets/img/icon_one.jpg",
//     name: "Seseorang",
//     username: "@orang",
//     post1: "assets/img/post_two.jpg",
//     post2: "assets/img/post_two.jpg",
//   );
//   Items item4 = new Items(
//     icon: "assets/img/icon_one.jpg",
//     name: "Manusia",
//     username: "@manusia",
//     post1: "assets/img/post_two.jpg",
//     post2: "assets/img/post_two.jpg",
//   );

//   final String url = "http://dipena.com/flutter/api/post/explorePost.php";

//   List data = List();

//   Future<String> getUserExplore() async {
//     var res = await http
//         .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
//     var resBody = json.decode(res.body);

//     setState(() {
//       data = resBody;
//     });

//     print(resBody);

//     return "Sucess";
//   }

//   // String postImageId;
//   // var loading = false;
//   // final list = new List<UserExplore>();
//   // Future<void> _userExplore() async {
//   //   // await getPref();
//   //   list.clear();
//   //   setState(() {
//   //     loading = true;
//   //   });
//   //   final response =
//   //       await http.post("https://dipena.com/flutter/api/post/explorePost.php");
//   //   // body: {
//   //   // "user_id": user_id,
//   //   // "user_id": widget.model.post_user_id,
//   //   // });
//   //   if (response.contentLength == 2) {
//   //     //   await getPref();
//   //     // final response =
//   //     //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
//   //     //   "user_id": user_id,
//   //     //   "location_country": location_country,
//   //     //   "location_city": location_city,
//   //     //   "location_user_id": user_id
//   //     // });

//   //     // final data = jsonDecode(response.body);
//   //     // int value = data['value'];
//   //     // String message = data['message'];
//   //     // String changeProf = data['changeProf'];
//   //   } else {
//   //     final data = jsonDecode(response.body);
//   //     data.forEach((api) {
//   //       final ab = new UserExplore(
//   //           api['user_id'],
//   //           api['user_fullname'],
//   //           api['user_username'],
//   //           // api['user_bio'],
//   //           api['user_img']);
//   //       list.add(ab);
//   //     });
//   //     setState(() {
//   //       for (var i = 0; i < list.length; i++) postImageId = list[i].user_id;
//   //       loading = false;
//   //     });
//   //   }
//   // }
//   String user_id;
//   getPref() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       user_id = preferences.getString("user_id");
//       // user_username = preferences.getString("user_username");
//       // follow_user_one = preferences.getString("user_id");
//     });
//   }

//   var loading = false;
//   final list = new List<PostContent>();
//   Future<void> _lihatDataPost() async {
//     await getPref();
//     list.clear();
//     setState(() {
//       loading = true;
//     });
//     final response = await http
//         .post("https://dipena.com/flutter/api/post/explorePost.php", body: {
//       "user_id": user_id,
//     });
//     if (response.contentLength == 2) {
//       //   await getPref();
//       // final response =
//       //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
//       //   "user_id": user_id,
//       //   "location_country": location_country,
//       //   "location_city": location_city,
//       //   "location_user_id": user_id
//       // });

//       // final data = jsonDecode(response.body);
//       // int value = data['value'];
//       // String message = data['message'];
//       // String changeProf = data['changeProf'];
//     } else {
//       final data = jsonDecode(response.body);
//       data.forEach((api) {
//         final ab = new PostContent(
//           api['post_id'],
//           api['post_user_id'],
//           api['post_cat_id'],
//           api['post_sub_cat_id'],
//           api['post_title'],
//           api['post_location'],
//           api['post_offer'],
//           api['post_description'],
//           api['post_comment_id'],
//           api['post_like_id'],
//           api['post_img'],
//           api['post_time'],
//           api['user_fullname'],
//           api['user_username'],
//           api['user_img'],
//           api['follow_status'],
//           api['like_status'],
//           api['jumlahKomen'],
//           api['jumlahLike'],
//           api['like_status_user'],
//           api['follow_status_user'],
//           api['block_status'],
//         );
//         list.add(ab);
//       });
//       setState(() {
//         // for(var i = 0; i < list.length; i++){
//         //   if(list[i].post_cat_id == "1") {
//         //     show_cat = "Painter";
//         //   } else if(list[i].post_cat_id == "2") {
//         //     show_cat = "Designer";
//         //   } else if(list[i].post_cat_id == "3") {
//         //     show_cat = "Photographer";
//         //   } else if(list[i].post_cat_id == "4") {
//         //     show_cat = "Others";
//         //   }
//         // }
//         loading = false;
//       });
//     }
//   }

//   // var loadingg = false;
//   // final listt = new List<UserExploreImages>();
//   // Future<void> _userExploreImage() async {
//   //   await _userExplore();
//   //   await postImageId;
//   //   listt.clear();
//   //   setState(() {
//   //     loadingg = true;
//   //   });
//   //   final response = await http
//   //       .post("https://dipena.com/flutter/api/post/explorePostImage.php",
//   //           // );
//   //           body: {
//   //         "user_id": postImageId,
//   //         // "user_id": widget.model.post_user_id,
//   //       });
//   //   if (response.contentLength == 2) {
//   //     //   await getPref();
//   //     // final response =
//   //     //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
//   //     //   "user_id": user_id,
//   //     //   "location_country": location_country,
//   //     //   "location_city": location_city,
//   //     //   "location_user_id": user_id
//   //     // });

//   //     // final data = jsonDecode(response.body);
//   //     // int value = data['value'];
//   //     // String message = data['message'];
//   //     // String changeProf = data['changeProf'];
//   //   } else {
//   //     final data = jsonDecode(response.body);
//   //     data.forEach((api) {
//   //       final ab = new UserExploreImages(api['post_id'], api['post_img']);
//   //       // api['user_username'],
//   //       // api['user_bio'],
//   //       // api['user_img']);
//   //       listt.add(ab);
//   //     });
//   //     setState(() {
//   //       loading = false;
//   //     });
//   //   }
//   // }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // getUserExplore();
//     // _userExplore();
//     getPref();
//     _lihatDataPost();
//     // _userExploreImage();
//     // print(postImageId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Items> myList = [item1, item2, item3, item4];
//     var color = 0xffffffff;
//     var placeholder = CircleAvatar(
//       child: ClipOval(
//         child: Image(
//           width: 50,
//           height: 50,
//           image: AssetImage(
//               // data.icon,
//               'assets/img/icon_two.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ListView(
//         primary: true,
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SafeArea(
//                 child: Container(
//                   height: MediaQuery.of(context).size.height / 6,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey[200],
//                         blurRadius: 2,
//                         spreadRadius: 0,
//                         offset: Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       ButtonTheme(
//                         minWidth: MediaQuery.of(context).size.width / 1.05,
//                         child: RaisedButton.icon(
//                           color: Color(0xFFF1F2F6),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           icon: Icon(
//                             Icons.search,
//                             color: Color(0xFFBDC3C7),
//                             size: 20,
//                           ),
//                           label: Text(
//                             "Search ...",
//                             style: TextStyle(
//                               color: Color(0xFFBDC3C7),
//                               fontSize: 12,
//                               fontFamily: "Poppins Regular",
//                             ),
//                           ),
//                           onPressed: () {},
//                         ),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width / 1.05,
//                         height: MediaQuery.of(context).size.height / 13,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: categories.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Column(
//                               children: <Widget>[
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 6),
//                                   child: OutlineButton(
//                                     borderSide: BorderSide(
//                                       color: Colors.black,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     child: Text(
//                                       categories[index],
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 13,
//                                         fontFamily: "Poppins Regular",
//                                       ),
//                                     ),
//                                     onPressed: () {},
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // GridView.count(
//               //   physics: const NeverScrollableScrollPhysics(),
//               //   shrinkWrap: true,
//               //   crossAxisCount: 2,
//               //   crossAxisSpacing: 16,
//               //   mainAxisSpacing: 16,
//               //   padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//               //   children: List.generate(
//               //     20,
//               //     (index) {
//               //       return Card(
//               //         elevation: 2,
//               //         child: Container(
//               //           child: Align(
//               //             alignment: Alignment.center,
//               //             child: new Text("1"),
//               //           ),
//               //         ),
//               //       );
//               //     },
//               //   ),
//               // ),
//               // ListView.builder(
//               //   shrinkWrap: true,
//               //   physics: const NeverScrollableScrollPhysics(),
//               //   itemCount: list.length,
//               //   itemBuilder: (context, i) {
//               //     final x = list[i];
//               //     return
//               // Container(
//               //   child: Wrap(
//               //     children: <Widget>[
//               //       for (var i = 0; i < list.length; i++)
//               //         Padding(
//               //           padding: const EdgeInsets.only(left: 0, right: 0),
//               //           child: InkWell(
//               //             onTap: () {
//               //               Navigator.push(
//               //                 context,
//               //                 new MaterialPageRoute(
//               //                   builder: (context) => ExploreClick(),
//               //                 ),
//               //               );
//               //             },
//               //             child: Container(
//               //               width: MediaQuery.of(context).size.width / 2,
//               //               height: MediaQuery.of(context).size.width / 2,
//               //               decoration: BoxDecoration(
//               //                 color: Color(color),
//               //                 borderRadius: BorderRadius.circular(10),
//               //               ),
//               //               child: Column(
//               //                 mainAxisAlignment: MainAxisAlignment.start,
//               //                 children: <Widget>[
//               //                   Row(
//               //                     children: [
//               //                       Padding(
//               //                         padding: const EdgeInsets.symmetric(
//               //                             vertical: 8, horizontal: 8),
//               //                         child:
//               //                             // x.user_img == null
//               //                             // ?
//               //                             list[i].user_img == null
//               //                                 ? placeholder
//               //                                 : CircleAvatar(
//               //                                     child: ClipOval(
//               //                                       child: Image(
//               //                                         width: 50,
//               //                                         height: 50,
//               //                                         image: NetworkImage(
//               //                                             // data.icon,
//               //                                             // 'assets/img/user_search.png'
//               //                                             // ImageUrl.imageProfile +
//               //                                             //     x.user_img),
//               //                                             ImageUrl.imageProfile +
//               //                                                 list[i].user_img),
//               //                                         fit: BoxFit.cover,
//               //                                       ),
//               //                                     ),
//               //                                   ),
//               //                       ),
//               //                       SizedBox(width: 5),
//               //                       Container(
//               //                         width: MediaQuery.of(context).size.width *
//               //                             0.2,
//               //                         child: Column(
//               //                           crossAxisAlignment:
//               //                               CrossAxisAlignment.start,
//               //                           children: <Widget>[
//               //                             Text(
//               //                               // data.name,
//               //                               // "Hai",
//               //                               // data['user_fullname'],
//               //                               // x.user_fullname,
//               //                               list[i].user_fullname,
//               //                               style: TextStyle(
//               //                                 color: Colors.black,
//               //                                 fontSize: 13,
//               //                                 fontFamily: "Poppins Semibold",
//               //                               ),
//               //                               maxLines: 1,
//               //                               softWrap: false,
//               //                               overflow: TextOverflow.ellipsis,
//               //                             ),
//               //                             Text(
//               //                               // x.user_username,
//               //                               list[i].user_username,
//               //                               // data['user_username'],
//               //                               style: TextStyle(
//               //                                 color: Color(0xFF7F8C8D),
//               //                                 fontSize: 13,
//               //                                 fontFamily: "Poppins Regular",
//               //                               ),
//               //                               maxLines: 1,
//               //                               softWrap: false,
//               //                               overflow: TextOverflow.ellipsis,
//               //                             ),
//               //                           ],
//               //                         ),
//               //                       ),
//               //                     ],
//               //                   ),
//               //                   SizedBox(height: 10),
//               //                   Row(
//               //                     mainAxisAlignment: MainAxisAlignment.center,
//               //                     children: [
//               //                       // for (var i = 0; i < listt.length; i++)
//               //                       // listt.isEmpty
//               //                       // ?
//               //                       Container(
//               //                         width: 60,
//               //                         height: 60,
//               //                         color: Colors.grey,
//               //                         foregroundDecoration: BoxDecoration(
//               //                           image: DecorationImage(
//               //                             image: AssetImage(
//               //                                 // data.post1,
//               //                                 'assets/img/user_search.png'),
//               //                             fit: BoxFit.fill,
//               //                           ),
//               //                         ),
//               //                       ),
//               //                       // :
//               //                       //  Container(
//               //                       //     width: 60,
//               //                       //     height: 60,
//               //                       //     color: Colors.grey,
//               //                       //     foregroundDecoration:
//               //                       //         BoxDecoration(
//               //                       //       image: DecorationImage(
//               //                       //         image: NetworkImage(
//               //                       //             // data.post1,
//               //                       //             ImageUrl.imageContent +
//               //                       //                 listt[i].post_img),
//               //                       //         fit: BoxFit.fill,
//               //                       //       ),
//               //                       //     ),
//               //                       //   ),
//               //                       SizedBox(width: 10),
//               //                       Container(
//               //                         width: 60,
//               //                         height: 60,
//               //                         color: Colors.grey,
//               //                         foregroundDecoration: BoxDecoration(
//               //                           image: DecorationImage(
//               //                             image: AssetImage(
//               //                                 // data.post2,
//               //                                 'assets/img/user_search.png'),
//               //                             fit: BoxFit.fill,
//               //                           ),
//               //                         ),
//               //                       ),
//               //                     ],
//               //                   ),
//               //                 ],
//               //               ),
//               //             ),
//               //           ),
//               //         ),
//               //     ],
//               //   ),
//               //   //     );
//               //   //   },
//               //   // ),
//               //   // GridView.count(
//               //   //     shrinkWrap: true,
//               //   //     physics: const NeverScrollableScrollPhysics(),
//               //   //     childAspectRatio: 1.0,
//               //   //     padding: EdgeInsets.only(left: 15, right: 15),
//               //   //     crossAxisCount: 2,
//               //   //     crossAxisSpacing: 15,
//               //   //     mainAxisSpacing: 15,
//               //   //     children: data.map((data) {
//               //   //       return InkWell(
//               //   //         onTap: () {
//               //   //           Navigator.push(
//               //   //             context,
//               //   //             new MaterialPageRoute(
//               //   //               builder: (context) => ExploreClick(),
//               //   //             ),
//               //   //           );
//               //   //         },
//               //   //         child: Container(
//               //   //           decoration: BoxDecoration(
//               //   //             color: Color(color),
//               //   //             borderRadius: BorderRadius.circular(10),
//               //   //           ),
//               //   //           child: Column(
//               //   //             mainAxisAlignment: MainAxisAlignment.start,
//               //   //             children: <Widget>[
//               //   //               Row(
//               //   //                 children: [
//               //   //                   Padding(
//               //   //                     padding: const EdgeInsets.symmetric(
//               //   //                         vertical: 8, horizontal: 8),
//               //   //                     child: data['user_img'] == null
//               //   //                         ? placeholder
//               //   //                         : CircleAvatar(
//               //   //                             child: ClipOval(
//               //   //                               child: Image(
//               //   //                                 width: 50,
//               //   //                                 height: 50,
//               //   //                                 image: NetworkImage(
//               //   //                                     // data.icon,
//               //   //                                     // 'assets/img/user_search.png'
//               //   //                                     ImageUrl.imageProfile +
//               //   //                                         data['user_img']),
//               //   //                                 fit: BoxFit.cover,
//               //   //                               ),
//               //   //                             ),
//               //   //                           ),
//               //   //                   ),
//               //   //                   SizedBox(width: 5),
//               //   //                   Container(
//               //   //                     width:
//               //   //                         MediaQuery.of(context).size.width * 0.2,
//               //   //                     child: Column(
//               //   //                       crossAxisAlignment:
//               //   //                           CrossAxisAlignment.start,
//               //   //                       children: <Widget>[
//               //   //                         Text(
//               //   //                           // data.name,
//               //   //                           // "Hai",
//               //   //                           data['user_fullname'],
//               //   //                           style: TextStyle(
//               //   //                             color: Colors.black,
//               //   //                             fontSize: 13,
//               //   //                             fontFamily: "Poppins Semibold",
//               //   //                           ),
//               //   //                           maxLines: 1,
//               //   //                           softWrap: false,
//               //   //                           overflow: TextOverflow.ellipsis,
//               //   //                         ),
//               //   //                         Text(
//               //   //                           data['user_username'],
//               //   //                           style: TextStyle(
//               //   //                             color: Color(0xFF7F8C8D),
//               //   //                             fontSize: 13,
//               //   //                             fontFamily: "Poppins Regular",
//               //   //                           ),
//               //   //                           maxLines: 1,
//               //   //                           softWrap: false,
//               //   //                           overflow: TextOverflow.ellipsis,
//               //   //                         ),
//               //   //                       ],
//               //   //                     ),
//               //   //                   ),
//               //   //                 ],
//               //   //               ),
//               //   //               SizedBox(height: 10),
//               //   //               Row(
//               //   //                 mainAxisAlignment: MainAxisAlignment.center,
//               //   //                 children: [
//               //   //                   Container(
//               //   //                     width: 60,
//               //   //                     height: 60,
//               //   //                     color: Colors.grey,
//               //   //                     foregroundDecoration: BoxDecoration(
//               //   //                       image: DecorationImage(
//               //   //                         image: AssetImage(
//               //   //                             // data.post1,
//               //   //                             'assets/img/user_search.png'),
//               //   //                         fit: BoxFit.fill,
//               //   //                       ),
//               //   //                     ),
//               //   //                   ),
//               //   //                   SizedBox(width: 10),
//               //   //                   Container(
//               //   //                     width: 60,
//               //   //                     height: 60,
//               //   //                     color: Colors.grey,
//               //   //                     foregroundDecoration: BoxDecoration(
//               //   //                       image: DecorationImage(
//               //   //                         image: AssetImage(
//               //   //                             // data.post2,
//               //   //                             'assets/img/user_search.png'),
//               //   //                         fit: BoxFit.fill,
//               //   //                       ),
//               //   //                     ),
//               //   //                   ),
//               //   //                 ],
//               //   //               ),
//               //   //             ],
//               //   //           ),
//               //   //         ),
//               //   //       );
//               //   //     }).toList()),
//               // ),
//               loading
//                   ? Center(child: CircularProgressIndicator())
//                   : StaggeredGridView.countBuilder(
//                       primary: false,
//                       // physics: const AlwaysScrollableScrollPhysics(),
//                       crossAxisCount: 2,
//                       itemCount: 10,
//                       shrinkWrap: true,
//                       itemBuilder: (BuildContext context, int index) {
//                         final x = list[index];
//                         return Container(
//                           child: Column(
//                             children: <Widget>[
//                               // for (var i = 0; i < list.length; i++)
//                               // Padding(
//                               //   padding:
//                               //       const EdgeInsets.only(left: 0, right: 0),
//                               //   child:
//                               InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     new MaterialPageRoute(
//                                       builder: (context) => ExploreClick(),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   // width: MediaQuery.of(context).size.width / 2,
//                                   // height: MediaQuery.of(context).size.width / 2,
//                                   decoration: BoxDecoration(
//                                     color: Color(color),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child:
//                                       //  Padding(
//                                       //   padding: const EdgeInsets.only(
//                                       //       left: 5, right: 5),
//                                       //   child:
//                                       //  Card(
//                                       //   elevation: 4,
//                                       //   child:
//                                       Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 8, horizontal: 8),
//                                             child: x.user_img == null
//                                                 ? placeholder
//                                                 : CircleAvatar(
//                                                     child: ClipOval(
//                                                       child: Image(
//                                                         width: 50,
//                                                         height: 50,
//                                                         image: NetworkImage(
//                                                             ImageUrl.imageProfile +
//                                                                 x.user_img),
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                   ),
//                                           ),
//                                           SizedBox(width: 5),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.2,
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Text(
//                                                   // "nama",
//                                                   x.user_fullname,
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 13,
//                                                     fontFamily:
//                                                         "Poppins Semibold",
//                                                   ),
//                                                   maxLines: 1,
//                                                   softWrap: false,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                                 Text(
//                                                   // "username",
//                                                   x.user_username,
//                                                   style: TextStyle(
//                                                     color: Color(0xFF7F8C8D),
//                                                     fontSize: 13,
//                                                     fontFamily:
//                                                         "Poppins Regular",
//                                                   ),
//                                                   maxLines: 1,
//                                                   softWrap: false,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 10),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 5),
//                                         child: Image(
//                                           image: NetworkImage(
//                                               // post,
//                                               ImageUrl.imageContent +
//                                                   x.post_img),
//                                           // width:
//                                           //     MediaQuery.of(context).size.width /
//                                           //         2,
//                                           fit: BoxFit.fill,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   // ),
//                                 ),
//                               ),
//                               // ),
//                               // ),
//                             ],
//                           ),
//                         );
//                       },
//                       staggeredTileBuilder: (int index) =>
//                           new StaggeredTile.count(1, index.isEven ? 1.5 : 1.8),
//                       // mainAxisSpacing: 10.0,
//                       // crossAxisSpacing: 10.0,
//                     )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Items {
//   String icon;
//   String name;
//   String username;
//   String post1;
//   String post2;

//   Items({
//     this.icon,
//     this.name,
//     this.username,
//     this.post1,
//     this.post2,
//   });
// }

import 'dart:convert';

import 'package:dipena/inside_app/explore/explore_category/category_page.dart';
import 'package:dipena/inside_app/explore/explore_click.dart';
import 'package:dipena/inside_app/explore/search/search_page.dart';
import 'package:dipena/model/explore/exploreModel.dart';
import 'package:dipena/model/navigateCat.dart';
import 'package:dipena/model/post.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int selectedIndex = 0;

  // final List<String> categories = [
  //   "Art",
  //   "Design",
  //   "Photography",
  //   "Other",
  // ];

  List<Category> categories = [
    Category(
      '1',
      'Painter',
    ),
    Category(
      '2',
      'Designer',
    ),
    Category(
      '3',
      'Photographer',
    ),
    Category(
      '4',
      'Others',
    ),
  ];

  Items item1 = new Items(
    icon: "assets/img/icon_one.jpg",
    name: "Sasha Witt",
    username: "@sasha",
    post1: "assets/img/post_two.jpg",
    post2: "assets/img/post_two.jpg",
  );

  Items item2 = new Items(
    icon: "assets/img/icon_one.jpg",
    name: "Fariha",
    username: "@fariha",
    post1: "assets/img/post_two.jpg",
    post2: "assets/img/post_two.jpg",
  );
  Items item3 = new Items(
    icon: "assets/img/icon_one.jpg",
    name: "Seseorang",
    username: "@orang",
    post1: "assets/img/post_two.jpg",
    post2: "assets/img/post_two.jpg",
  );
  Items item4 = new Items(
    icon: "assets/img/icon_one.jpg",
    name: "Manusia",
    username: "@manusia",
    post1: "assets/img/post_two.jpg",
    post2: "assets/img/post_two.jpg",
  );

  final String url = "http://dipena.com/flutter/api/post/explorePost.php";

  List data = List();

  Future<String> getUserExplore() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  // String postImageId;
  // var loading = false;
  // final list = new List<UserExplore>();
  // Future<void> _userExplore() async {
  //   // await getPref();
  //   list.clear();
  //   setState(() {
  //     loading = true;
  //   });
  //   final response =
  //       await http.post("https://dipena.com/flutter/api/post/explorePost.php");
  //   // body: {
  //   // "user_id": user_id,
  //   // "user_id": widget.model.post_user_id,
  //   // });
  //   if (response.contentLength == 2) {
  //     //   await getPref();
  //     // final response =
  //     //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
  //     //   "user_id": user_id,
  //     //   "location_country": location_country,
  //     //   "location_city": location_city,
  //     //   "location_user_id": user_id
  //     // });

  //     // final data = jsonDecode(response.body);
  //     // int value = data['value'];
  //     // String message = data['message'];
  //     // String changeProf = data['changeProf'];
  //   } else {
  //     final data = jsonDecode(response.body);
  //     data.forEach((api) {
  //       final ab = new UserExplore(
  //           api['user_id'],
  //           api['user_fullname'],
  //           api['user_username'],
  //           // api['user_bio'],
  //           api['user_img']);
  //       list.add(ab);
  //     });
  //     setState(() {
  //       for (var i = 0; i < list.length; i++) postImageId = list[i].user_id;
  //       loading = false;
  //     });
  //   }
  // }
  String user_id;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      // user_username = preferences.getString("user_username");
      // follow_user_one = preferences.getString("user_id");
    });
  }

  var loading = false;
  final list = new List<PostContent>();
  Future<void> _lihatDataPost() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http
        .post("https://dipena.com/flutter/api/post/explorePost.php", body: {
      "user_id": user_id,
    });
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new PostContent(
          api['post_id'],
          api['post_user_id'],
          api['post_cat_id'],
          api['post_sub_cat_id'],
          api['post_title'],
          api['post_location'],
          api['post_offer'],
          api['post_description'],
          api['post_comment_id'],
          api['post_like_id'],
          api['post_img'],
          api['post_time'],
          api['user_fullname'],
          api['user_username'],
          api['user_img'],
          api['follow_status'],
          api['like_status'],
          api['jumlahKomen'],
          api['jumlahLike'],
          api['like_status_user'],
          api['follow_status_user'],
          api['block_status'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserExplore();
    // _userExplore();
    getPref();
    _lihatDataPost();
    // _userExploreImage();
    // print(postImageId);
  }

  String post_explore_detail_id;

  show_cat(String show_cat) {
    if (show_cat == "1") {
      return "Painter";
    } else if (show_cat == "2") {
      return "Designer";
    } else if (show_cat == "3") {
      return "Photographer";
    } else {
      return "Others";
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4];
    var color = 0xffffffff;
    var placeholder = CircleAvatar(
      child: ClipOval(
        child: Image(
          width: 50,
          height: 50,
          image: AssetImage(
              // data.icon,
              'assets/img/icon_two.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height / 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width / 1.05,
                        child: RaisedButton.icon(
                          color: Color(0xFFF1F2F6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          icon: Icon(
                            Icons.search,
                            color: Color(0xFFBDC3C7),
                            size: 20,
                          ),
                          label: Text(
                            "Search ...",
                            style: TextStyle(
                              color: Color(0xFFBDC3C7),
                              fontSize: 12,
                              fontFamily: "Poppins Regular",
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => SearchPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.05,
                        height: MediaQuery.of(context).size.height / 13,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            final x = categories[index];
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: OutlineButton(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      x.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontFamily: "Poppins Regular",
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => CategoryPage(x),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      child: Wrap(
                        children: <Widget>[
                          for (var i = 0; i < list.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    post_explore_detail_id =
                                        list[i].post_user_id;
                                  });
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) =>
                                          ExploreClick(post_explore_detail_id),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  // height: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    color: Color(color),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Card(
                                      elevation: 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                child: list[i].user_img == null
                                                    ? placeholder
                                                    : CircleAvatar(
                                                        child: ClipOval(
                                                          child: Image(
                                                            width: 50,
                                                            height: 50,
                                                            image: NetworkImage(
                                                                ImageUrl.imageProfile +
                                                                    list[i]
                                                                        .user_img),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              SizedBox(width: 5),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    RichText(
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                          text: '@',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13.0),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: list[i]
                                                                    .user_username,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                          ]),
                                                    ),
                                                    // Text(
                                                    //   // "nama",
                                                    //   list[i].user_username,
                                                    //   style: TextStyle(
                                                    //     color: Colors.black,
                                                    //     fontSize: 13,
                                                    //     fontFamily:
                                                    //         "Poppins Semibold",
                                                    //   ),
                                                    //   maxLines: 1,
                                                    //   softWrap: false,
                                                    //   overflow:
                                                    //       TextOverflow.ellipsis,
                                                    // ),
                                                    Text(
                                                      // "username",
                                                      // list[i].user_username,
                                                      show_cat(
                                                          list[i].post_cat_id),
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF7F8C8D),
                                                        fontSize: 13,
                                                        fontFamily:
                                                            "Poppins Regular",
                                                      ),
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Image(
                                              image: NetworkImage(
                                                  // post,
                                                  ImageUrl.imageContent +
                                                      list[i].post_img),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }
}

class Items {
  String icon;
  String name;
  String username;
  String post1;
  String post2;

  Items({
    this.icon,
    this.name,
    this.username,
    this.post1,
    this.post2,
  });
}

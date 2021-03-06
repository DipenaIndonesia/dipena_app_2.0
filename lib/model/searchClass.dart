class SearchClass {
  final String user_id;
  final String user_username;
  final String user_fullname;
  final String user_email;
  final String user_bio;
  final String user_img;

  SearchClass({
      this.user_id,
      this.user_username,
      this.user_fullname,
      this.user_email,
      this.user_bio,
      this.user_img,
  });

   factory SearchClass.formJson(Map <String, dynamic> json){
    return new SearchClass(
       user_id: json['user_id'],
       user_username: json['user_username'],
       user_fullname: json['user_fullname'],
       user_email: json['user_email'],
       user_bio: json['user_bio'],
       user_img: json['user_img'],
    );
  }

  
}

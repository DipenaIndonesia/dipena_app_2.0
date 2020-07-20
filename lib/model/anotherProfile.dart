class AnotherProfileData {
  final String user_id;
  final String user_fullname;
  final String user_username;
  final String user_bio;
  final String user_img;
  final String follow_status_user;

  AnotherProfileData(this.user_id,this.user_fullname, this.user_username, this.user_bio,this.user_img, this.follow_status_user);
}

class AnotherProfileFollowStatus {
  final String follow_status;

  AnotherProfileFollowStatus(this.follow_status);
}
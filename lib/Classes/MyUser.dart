
class MyUser{

  String username;
  String phoneNumber;
  bool amFollowing;
  String id;


  MyUser(this.username, this.phoneNumber, this.amFollowing, this.id);
  static MyUser fromMap(Map<String, dynamic> userMap){

    MyUser user =   MyUser(
        userMap.remove("username"),
        "",
        userMap.remove("amfollowing")??false,
      userMap.remove("user_id"),
    );
    return user;
  }
}

import 'package:donde/Store.dart';

class MyUser{
  String username;
  String phoneNumber;
  String? uniqueUsername;
//  bool amFollowing;
  RelationshipTypes relationshipType = RelationshipTypes.NONE;
  String id;
  MyUser(this.username, this.phoneNumber, this.id, int? relationshipCount){
    relationshipType = getTypeFromNum(relationshipCount);
  }
  
  
  static MyUser fromMap(Map<String, dynamic> userMap){
    MyUser user = MyUser(
        userMap.remove("username"),
        "",
        userMap.remove("user_id"),
      userMap.remove("relationshipcount"),
    );
    user.uniqueUsername = userMap.remove("unique_username");
    return user;
  }

  @override
  String toString() {
    // TODO: implement toString
    return username;
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MyUser &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
  
   RelationshipTypes getTypeFromNum(int? num){
     if(num == null){
       return RelationshipTypes.ME;
     }
    if(num == 0){
      return RelationshipTypes.NONE;
    }else if(num ==1){
      return RelationshipTypes.REQUESTED_BY_ME;
    }else if(num == 2){
      return RelationshipTypes.REQUESTED_BY_OTHER;
    }else if(num == 3){
      return RelationshipTypes.FRIEND;
    }else if(num == 5){
      return RelationshipTypes.BLOCKED;
    }
     return RelationshipTypes.NONE;
   }

   static String relTypeToButtonString(RelationshipTypes relType){
     switch (relType){
       case RelationshipTypes.FRIEND:
         return "friend";
         break;
       case RelationshipTypes.NONE:
         return "request";
         break;
       case RelationshipTypes.REQUESTED_BY_ME:
         return "requested";
         break;
       case RelationshipTypes.REQUESTED_BY_OTHER:
         return "accept";
         break;
       case RelationshipTypes.ME:
         return "";
         case RelationshipTypes.BLOCKED:
       return "";
     }
   }
  
}

enum RelationshipTypes{
  FRIEND,NONE,REQUESTED_BY_ME,REQUESTED_BY_OTHER, ME, BLOCKED
}
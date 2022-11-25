import 'package:firebase_auth/firebase_auth.dart';

import '../models/direction_details_info.dart';
import '../models/user_model.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //online-active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken = "key=AAAAtL8yWkU:APA91bEdNsDC5VcNdi-7o9iY-2j4RocNIb0DNssnqw9JVJiyYA1ZG6WlbPM0uwJcmmXEBFmd6oLYAZvnJnx4e4YoDngUN5nuggLPiQCu5koyXQDr3kOL4F3mhMwK_kW8eVs84vajm40Y";
String userDropOffAddress = "";
String driverCarDetails="";
String driverName="";
String driverPhone="";
double countRatingStars=0.0;
String titleStarsRating="";
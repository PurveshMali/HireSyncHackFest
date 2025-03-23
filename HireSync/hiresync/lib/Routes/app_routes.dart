import 'package:flutter/material.dart';
import 'package:hiresync/email/forgotpswd.dart';
import 'package:hiresync/employeer/employeer_details.dart';
import 'package:hiresync/employeer/homepage_employeer.dart';
import 'package:hiresync/employeer/permissionlocationEmployeer.dart';
import 'package:hiresync/employeer/signin_employeer.dart';
import 'package:hiresync/sceens/landingpage.dart';
import 'package:hiresync/util/wrapper.dart';
import 'package:hiresync/worker/homepageWorker.dart';
import 'package:hiresync/worker/location/worker_locationpermission.dart';
import 'package:hiresync/worker/signin_worker.dart';
import 'package:hiresync/worker/signup_worker.dart';
import 'package:hiresync/worker/worker_details.dart/worker_details.dart';

class Approutes {
  static const String landingPage = '/';
  static const String signin_worker = '/signin_worker';
  static const String sign_employeer = '/sign_employeer';
  static const String forgotPswd = '/forgotPswd';
  static const String wrapper = '/wrapper';
  static const String homepage_worker = '/homepage_worker';
  static const String signupworker = '/signupworker';
  static const String workerDetails = '/workerDetails';
  static const String workerlocationpermission = '/workerlocationpermission';
  static const String employeerdetails = '/employeerdetails';
  static const String wrapperEmployeer = '/wrapperEmployeer';
  static const String homepage_employeer = '/homepage_employeer';
  static const String employeerlocationPermission = '/employeerlocationPermission';
  static const String wrapperWorker = "/home_worker"; 


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingPage:
        return MaterialPageRoute(builder: (_) => const Landingpage());
      case signin_worker:
        return MaterialPageRoute(builder: (_) => SigninWorker());
      case sign_employeer:
        return MaterialPageRoute(builder: (_) => SigninEmployeer());
      case forgotPswd:
        return MaterialPageRoute(builder: (_) => Forgotpswd());
      case wrapper:
        return MaterialPageRoute(builder: (_) => Wrapper());
      case homepage_worker:
        return MaterialPageRoute(builder: (_) => Homepageworker());
      case signupworker:
        return MaterialPageRoute(builder: (_) => SignupWorker());
      case workerDetails:
        return MaterialPageRoute(builder: (_) => WorkerDetails());
      case workerlocationpermission:
        return MaterialPageRoute(builder: (_) => WorkerLocationpermission());
      case employeerdetails:
        return MaterialPageRoute(builder: (_) => EmployeerDetails());
      case wrapperEmployeer:
        return MaterialPageRoute(builder: (_) => Wrap());
      case homepage_employeer:
        return MaterialPageRoute(builder: (_) => HomepageEmployeer());
      case employeerlocationPermission:
        return MaterialPageRoute(builder: (_) => Permissionlocationemployeer());
        // case ListOfAttendantforChat:
        //   return MaterialPageRoute(builder: (_) => Listofattendantforchat());
        // case ChatBoxUser:
        //   if (settings.arguments is Map<String, dynamic>) {
        //     final args = settings.arguments as Map<String, dynamic>;
        //     return MaterialPageRoute(
        //       builder: (_) => Chatbox(
        //         senderId: args['senderId'],
        //         receiverId: args['receiverId'],
        //         receiverName: args['receiverName'],
        //         chatId: args['chatId'],
        //       ),
        //     );
        //   }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Page not found!')),
      ),
    );
  }
}

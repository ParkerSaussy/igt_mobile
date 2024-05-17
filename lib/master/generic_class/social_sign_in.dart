import 'package:google_sign_in/google_sign_in.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../general_utils/common_stuff.dart';

/*This class used for the google signin auth
user can easly used google sign in using below class*/

class GoogleSignInClass {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      RequestParams.email,
    ],
  );

  Future<GoogleSignInAccount?> googleSignIn() async {
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      _googleSignIn.signOut();
    }
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        return account;
      }
    } catch (error) {
      printMessage("error $error");
      return null;
    }
    return null;
  }
}

/*
This class used for the Apple signIn auth
Enable apple signIn your project in xcode for iPhone
*/
/*class AppleSignInClass {
  Future<Map<String, dynamic>> appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final AuthCredential authCredential = OAuthProvider(Constants.apple)
          .credential(
              accessToken: credential.authorizationCode,
              idToken: credential.identityToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      if (userCredential != null) {
        return {
          Constants.CFamilyName: credential.familyName,
          Constants.CGivenName: credential.givenName,
          Constants.CEmail: userCredential.user.email
        };
      } else {
        print('Apple ======== - null');
      }
    } catch (error) {
      print('Apple Error - $error');
    }
  }
}*/

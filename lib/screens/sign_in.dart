import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rtchat/models/user.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

final url = Uri.https('chat.rtirl.com', '/auth/twitch/redirect');

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Image(width: 160, image: AssetImage('assets/logo.png')),
      Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: Text("RealtimeChat",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white))),
      SizedBox(
        width: 400,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF6441A5)),
              ),
              child: Consumer<UserModel>(builder: (context, user, child) {
                return const Text("Sign in with Twitch");
              }),
              onPressed: () async {
                final user = Provider.of<UserModel>(context, listen: false);
                if (user.isSignedIn()) {
                  user.signOut();
                } else {
                  final result = await FlutterWebAuth.authenticate(
                      url: url.toString(), callbackUrlScheme: "com.rtirl.chat");
                  final token = Uri.parse(result).queryParameters['token'];
                  if (token != null) {
                    user.signIn(token);
                  } else {
                    FirebaseCrashlytics.instance.log("failed to sign in");
                  }
                }
              },
            )),
      ),
    ]);
  }
}

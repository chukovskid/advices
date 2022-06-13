import 'package:cloud_functions/cloud_functions.dart';

class CallMethods {
  static Future<Map<String, dynamic>?> makeCloudCall(String channelName) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createCallsWithTokens');
      // dynamic resp = await callable.call();

      dynamic resp = await callable.call(<String, dynamic>{
        'channelName': channelName,
      });

      Map<String, dynamic> res = {
        'token': resp.data['data']['token'],
        'channelId': resp.data['data']['channelId']
      };
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

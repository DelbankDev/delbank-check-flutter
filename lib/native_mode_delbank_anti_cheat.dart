import 'package:flutter/services.dart';

const channelName = "delbank.sdk/antiCheat";
const eventStartCheck = "startCheck";

const keyResultId = "authorizationId";
const keyResultErrorCode = "code";
const keyResultErrorDescription = "description";

const keySuccess = "sucess";
const keyFailure = "fail";

const platform = MethodChannel(channelName);

void startAntiCheat({
  required Map params,
  required Function(Map sucess) onSuccess,
  required Function(Map error) onError,
}) async {
  try {
    Map result =
        await platform.invokeMethod<Map>(eventStartCheck, params) as Map;
    if (result.containsKey(keyResultId)) {
      onSuccess(result);
    } else {
      onError(result);
    }
  } on PlatformException catch (e) {
    Map genericError = <String, Object>{};
    genericError[keyResultErrorCode] = -1;
    genericError[keyResultId] = "";
    genericError[keyResultErrorDescription] = e.message;
    onError(genericError);
  }
}

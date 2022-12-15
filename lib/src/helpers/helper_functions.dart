import 'package:flutter/cupertino.dart';

void postFrameCallback(VoidCallback callback){
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    callback.call();
  });
}
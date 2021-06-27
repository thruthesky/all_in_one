import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionDisplay extends StatelessWidget {
  const ConnectionDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Yo Connection'),
          StreamBuilder(
              stream: Connectivity().onConnectivityChanged,
              builder: (_, snapshot) {
                print(snapshot);
                if (snapshot.hasData == false) return CircularProgressIndicator.adaptive();

                late String type;
                ConnectivityResult connectivityResult = snapshot.data as dynamic;
                if (connectivityResult == ConnectivityResult.mobile) {
                  type = "Mobile Network";
                } else if (connectivityResult == ConnectivityResult.wifi) {
                  type = "Wifi Network";
                } else if (connectivityResult == ConnectivityResult.none) {
                  type = "Offline";
                } else {
                  type = 'Offline';
                }
                return Text(type);
              }),
        ],
      ),
    );
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetAwareWidget extends StatefulWidget {
  final Widget child;
  final Widget noInternetWidget;

  const InternetAwareWidget({
    Key? key,
    required this.child,
    required this.noInternetWidget,
  }) : super(key: key);

  @override
  _InternetAwareWidgetState createState() => _InternetAwareWidgetState();
}
class _InternetAwareWidgetState extends State<InternetAwareWidget> {
  bool _hasInternet = true;
  @override
  void initState() {
    super.initState();
    _checkInternet();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (!mounted) return;
      _hasInternet = result != ConnectivityResult.none;
      setState(() {});
    });
  }
  Future<void> _checkInternet() async {
    final result = await Connectivity().checkConnectivity();
    if (!mounted) return;
    _hasInternet = result != ConnectivityResult.none;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      return widget.noInternetWidget;
    }
    return widget.child;
  }
}

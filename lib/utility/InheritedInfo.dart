import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StateContainerState extends State<StateContainer> {
  /* Properities that will be persisted on the side of the Admin */
  String uid;

  /*Properties that will be persisted on the side of the user */
  List notifications = [];
  int notificationCounter =
  0; //used to show the number of notifications at the bottom
  bool isThereConnectionError = false;
  bool isThereAnExplicitConnectionError = false;
  bool isThereANetworkConnectionError = false;

  // You can (and probably will) have methods on your StateContainer
  // These methods are then used through our your app to
  // change state.
  // Using setState() here tells Flutter to repaint all the
  // Widgets in the app that rely on the state you've changed.

  //-----methods go here-----
  void setConnectionErrorStatus(bool e) {
    setState(() {
      isThereConnectionError = e;
    });
  }

  //used to add to the notifications of the user
  void addToNotifications(Map notification) {
    setState(() {
      this.notifications.add(notification);
      this.notificationCounter += 1;
    });
  }

  void removeNotification(Map notification) {
    setState(() {
      this.notifications.remove(notification);
    });
  }

  void initNotifications(List notifications) {
    setState(() {
      this.notifications = notifications;
    });
  }
  // Simple build method that just passes this state through
  // your InheritedWidget
  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  // Data is your entire state. In our case just 'User'
  final StateContainerState data;

  // You must pass through a child and your state.
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
  // You must pass through a child.
  final Widget child;
  final String uid;


  StateContainer(
      {@required this.child,
        this.uid});

  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
    as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

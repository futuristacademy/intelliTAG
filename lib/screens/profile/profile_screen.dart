import 'dart:collection';
import 'dart:io';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:intelliTAG/utility/InheritedInfo.dart';
import 'package:intelliTAG/utility/notifiers.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


class ProfileScreen extends StatefulWidget{
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int counter = 0;
  List<String> screenTitles = ['Profile', 'Scan'];
  

  Widget changeScreen(int currentIndex) {
    switch (currentIndex) {
      case 0:

        return ProfileUI();
      case 1:
        return Scanner();
    }
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
      title: Text(screenTitles[counter]),
    ),
    body: changeScreen(counter),
    bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(MdiIcons.qrcode),
            title: Text('Check-In'),
          ),
        ],
        currentIndex:  counter,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int v){
          setState((){
            counter = v;
            });
        },
          
    ));
  }
}

class ProfileUI extends StatelessWidget{



  Widget build(BuildContext context){
    return Container(child: Text("hei"),);


  }
}



class Scanner extends StatefulWidget {
  State<Scanner> createState() {
    return _ScannerState();
  }
}

class _ScannerState extends State<Scanner> {
  HashSet<String> _scannedUids; //used to keep track of already scanned codes
  CameraController _mainCamera; //camera that will give us the feed
  bool _isCameraInitalized = false;
  bool _cameraPermission = true;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();


 

  void runStream() {
    
    _scannedUids = new HashSet();
    bool turnOffStream = false;
    
    _mainCamera.startImageStream((image) {
      
      FirebaseVisionImageMetadata metadata;
      
      //metadata tag for the for image format.
      //source https://github.com/flutter/flutter/issues/26348
      metadata = FirebaseVisionImageMetadata(
          rawFormat: image.format.raw,
          size: Size(image.width.toDouble(), image.height.toDouble()),
          planeData: image.planes
              .map((plane) => FirebaseVisionImagePlaneMetadata(
                  bytesPerRow: plane.bytesPerRow,
                  height: plane.height,
                  width: plane.width))
              .toList());

      FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);

      FirebaseVision.instance
          .barcodeDetector()
          .detectInImage(visionImage)
          .then((barcodes) {
        for (Barcode barcode in barcodes) {
          print("Scanned");
         
        }
      }).catchError((error) {
        if (error.runtimeType == CameraException) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Issues with Camera"),
          ));
        }
      });
    });
  }

  //get a list of permissions that are still denied
  Future<List> getPermissionsThatNeedToBeChecked(
      PermissionGroup cameraPermission,
      PermissionGroup microphonePermission) async {
    PermissionStatus cameraPermStatus =
        await PermissionHandler().checkPermissionStatus(cameraPermission);
    PermissionStatus microphonePermStatus =
        await PermissionHandler().checkPermissionStatus(microphonePermission);
    List<PermissionGroup> stillNeedToBeGranted = [];
    if (cameraPermStatus == PermissionStatus.denied) {
      stillNeedToBeGranted.add(cameraPermission);
    }
    if (microphonePermStatus == PermissionStatus.denied) {
      stillNeedToBeGranted.add(microphonePermission);
    }
    return stillNeedToBeGranted;
  }

  //create camera based on permissions
  void createCamera() {
    getPermissionsThatNeedToBeChecked(
            PermissionGroup.camera, PermissionGroup.microphone)
        .then((permList) {
      if (permList.length == 0) {
        //get all the avaliable cameras
        availableCameras().then((allCameras) {
          _mainCamera = CameraController(allCameras[0], ResolutionPreset.low);

          _mainCamera.initialize().then((_) {
            if (!mounted) {
              return;
            }
            setState(() {
              _isCameraInitalized = true;
            }); //show the actual camera
            runStream();
          }).catchError((onError) {
            //permission denied
            if (onError.toString().contains("permission not granted")) {
              setState(() {
                _cameraPermission = false;
              });
            }
          });
        });
      } else {
        setState(() {
          _cameraPermission = false;
        });
      }
    });
  }

  //request permissions and check until all are requestsed
  void requestPermStatus(List<PermissionGroup> permissionGroups) {
    bool allAreAccepted = true;
    PermissionHandler()
        .requestPermissions(permissionGroups)
        .then((permissionResult) {
      permissionResult.forEach((k, v) {
        if (v == PermissionStatus.denied) {
          allAreAccepted = false;
        }
      });
      if (allAreAccepted) {
        setState(() {
          _cameraPermission = true;
        });
        createCamera();
      }
    });
  }

  void initState() {
    super.initState();
    createCamera();
  }

  void dispose() {
    if(_mainCamera != null){
      _mainCamera.dispose();
    }
    
    super.dispose();
  }

  Widget build(BuildContext context) {

   
    //check first whether camera is init
    if (_isCameraInitalized) {
        //check whether camera is already is streaming images
        if (!_mainCamera.value.isStreamingImages) {
          runStream();
        }
        //if there is an error, then stop the stream
        else if (StateContainer.of(context).isThereConnectionError) {
          _mainCamera.stopImageStream();
        }
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    _scannedUids = new HashSet();

   

    return Stack(children: <Widget>[
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                
                  Container(
                    height: screenHeight * 0.75,
                    width: screenWidth * 0.9,
                    child: _cameraPermission
                        ? _isCameraInitalized
                            ? Platform.isAndroid
                                ? RotationTransition(
                                    child: CameraPreview(_mainCamera),
                                    turns: AlwaysStoppedAnimation(270 / 360))
                                : CameraPreview(_mainCamera)
                            : Container(
                                child: Text("Loading"),
                              )
                        : GestureDetector(
                            onTap: () {
                              getPermissionsThatNeedToBeChecked(
                                      PermissionGroup.camera,
                                      PermissionGroup.microphone)
                                  .then((permGroupList) {
                                requestPermStatus(permGroupList);
                              });
                            },
                            child: Container(
                              child: Text(Platform.isAndroid
                                  ? "You have denied camera permissions, please accept them by clicking on this text"
                                  : "You have denied camera permissions, please go to settings to activate them"),
                            )),
                  ),
                ],
              ),
            ),
          ),
          if (StateContainer.of(context).isThereConnectionError)
            ConnectionError(),
         
        ]);
  }

}
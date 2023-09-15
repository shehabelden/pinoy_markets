import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:morgancopy/data/modules/UserData.dart';
import 'package:morgancopy/data/modules/subscription.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class MarketsData extends ChangeNotifier {
  bool colorMode = true;
  Map<String, dynamic> categories = {};
  List<String> lastCat = [];
  Subscription? subscription;
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> mainChat = [];
  List<XFile?> selectedImages = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> profile = {};
  Map<String, dynamic>? dataCategories;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? location;
  List<UserData> usersNearMe = [];
  List<UserData> allUsersNearMe = [];
  bool loading = true;
  String? id;
  double? myLat;
  double? myLong;
  List allChat = [];
  List<String> options = ["languge", "colors"];
  String? selct;
  var x;
  String? status;
  Future<Position?> getLocation() async {
    bool serves = await Geolocator.isLocationServiceEnabled();
    if (!serves) {
      if (!await Geolocator.openLocationSettings()) {
        print("local serves is disaple");
        return null;
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  gitId() {
    id = auth.currentUser!.uid;
  }

  changeAppColor(bool x) {
    colorMode = x;
  }

  // add location
  addUserLocation(double? latitude, double? longitude) async {
    Map<String, dynamic> data = {
      "latitude": latitude!,
      "longitude": longitude!,
    };

    if (data.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.currentUser!.uid)
          .update(data);
    }
  }

  updateUserLocation(double? latitude, double? longitude) async {
    Map<String, dynamic> data = {
      "latitude": latitude!,
      "longitude": longitude!,
    };

    if (data.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.currentUser!.uid)
          .update(data);
    }
  }

  friendShip(searchRadius) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) => {
              myLat = value["latitude"],
              myLong = value["longitude"],
            });
    double latMin = myLat! - searchRadius;
    double latMax = myLat! + searchRadius;
    FirebaseFirestore.instance
        .collection("users")
        .where('latitude', isGreaterThan: latMin)
        .where('latitude', isLessThan: latMax)
        //.where('latitude', isLessThan: longMax)
        //.where('latitude', isGreaterThan: longMin)
        .get()
        .then((value) {
      usersNearMe = [];
      // print("this list ${location!}"),
      List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
          filterSearchResults(value.docs, myLong! - 7, myLong! + 7);
      print(list);
      for (QueryDocumentSnapshot<Map<String, dynamic>> user in list) {
        usersNearMe.add(UserData.fromJson(user.data()));
      }
      print(usersNearMe);
      notifyListeners();
    });
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> filterSearchResults(
      List<QueryDocumentSnapshot<Map<String, dynamic>>>? list,
      double? lm,
      double? lx) {
    // print(list);
    // allUsersNearMe = list;
    print(lm);
    print(lx);
    print(auth.currentUser!.uid);
    return list!
        .where((i) =>
            i.data()['longitude'] > lm &&
            i.data()['longitude'] < lx &&
            i.data()['id'] != auth.currentUser!.uid)
        .toList();
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(value.user!.uid)
            .set({
          "id": value.user!.uid,
        });
        getLocation().then((value) {
          addUserLocation(value!.latitude, value!.longitude);
        });
      });
      // Registration successful, you can navigate to the home screen or perform other actions.
    } catch (e) {
      // Handle registration errors here (e.g., invalid email, weak password).
    }
  }

  // login-------------------------------------------------------------------------------------------------
  Future<void> login(smsCode, BuildContext context) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: x, smsCode: smsCode!);
    await auth.signInWithCredential(credential).onError((error, stackTrace) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(error.toString()),
            );
          });
      return throw Exception(error);
    }).then((value) {
      FirebaseFirestore.instance.collection("users").doc(value.user!.uid).set({
        "id": value.user!.uid,
      });
      getLocation().then((value) {
        addUserLocation(value!.latitude, value!.longitude);
      });
    });
    ;
  }

  Future<void> registerUser(
    String mobile,
    BuildContext context,
  ) async {
    auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {
        x = verificationId;
        // registerWithEmailAndPassword("$mobile@gmail.com",passw);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    // notifyListeners();
  }

  // profile_view-------------------------------------------------------------------------------------------------
  Future<void> getProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) => {
                profile = {},
                profile = value.data()!,
                // print(profile),
              });
      notifyListeners();
    } catch (e) {}
  }

  userPost(String collection) async {
    try {
      FirebaseFirestore.instance
          .collectionGroup(collection)
          .where("userid", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((value) {
        print("there");
        print({value.docs.isEmpty});
      });
    } catch (e) {}
    notifyListeners();
  }

  payment() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("subscriptions")
          .get()
          .then((value) => {status = value.docs.last["status"]});
    } catch (e) {}
  }

  paymentUserInfo() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("subscriptions")
        .get()
        .then((value) {
      if (value.size != 0 && value.docs.last.data()['status'] != 'canceled') {
        subscription = Subscription.fromJson(value.docs.last.data());
      }
      print("subscription test ${subscription!.status}");
    });
    notifyListeners();
  }

  Future<Map<String, dynamic>> getCategories() async {
    QuerySnapshot<Map<String, dynamic>> catData =
        await FirebaseFirestore.instance.collection('categories').get();

    Map<String, dynamic> jsonMap = catData.docs.first.data()['categories'];
    //print(jsonMap['cars']);
    categories = jsonMap;

    loading = false;
    notifyListeners();
    print(loading);

    return jsonMap;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> userGetPost(
      String id, String cat) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collectionGroup(cat)
        .where("userId", isEqualTo: id)
        .get();
    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUser(
      String id) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> tmp = [];
    lastCat = getKeysWithNullSub(categories);
    for (String cat in lastCat) {
      tmp.addAll(await userGetPost(id, cat));
    }
    return tmp;
  }

  List<String> getKeysWithNullSub(Map<String, dynamic> value) {
    List<String> result = [];
    value.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        if (value['sub'] == null) {
          result.add(key);
        }
        result.addAll(getKeysWithNullSub(value));
      }
      print(result);
    });
    while (result.contains('sub')) {
      result.remove('sub');
    }
    return result;
  }

  userUpdate(data) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update(data);
  }

//creat_post------------------------------------------------------------------------------------------
  addPostToFirebaseFirestore(String collectionGroup, String cat,
      List<String> images, List<String> text) async {
    QuerySnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance.collectionGroup(collectionGroup).get();
    print(doc.docs.first.data());
    doc.docs.first.reference.collection(cat).add({
      "text": text,
      "userId": auth.currentUser!.uid ?? '',
      "images": images,
      "date": DateTime.now()
    });
  }

  Future<String> uploadImageToFirebaseStorage(File image, String path) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => print('Image uploaded'));
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      print(imageUrl);
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
    }
    return '';
  }

  List<String> getPathToKey(Map<dynamic, dynamic> map, dynamic targetKey) {
    List<String> path = [];

    bool search(Map<dynamic, dynamic> currentMap) {
      for (var key in currentMap.keys) {
        path.add(key.toString());
        if (key == targetKey) {
          return true;
        } else if (currentMap[key] is Map) {
          if (search(currentMap[key])) {
            return true;
          }
        }
        path.removeLast();
      }
      return false;
    }

    if (search(map)) {
      return path;
    } else {
      return [];
    }
  }

  Future<void> pickMultipleImages() async {
    try {
      if (await Permission.storage.request().isGranted) {
        final List<XFile?> pickedFiles = await ImagePicker().pickMultiImage(
          imageQuality: 80,
        );

        if (pickedFiles.isNotEmpty) {
          selectedImages.clear();
          if (pickedFiles.length > 5) {
            selectedImages = pickedFiles.sublist(0, 5);
          } else {
            selectedImages = pickedFiles;
          }
        }
        notifyListeners();
      }
    } catch (e) {
      // Handle any errors that might occur
    }
  }

  void chatSend(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("masseges").doc().set(data);
  }

  void chatGet(String receive) {
    FirebaseFirestore.instance
        .collection('messages')
        .where('sender', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((element) {
      for (var i in element.docs) chats.add(i.data());
      mainChat = chats.where((i) => i['receive'] == receive).toList();
    });
  }

  void allChatGet() async {
    QuerySnapshot<Map<String, dynamic>> x = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .get();
    allChat = [];

    for (var doc in x.docs) {
      allChat.add(doc.data());
      // check allchat value
    }
    print(allChat);

    notifyListeners();
  }

  void chatAddme(data) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(data["receive"])
        .set(data);
  }

  void chatAddhim(data) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(data["receive"])
        .collection("chats")
        .doc(data["send"])
        .set(data);
  }

  getSeller(id) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .get()
          .then((value) => {
                if (profile.isEmpty)
                  {
                    profile = value.data()!,
                  }
                // print(profile),
              });
    } catch (e) {}
    notifyListeners();
  }

  //search --------------------------------------------------------------------
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchCat(
      List<String> query, String cat) async {
    Query<Map<String, dynamic>> req =
        FirebaseFirestore.instance.collectionGroup(cat);

    for (String q in query) {
      req = req.where('text', arrayContains: q);
    }
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await req.get();
    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchAllCats(
      List<String> query, Map<String, dynamic> categories) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> tmp = [];
    List<String> lastCat = getKeysWithNullSub(categories);
    for (String cat in lastCat) {
      tmp.addAll(await searchCat(query, cat));
    }
    print(tmp);
    return tmp;
  }

  Future<void> pickProfileImages() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    print("prof iamge ${image!.path}");

    var imagePath = await uploadImageToFirebaseStorage(
        File(image!.path), 'profile/ ${auth.currentUser!.uid}');

    await userUpdate({"profileImage": imagePath});
    getProfile();
  }
}

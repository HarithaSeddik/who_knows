import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/whoknows_userdb.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class UserInfo extends StatefulWidget {
  const UserInfo({
    Key key,
  }) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  WhoKnowsUserDB userDB = WhoKnowsUserDB();
  String username = '';
  bool isOnline = false;
  File _image;
  String _uploadedFileURL;
  String profilePic = '';

  @override
  void initState() {
    super.initState();
    userDB.getDocData().then((value) {
      setState(() {
        username = value['username'] ?? '';
        isOnline = value['isOnline'] ?? false;
        profilePic = value['profilePic'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width - 40,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  children: [
                    RaisedButton(
                      shape: CircleBorder(),
                      elevation: 0,
                      color: Colors.grey[100],
                      onPressed: () async {
                        await ImagePicker()
                            .getImage(source: ImageSource.gallery)
                            .then((pickedFile) {
                          setState(() {
                            _image = File(pickedFile.path);
                          });
                        });

                        if (profilePic != '') {
                          StorageReference imageRef = await FirebaseStorage
                              .instance
                              .getReferenceFromUrl(profilePic);
                          await imageRef.delete();
                          print("Image deleted!");
                        }

                        StorageReference storageReference =
                            FirebaseStorage.instance.ref().child(
                                'profile_pics/${Path.basename(_image.path)}');
                        StorageUploadTask uploadTask =
                            storageReference.putFile(_image);
                        await uploadTask.onComplete;
                        print('File Uploaded');
                        storageReference.getDownloadURL().then((fileURL) {
                          setState(() {
                            _uploadedFileURL = fileURL;
                            // set image in database
                            userDB.setValue("profilePic", _uploadedFileURL);
                          });

                          userDB.getDocData().then((value) {
                            setState(() {
                              profilePic = value['profilePic'] ?? '';
                            });
                          });
                        });
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profilePic == ''
                            ? AssetImage("assets/images/blank.png")
                            : NetworkImage(profilePic),
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data.data() != null &&
                            snapshot.data.data()['isOnline'] != isOnline) {
                          isOnline = snapshot.data.data()['isOnline'];

                          return Positioned(
                            top: 80,
                            left: 90,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  shape: BoxShape.circle,
                                  color: isOnline ? Colors.green : Colors.grey),
                            ),
                          );
                        } else {
                          return Positioned(
                            top: 80,
                            left: 90,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  shape: BoxShape.circle,
                                  color: isOnline ? Colors.green : Colors.grey),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: new Image.asset(
                        'assets/images/icons/mgpl.png',
                        height: 20.0,
                        width: 20.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser.displayName ?? "",
                      style: TextStyle(
                          fontSize: 18,
                          color: appTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("@$username",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

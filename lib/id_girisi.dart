import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_live_location_gmap/location_map.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'service/firebase_auth.dart';

class IdGirisi extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String getCurrentUser() {
    //GİRİŞ YAPAN KULLANICI BİLGİLERİNİ ALIYOR, BİLET BU KİŞİNİN HESABINA VERİLECEK
    final User user = firebaseAuth.currentUser;
    final uid = user.uid;
    return uid;
  }

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double genislik = MediaQuery.of(context).size.width;
    double yukseklik = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF4F3F9),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Container(
                  width: genislik * 0.75,
                  height: yukseklik * 0.50,
                  child: Form(
                    child: Column(
                      key: _formKey,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(19.0),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Takip Etmek İstediğiniz UID',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: 45,
                            width: genislik * 0.3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(21.0),
                                ),
                                primary: Color(0xffFF7E7E),
                              ),
                              onPressed: () {
                                if (emailController.text.isNotEmpty) {
                                  FirebaseFirestore.instance
                                      .collection("Konumlar")
                                      .where('uid',
                                          isEqualTo:
                                              emailController.text.trim())
                                      .get()
                                      .then((QuerySnapshot snapshot) {
                                    if (snapshot.docs.isNotEmpty) {
                                      snapshot.docs.forEach((f) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LocationMap(
                                                      arkadasUid:
                                                          emailController.text
                                                              .trim(),
                                                    )));
                                      });
                                    } else {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('HATA'),
                                          content: const Text(
                                              'Kullanıcı Bulunamadı'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('Tamam'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  });
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('HATA'),
                                      content:
                                          const Text('Lütfen değer giriniz'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('Tamam'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text('Takip Et',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(height: yukseklik * 0.05),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              alignment: Alignment.center,
                              height: 45,
                              width: genislik * 0.7,
                              child: Text(
                                "Benim UID'm :\n" + getCurrentUser(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  height: 45,
                                  width: genislik * 0.4,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(21.0),
                                        ),
                                        primary: Colors.greenAccent),
                                    onPressed: () {
                                      Share.share(getCurrentUser());
                                    },
                                    child: Text(
                                      'UID Paylaş',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  height: 45,
                                  width: genislik * 0.3,
                                  child: ElevatedButton(
                                    // Kayıt ol butonu
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(21.0),
                                        ),
                                        primary: Colors.lightBlueAccent),
                                    onPressed: () {
                                      context
                                          .read<AuthenticationService>()
                                          .signOut();
                                      /*Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Giris()));*/
                                    },
                                    child: Text(
                                      'Çıkış',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

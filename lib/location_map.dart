import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'location_provider.dart';
import 'main.dart';
import 'service/firebase_auth.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({Key key, this.arkadasUid}) : super(key: key);

  @override
  _LocationMapState createState() => _LocationMapState();
  final String arkadasUid;
}

class _LocationMapState extends State<LocationMap> {
  bool konum;
  void getPaylasim() {
    FirebaseFirestore.instance
        .collection("Konumlar")
        .where('uid', isEqualTo: getCurrentUser())
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((f) {
          konum = f['Paylasim'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
    getPaylasim();
  }

  Completer<GoogleMapController> _controller = Completer();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String getCurrentUser() {
    //GİRİŞ YAPAN KULLANICI BİLGİLERİNİ ALIYOR, BİLET BU KİŞİNİN HESABINA VERİLECEK
    final User user = firebaseAuth.currentUser;
    final uid = user.uid;
    return uid;
  }

  final geo = Geoflutterfire();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Follow Canlı Takip"),
        backgroundColor: Color(0xffFF7E7E),
      ),
      body: googleMapUI(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffFF7E7E),
              ),
              padding: EdgeInsets.all(15),
              child: Text('\nCarFollow Canlı Takip\n\nCihat & Taylan',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center),
            ),
            ListTile(
              title: Text('UID Paylaş'),
              onTap: () {
                Share.share(getCurrentUser());
              },
            ),
            ListTile(
              title: Text('Hakkında'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationVersion: '0.8.1',
                  applicationLegalese:
                      'Cihat Furkan Eken ve Taylan Can Hardal Tarafından final projesi olarak geliştirilmiştir. Tüm hakkı saklıdır',
                );
              },
            ),
            ListTile(
              title: Text('Çıkış'),
              onTap: () {
                context.read<AuthenticationService>().signOut();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget googleMapUI() {
    double yukseklik = MediaQuery.of(context).size.height;
    return Consumer<LocationProvider>(builder: (consumerContext, model, child) {
      if (model.locationPosition != null) {
        return Column(
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: model.locationPosition,
                  zoom: 18,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: Set<Marker>.of(model.markers.values),
                onMapCreated: (GoogleMapController controller) async {
                  Provider.of<LocationProvider>(context, listen: false)
                      .setMapController(controller);
                  Provider.of<LocationProvider>(context, listen: false)
                      .setArkadasUid(widget.arkadasUid);
                  _controller.complete(controller);
                },
              ),
            ),
            Container(
              height: yukseklik * 0.12,
              width: double.infinity,
              color: Color(0xffFF7E7E),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    // Kayıt ol butonu
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(21.0),
                        ),
                        primary: Colors.white),
                    onPressed: () {
                      if (model.arkadasPos != null)
                        moveCamera(model.arkadasPos);
                      else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.white,
                          content: Row(
                            children: <Widget>[
                              Icon(
                                Icons.navigation,
                                color: Colors.black,
                              ),
                              Text("Arkadaşınız Şuanda Konumunu Paylaşmıyor :(",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ));
                    },
                    icon: Icon(Icons.gps_fixed, color: Colors.black),
                    label: Text(
                      'Arkadaşım Nerede?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(21.0),
                        ),
                        primary: Colors.white),
                    onPressed: () {
                      setPaylasim();
                    },
                    icon: konum
                        ? Icon(Icons.location_on, color: Colors.black)
                        : Icon(Icons.location_off, color: Colors.black),
                    label: Text(
                      konum ? 'Paylaşımı Kapat' : 'Paylaşımı Aç',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }

      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  void setPaylasim() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('Konumlar');
    QuerySnapshot eventsQuery =
        await ref.where('uid', isEqualTo: getCurrentUser()).get();
    eventsQuery.docs.forEach((msgDoc) {
      if (msgDoc.exists) {
        msgDoc.reference.update({'Paylasim': !konum});
        setState(() {
          konum = !konum;
        });
      }
    });
  }

  Future<void> moveCamera(LatLng arkadasPos) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: arkadasPos,
      zoom: 17,
    )));
  }
}

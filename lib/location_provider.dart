import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  BitmapDescriptor _pinLocationIcon;
  Map<MarkerId, Marker> _markers;
  Map<MarkerId, Marker> get markers => _markers;
  final MarkerId markerId = MarkerId("1");
  final MarkerId markerId2 = MarkerId("2");
  String _uid;
  String get uid => _uid;
  GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;
  final geo = Geoflutterfire();
  Location _location;
  Location get location => _location;
  BitmapDescriptor get pinLocationIcon => _pinLocationIcon;

  LatLng _arkadasPos;
  LatLng get arkadasPos => _arkadasPos;
  LatLng _locationPosition;
  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = new Location();
    _markers = <MarkerId, Marker>{};
  }

  initialization() async {
    await getUserLocation();
    await setCustomMapPin();
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String getCurrentUser() {
    //GİRİŞ YAPAN KULLANICI BİLGİLERİNİ ALIYOR, BİLET BU KİŞİNİN HESABINA VERİLECEK
    final User user = firebaseAuth.currentUser;
    final uid = user.uid;
    return uid;
  }

  //////////////////////////////////////
  void getArkadasUid() {
    FirebaseFirestore.instance
        .collection("Konumlar")
        .where('uid', isEqualTo: _uid)
        .where('Paylasim', isEqualTo: true)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((f) {
          GeoPoint pos = f['position']['geopoint'];
          _arkadasPos = LatLng(
            pos.latitude,
            pos.longitude,
          );
        });
      } else {
        _arkadasPos = null;
      }
    });
  }

  void _addGeoPoint(LatLng loca) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('Konumlar');

    GeoFirePoint point =
        geo.point(latitude: loca.latitude, longitude: loca.longitude);
    QuerySnapshot eventsQuery =
        await ref.where('uid', isEqualTo: getCurrentUser()).get();
    eventsQuery.docs.forEach((msgDoc) {
      if (msgDoc.exists) {
        msgDoc.reference.update({'position': point.data});
      } else {
        msgDoc.reference.set({
          'position': point.data,
          'uid': getCurrentUser(),
          'Paylasim': true,
        });
      }
    });
  }

  //////////////////////////////////////////

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen(
      (LocationData currentLocation) {
        _locationPosition = LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        );
        _addGeoPoint(_locationPosition);

        print(_locationPosition);

        getArkadasUid();
        print(_arkadasPos);
        _markers.clear();

        Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
            _locationPosition.latitude,
            _locationPosition.longitude,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        Marker marker2 = Marker(
          markerId: markerId2,
          position: LatLng(
            _arkadasPos.latitude,
            _arkadasPos.longitude,
          ),
          icon: pinLocationIcon,
        );

        if (_arkadasPos != null) {
          _markers[markerId2] = marker2;
          notifyListeners();
        } else {
          _markers.remove(markerId2);
          notifyListeners();
        }

        _markers[markerId] = marker;

        notifyListeners();
      },
    );
  }

  setArkadasUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/destination_map_marker.png',
    );
  }

  takeSnapshot() {
    return _mapController.takeSnapshot();
  }
}

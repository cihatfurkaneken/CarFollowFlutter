# Live Location Sharing App 📍

- Developed with Flutter & Dart
- Back-end as Firebase

## Features
- Live real-time location tracking for a device
- Login and Register System
- Sharing can be turned on or off
- Where is My Friend button for find the firend easy


[Flutter](https://flutter.dev/docs/cookbook)
[Firebase](https://firebase.google.com)


## Preview
<details> 
  <summary>Click to expand!</summary>
  
  ## App Screens
  
  - Login & Register

  <img src="https://github.com/cihatfurkaneken/CarFollowFlutter/blob/master/Screenshoots/login.jpg?raw=true" alt="drawing" width="200"/> <img src="https://github.com/cihatfurkaneken/CarFollowFlutter/blob/master/Screenshoots/kay%C4%B1t.jpg?raw=true" alt="drawing" width="200"/>

- Entering Uid and Share

<img src="https://github.com/cihatfurkaneken/CarFollowFlutter/blob/master/Screenshoots/enteruid.jpg?raw=true" alt="drawing" width="200"/> <img src="https://github.com/cihatfurkaneken/CarFollowFlutter/blob/master/Screenshoots/sharing.jpg?raw=true" alt="drawing" width="200"/>
  
 - Map and Seeing friend
  
  <img src="https://github.com/cihatfurkaneken/CarFollowFlutter/blob/master/Screenshoots/map.jpg?raw=true alt="drawing" width="200"/> 

  
</details>

## Firebase Firestore
<details>
  <summary>Click to expand!</summary>

- Locations
<img src="https://github.com/cihatfurkaneken/CarFollowFlutter/blob/master/Screenshoots/firebaseloc.png?raw=true" alt="drawing" width="200"/>

- Users
<img src="https://github.com/cihatfurkaneken/CarFollowFlutter/blob/master/Screenshoots/firebaseusers.png?raw=true" alt="drawing" width="200"/>



  </details>

## Installation
- You need take a Google Maps API key from Google Cloud and enter the code to .\android\app\src\main\AndroidManifest.xml

```ruby
<meta-data android:name="com.google.android.geo.API_KEY" 
            android:value="yourAPIkeyHere"/>
```
- You need Create Firestroe from Firebase and create 2 collection named 'Konumlar' and 'Kullanicilar' it is default names you can change from codes. Then take GoogleServices.json file from Firebase and put to .\android\app folder.
                                          

### Thank You

  > _The application is designed in Turkish but can be easily modified._

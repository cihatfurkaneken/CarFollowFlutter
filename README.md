# Live Location Sharing App 📍

- Developed with Flutter & Dart
- Back-end as Firebase

## Features
- Live real-time location tracking for a device
- Login and Register System
- Sharing can be turned on or off


[Flutter](https://flutter.dev/docs/cookbook)
[Firebase](https://firebase.google.com)


## Preview
<details> 
  <summary>Click to expand!</summary>
  
  ## App Screens
  - Login & Register

  <img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/login.jpg?raw=true" alt="drawing" width="200"/> <img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/register.jpg?raw=true" alt="drawing" width="200"/>

- Main & Theaters Screen

<img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/mainscreen.jpg?raw=true" alt="drawing" width="200"/> <img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/theaters.jpg?raw=true" alt="drawing" width="200"/>

- Movie Details

<img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/moviedetails.jpg?raw=true" alt="drawing" width="200"/> <img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/moviedetails2.jpg" alt="drawing" width="200"/>

- Seat Selection

<img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/seat.jpg?raw=true" alt="drawing" width="200"/> <img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/seatselection.jpg?raw=true" alt="drawing" width="200"/>

- Ticket Details

<img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/ticketdetails.jpg?raw=true" alt="drawing" width="200"/> 

- User & My Tickets

<img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/user.jpg?raw=true" alt="drawing" width="200"/> <img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/mytickets.jpg?raw=true" alt="drawing" width="200"/>

</details>

## Firebase Firestore
<details>
  <summary>Click to expand!</summary>

- Tickets
<img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/firebase1.png?raw=true" alt="drawing" width="200"/>

- Movies
<img src="https://github.com/cihatfurkaneken/CinemaTickets/blob/master/Screenshots/firebase2.png?raw=true" alt="drawing" width="200"/>



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

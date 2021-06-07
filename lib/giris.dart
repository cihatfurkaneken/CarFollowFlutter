import 'package:flutter/material.dart';
import 'package:flutter_live_location_gmap/service/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'kayit.dart';

class Giris extends StatefulWidget {
  const Giris({Key key}) : super(key: key);

  @override
  _GirisState createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool goster = true;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
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
            //Sayfayı kapsayan widget
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  width: genislik * 0.75,
                  height: yukseklik * 0.55,
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
                                // Kullaıncı adının girildiği kısım
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Kullanıcı Adı',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Stack(
                            alignment: const Alignment(0, 0),
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        new BorderRadius.circular(19.0),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, right: 15, top: 5),
                                      child: TextFormField(
                                        // Şifrenin adının girildiği kısım
                                        controller: passwordController,
                                        obscureText: goster,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Şifre',
                                        ),
                                      ))),
                              Positioned(
                                  right: 15,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        //Göster butonu
                                        goster == true
                                            ? goster = false
                                            : goster = true;
                                        setState(() {});
                                      },
                                      child: Text('Göster')))
                            ],
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
                                //Giriş işlemini gerçekleştiren kodlar
                                if (emailController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(new SnackBar(
                                    duration: new Duration(seconds: 4),
                                    content: new Row(
                                      children: <Widget>[
                                        new CircularProgressIndicator(),
                                        new Text(" Giriş Yapılıyor..")
                                      ],
                                    ),
                                  ));
                                  // Giriş işlemi fonksiyonu çağırılması
                                  loginAction().whenComplete(() => null);
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('HATA'),
                                      content: const Text(
                                          'Giriş kısımları boş olamaz'),
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
                              child: Text('Giriş',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        Text("Hesabın yok mu ?"),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 45,
                              width: genislik * 0.4,
                              child: ElevatedButton(
                                // Kayıt ol butonu
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(21.0),
                                    ),
                                    primary: Colors.lightBlueAccent),
                                onPressed: () {
                                  // Kayıt ol sayfası yönlendirmesi
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Kayit()));
                                },
                                child: Text(
                                  'Kayıt Ol',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ))
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

  Future<String> loginAction() async {
    // Giriş Yapma Fonksiyonu
    await new Future.delayed(const Duration(seconds: 2));
    return context.read<AuthenticationService>().signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }
}

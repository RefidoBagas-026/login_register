import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:login_register/wrapper.dart';

class Verifyemail extends StatefulWidget {
  const Verifyemail({super.key});

  @override
  State<Verifyemail> createState() => _VerifyemailState();
}

class _VerifyemailState extends State<Verifyemail> {
  @override
  void initState(){
    sendverifylink();
    super.initState();
  }

  sendverifylink()async{
    final user= FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value) =>{
      Get.snackbar('Link Terkirim','Link akan dikirim ke email anda', margin: EdgeInsets.all(30),snackPosition:  SnackPosition.BOTTOM)
    });
  }

  reload()async{
    await FirebaseAuth.instance.currentUser!.reload().then((value)=>{Get.offAll(Wrapper())});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verifikasi"),),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Text("Buka email yang dikirimkan dan klik link yang tersedia untuk verifikasi email dan reload halaman ini"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (()=>reload()),
        child: Icon(Icons.restart_alt_rounded),
      ),
    );
  }
}

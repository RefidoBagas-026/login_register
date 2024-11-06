import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController email = TextEditingController();
  bool isLoading = false;
  reset() async {
    if (email.text.isEmpty) {
      Get.snackbar("Input Tidak Lengkap", "Email harus diisi.");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      Get.snackbar("Email Dikirim", "Silakan periksa email Anda untuk mereset password.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Email Tidak Ditemukan", "Email ini tidak terdaftar. Silakan cek kembali.");
      } else if (e.code == 'invalid-email') {
        Get.snackbar("Email Tidak Valid", "Format email tidak valid. Silakan masukkan email yang benar.");
      } else {
        Get.snackbar("Terjadi Kesalahan", e.message ?? "Terjadi kesalahan saat mengirim email.");
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", e.toString());
    }finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Password")),
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  hintText: "Masukkan Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (() => reset()),
                child: const Text("Send link"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


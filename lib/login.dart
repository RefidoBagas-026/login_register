import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_register/forgot.dart';
import 'package:login_register/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email= TextEditingController();
  TextEditingController password= TextEditingController();

  bool isLoading = false;

  signIn() async {
    // Validasi input sebelum memulai proses sign-in
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Input Tidak Lengkap", "Email dan password harus diisi.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // Menampilkan pesan sukses login
      Get.snackbar("Login Berhasil", "Selamat datang!");

      // Bersihkan field setelah login
      email.clear();
      password.clear();

    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Format email tidak valid. Mohon masukkan email yang benar.';
          break;
        case 'user-not-found':
          errorMessage = 'Email tidak terdaftar. Mohon cek kembali email Anda atau daftar akun baru.';
          break;
        case 'wrong-password':
          errorMessage = 'Password salah. Mohon coba lagi.';
          break;
        case 'invalid-credential':
          errorMessage = 'Kredensial tidak valid atau telah kadaluarsa. Mohon coba lagi.';
          break;
        case 'expired-action-code':
        case 'invalid-action-code':
          errorMessage = 'Kredensial telah kadaluarsa atau tidak valid. Mohon lakukan login ulang.';
          break;
        default:
          errorMessage = 'Terjadi kesalahan: ${e.message}';
      }

      Get.snackbar("Terjadi Kesalahan", errorMessage);
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(title: const Text('Coffeeshop Login')),
      body: Center(
        child: SingleChildScrollView(
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
              const SizedBox(height: 10),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Masukkan Password",
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (() => Get.to(Forgot())),
                    child: const Text("Lupa Password?"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: signIn,
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum memiliki akun? "),
                  TextButton(
                    onPressed: (() => Get.to(Signup())),
                    child: const Text("Daftar Sekarang"),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    ),
    );
  }
}

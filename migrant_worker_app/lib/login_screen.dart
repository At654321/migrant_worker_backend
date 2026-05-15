import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> loginUser() async {

    setState(() {
      isLoading = true;
    });

    try {

      final String url =
          "http://127.0.0.1:8000/api/login/";

      final response = await http.post(

        Uri.parse(url),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "email":
          emailController.text.trim(),

          "password":
          passwordController.text.trim(),

        }),
      );

      final data =
      jsonDecode(response.body);

      if (response.statusCode == 200) {

        SharedPreferences prefs =
        await SharedPreferences.getInstance();

        await prefs.setString(
          "access_token",
          data["access"],
        );

        await prefs.setString(
          "role",
          data["role"],
        );

        await prefs.setString(
          "email",
          emailController.text.trim(),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text(
              "Login Successful",
            ),
          ),
        );

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) {

              return const HomeScreen();
            },
          ),
        );

      } else {

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(

            content: Text(

              data["message"] ??
                  "Login Failed",
            ),
          ),
        );
      }

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Login",
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            TextField(

              controller:
              emailController,

              decoration:
              const InputDecoration(

                labelText: "Email",

                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(

              controller:
              passwordController,

              obscureText: true,

              decoration:
              const InputDecoration(

                labelText: "Password",

                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : loginUser,

                child:
                isLoading

                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )

                    : const Text(
                  "Login",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  String role = "";
  String email = "";

  int currentIndex = 0;

  @override
  void initState() {

    super.initState();

    loadUserData();
  }

  Future<void> loadUserData() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    role =
        prefs.getString("role") ?? "";

    email =
        prefs.getString("email") ?? "";

    setState(() {});
  }

  Future<List> fetchJobs() async {

    final response =
    await http.get(

      Uri.parse(
        "http://127.0.0.1:8000/api/jobs/",
      ),
    );

    return jsonDecode(response.body);
  }

  Future<void> logout() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.clear();

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (context) =>
        const LoginScreen(),
      ),

          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Dashboard",
        ),

        actions: [

          IconButton(

            onPressed: logout,

            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      body: IndexedStack(

        index: currentIndex,

        children: [

          homeTab(),

          jobsTab(),

          profileTab(),

          settingsTab(),
        ],
      ),

      bottomNavigationBar:

      BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex = index;
          });
        },

        selectedItemColor:
        Colors.blue,

        unselectedItemColor:
        Colors.grey,

        items: const [

          BottomNavigationBarItem(

            icon: Icon(Icons.home),

            label: "Home",
          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.work),

            label: "Jobs",
          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.person),

            label: "Profile",
          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.settings),

            label: "Settings",
          ),
        ],
      ),
    );
  }

  Widget homeTab() {

    return const Center(

      child: Text(

        "Home Screen 😎",

        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }

  Widget jobsTab() {

  return FutureBuilder(

    future: fetchJobs(),

    builder: (context, snapshot) {

      if (!snapshot.hasData) {

        return const Center(

          child:
          CircularProgressIndicator(),
        );
      }

      List jobs =
      snapshot.data as List;

      return ListView.builder(

        itemCount: jobs.length,

        itemBuilder: (context, index) {

          var job = jobs[index];

          return Card(

            margin:
            const EdgeInsets.all(10),

            child: Padding(

              padding:
              const EdgeInsets.all(10),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  ListTile(

                    leading: const Icon(
                      Icons.work,
                    ),

                    title: Text(
                      job["title"],
                    ),

                    subtitle: Text(
                      "${job["location"]} • ₹${job["salary"]}",
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton(

                      onPressed: () {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(

                          SnackBar(

                            content: Text(

                              "Applied for ${job["title"]}",
                            ),
                          ),
                        );
                      },

                      child: const Text(
                        "Apply Job",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

  Widget profileTab() {

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Text(

            "Email: $email",

            style: const TextStyle(
              fontSize: 20,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Text(

            "Role: $role",

            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }


  Widget settingsTab() {

    return Center(

      child: ElevatedButton(

        onPressed: logout,

        child: const Text(
          "Logout",
        ),
      ),
    );
  }
}
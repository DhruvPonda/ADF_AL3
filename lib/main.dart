import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const JokeApp());
}

class JokeApp extends StatelessWidget {
  const JokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JokeHome(),
    );
  }
}

class JokeHome extends StatefulWidget {
  const JokeHome({super.key});

  @override
  State<JokeHome> createState() => _JokeHomeState();
}

class _JokeHomeState extends State<JokeHome> {
  String setup = "";
  String punchline = "";
  bool isLoading = false;
  bool showAnswer = false;

  Future<void> fetchJoke() async {
    setState(() {
      isLoading = true;
      showAnswer = false;
    });

    final response = await http.get(
      Uri.parse("https://official-joke-api.appspot.com/jokes/random"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        setup = data["setup"];
        punchline = data["punchline"];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJoke();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Joke Generator"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    setup,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Eye toggle row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          showAnswer
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.indigo,
                        ),
                        onPressed: () {
                          setState(() {
                            showAnswer = !showAnswer;
                          });
                        },
                      ),
                      const Text("Show Answer"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  if (showAnswer)
                    Text(
                      punchline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: fetchJoke,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // changed color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("New Joke"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
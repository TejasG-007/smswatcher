import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smswatcher/smswatcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _smsListenerPlugin = Smswatcher();

  @override
  void initState() {
    super.initState();
    Permission.sms.request();
  }

  @override
  void dispose() {
    _smsListenerPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  _smsListenerPlugin.getAllSMS();
                },
                child: const Icon(Icons.sms),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
          appBar: AppBar(
            title: const Text('SMS Fetching App'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                    child: Column(
                      children: [
                        const Text("Listening to Latest Messages",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        StreamBuilder(
                          stream: _smsListenerPlugin.getStreamOfSMS(),
                          builder: (context, snap) => ListTile(
                            title: Text(snap.data?["sender"] ?? "NA"),
                            subtitle: Text(snap.data?["body"] ?? "NA"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1,
                    child: Column(
                      children: [
                        const Text("Listening to Latest Messages",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        FutureBuilder(
                          future: _smsListenerPlugin.getAllSMS(),
                          builder: (context, snap) {
                            if (!snap.hasData)
                              return const CircularProgressIndicator(); // Optional loading state
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snap.data?.length ?? 0,
                                itemBuilder: (context, index) => ListTile(
                                  title:
                                      Text(snap.data?[index]["sender"] ?? "NA"),
                                  subtitle:
                                      Text(snap.data?[index]["body"] ?? "NA"),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/native_mode_delbank_anti_cheat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Delbank check'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String uuid = "";
  String codeVerify = "";
  Map<dynamic, dynamic>? error;

  void _getAuth() async {
    startAntiCheat(
        onError: (error) => setState(() {
              error = error;
            }),
        onSuccess: (result) => {
              setState(() {
                uuid = result[keyResultId];
              }),
              setState(() {
                codeVerify = result[keyResultCode];
              }),
            },
        params: {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: _getAuth,
          child: Text('Obter autorização'),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'UUID AUTORIZAÇÃO',
            ),
            Text(
              uuid,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'CODE AUTORIZAÇÃO',
            ),
            Text(
              codeVerify,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Error mensagem',
            ),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}

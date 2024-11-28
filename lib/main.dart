import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:tonminiapp/show_utils.dart';
import 'package:tonminiapp/web3utils.dart';

import 'export.dart';
import 'verify_utils.dart';

void main() async {
  try {
    if (TelegramWebApp.instance.isSupported) {
      TelegramWebApp.instance.ready();
      Future.delayed(
          const Duration(seconds: 1), TelegramWebApp.instance.expand);
    }
  } catch (e) {
    print("Error happened in Flutter while loading Telegram $e");
    // add delay for 'Telegram seldom not loading' bug
    await Future.delayed(const Duration(milliseconds: 200));
    main();
    return;
  }

  FlutterError.onError = (details) {
    print("Flutter error happened: $details");
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: FlutterSmartDialog.init(),
      navigatorObservers: [FlutterSmartDialog.observer],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String mnemonics = "";
  String address = "";

  String balance = "0";

  final controller = TextEditingController();

  void getBalance() {
    var keyPair = Web3Utils.getKeyPair(mnemonics);
    var wallet = Web3Utils.getWallet(keyPair);
    wallet.getBalance().then((value) => setState(() {
          balance = value.toString();
        }));
  }

  String getAddress() {
    var keyPair = Web3Utils.getKeyPair(mnemonics);
    return Web3Utils.getWallet(keyPair).address.toString(isTestOnly: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "请输入助记词",
              ),
            ),
            TextButton(
                onPressed: () {
                  final errMsg = verifyMnemonics(controller.text);
                  if (isNotBlank(errMsg)) {
                    ShowUtils.showToast(errMsg);
                    return;
                  }
                  mnemonics = controller.text;
                  address = getAddress();
                },
                child: const Text("导入钱包")),
            Text("地址: $address"),
            TextButton(
                onPressed: () {
                  final errMsg = verifyMnemonics(mnemonics);
                  if (isNotBlank(errMsg)) {
                    ShowUtils.showToast(errMsg);
                    return;
                  }
                  getBalance();
                },
                child: const Text("获取余额")),
            Text("地址: $balance Ton"),
          ],
        ),
      ),
    );
  }
}

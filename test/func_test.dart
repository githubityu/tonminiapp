// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tonutils/tonutils.dart';



void main() {
  test('Counter increments smoke test', () async {
    // Build our app and trigger a frame.
    // Client uses testnet by default:
    final client = TonJsonRpc();

// But you can specify an alternative endpoint, say, for mainnet:
//     final client = TonJsonRpc('https://toncenter.com/api/v2/jsonRPC');

// You can also specify an API key obtained from https://t.me/tonapibot!

// Generate a new key pair
//     var mnemonics = Mnemonic.generate();
    const mnemonics = 'diet diesel simple glory explain clever rescue artwork shield sheriff palm jar eye test hip exclude panda transfer quick air wasp approve dream kiwi';
    var keyPair = Mnemonic.toKeyPair(mnemonics.split(" "));

// Wallet contracts use workchain = 0, but this can be overriden
    var wallet = WalletContractV4R2.create(publicKey: keyPair.publicKey);

// Opening a wallet contract (this specifies the TonJsonRpc as a ContractProvider)
    var openedContract = client.open(wallet);


    final isDeployed = await client.isContractDeployed(wallet.address);

    var address = wallet.address.toString(isTestOnly: true);
    var balance = await openedContract.getBalance();
    print("address=$address  balance=$balance");
    if(!isDeployed){
      print("Wallet is not deployed. Attempting to deploy...");
      return;
    }
    
  // Get the balance of the contract


// Create a transfer
    var seqno = await openedContract.getSeqno();
    var transfer = openedContract.sendTransfer(
      seqno: seqno,
      privateKey: keyPair.privateKey,
      messages: [
        internal(
          to: SiaString('EQCD39VS5jcptHL8vMjEXrzGaRcCVYto7HUn4bpAOg8xqB2N'),
          value: SbiString('0.5'),
          body: ScString('Hello, world!'),
        )
      ],
    );
    print(transfer.toString());
  });
}

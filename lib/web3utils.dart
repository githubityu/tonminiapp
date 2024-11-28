import 'package:tonutils/tonutils.dart';

class Web3Utils {
  static TonJsonRpc getClient({bool isMainNet = false}) {
    return !isMainNet
        ? TonJsonRpc()
        : TonJsonRpc('https://toncenter.com/api/v2/jsonRPC');
  }

  static KeyPair getKeyPair(String mnemonics) {
    return Mnemonic.toKeyPair(mnemonics.split(" "));
  }

  static WalletContractV4R2 getWallet(KeyPair keyPair){
    return WalletContractV4R2.create(publicKey: keyPair.publicKey);
  }

  static WalletContractV4R2 openWallet(String mnemonics){
    var keyPair = getKeyPair(mnemonics);
    var openedContract = getClient().open(getWallet(keyPair));
    return openedContract;
  }

}

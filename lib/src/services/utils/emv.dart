import 'dart:async';
import 'dart:typed_data';

import 'package:agnostiko/agnostiko.dart';

import 'parameters.dart';

bool _alreadyInitialized = false;

Future<void> emvPreTransaction(bool? reInit) async {
  final emv = EmvModule.instance;

  final terminalParameters = await loadTerminalParameters();
  final deviceType = await getDeviceType();
  if (_alreadyInitialized &&
      deviceType == DeviceType.PINPAD &&
      reInit == false) {
  } else {
    await emv.initKernel(terminalParameters);
    _alreadyInitialized = true;
    print("EMV initialized!");

    final appList = await loadEmvAppList();
    for (final app in appList) {
      try {
        await emv.addApp(app);
      } catch (e) {
        print("Error: '${app.aid.toHexStr()}'");
      }
    }

    var capkList = await loadCAPKList();
    for (final capk in capkList) {
      try {
        await emv.addCAPK(capk);
      } on CAPKChecksumException {
        print("CAPK Checksum Error: '${capk.rid.toHexStr()} - " +
            "${capk.index.toHexStr()}'");
      } catch (e) {
        print(
          "Error: '${capk.rid.toHexStr()} - " + "${capk.index.toHexStr()}'",
        );
      }
    }
  }
}

Future<Map<int, Uint8List?>> emvGetGenerateCommandTags() async {
  final emv = EmvModule.instance;

  // guardamos el resultado de estos tags luego del 1st GAC
  final cid = await emv.getTagValue(0x9f27);
  final tsi = await emv.getTagValue(0x9b);
  final tvr = await emv.getTagValue(0x95);
  return {
    0x9f27: cid,
    0x9b: tsi,
    0x95: tvr,
  };
}

Future<Uint8List> emvGenerateField55() async {
  final emv = EmvModule.instance;

  /////// ISO8583 Field 55 ////////
  print("**Tags Field 55**");

  final tlv = TlvPackage();

  await _processField55Tag(tlv, 0x5f2a);
  await _processField55Tag(tlv, 0x82);
  await _processField55Tag(tlv, 0x84);
  await _processField55Tag(tlv, 0x95);
  await _processField55Tag(tlv, 0x9a);
  await _processField55Tag(tlv, 0x9c);
  await _processField55Tag(tlv, 0x9f02);
  await _processField55Tag(tlv, 0x9f03);
  await _processField55Tag(tlv, 0x9f09);
  await _processField55Tag(tlv, 0x9f10);
  await _processField55Tag(tlv, 0x9f1a);
  await _processField55Tag(tlv, 0x9f1e);
  await _processField55Tag(tlv, 0x9f26);
  await _processField55Tag(tlv, 0x9f27);
  await _processField55Tag(tlv, 0x9f33);
  await _processField55Tag(tlv, 0x9f34);
  await _processField55Tag(tlv, 0x9f35);
  await _processField55Tag(tlv, 0x9f36);
  await _processField55Tag(tlv, 0x9f37);
  await _processField55Tag(tlv, 0x9f41);
  await _processField55Tag(tlv, 0x9f53);
  await _processField55Tag(tlv, 0x9f6e);

  final pack = tlv.pack();
  print("Field 55: '${pack.toHexStr()}'");

  final ttq = await emv.getTagValue(0x9f66);
  print("TTQ: ${ttq?.toHexStr()}");
  final floorLimit = await emv.getTagValue(0x9f1b);
  print("Floor Limit: ${floorLimit?.toHexStr()}");
  final df8123 = await emv.getTagValue(0xdf23);
  print("CLSS Floor Limit: ${df8123?.toHexStr()}");
  final df8126 = await emv.getTagValue(0xdf24);
  print("CLSS Transaction Limit: ${df8126?.toHexStr()}");
  final df26 = await emv.getTagValue(0xdf26);
  print("CLSS CVM Limit: ${df26?.toHexStr()}");
  final additionalTerminalCapabilities = await emv.getTagValue(0x9f40);
  print("Add Terminal Cap: ${additionalTerminalCapabilities?.toHexStr()}");
  final entryMode = await emv.getTagValue(0x9f39);
  print("Entry Mode: ${entryMode?.toHexStr()}");

  return tlv.pack();
}

Future<void> _processField55Tag(TlvPackage tlvPackage, int tag) async {
  final value = await EmvModule.instance.getTagValue(tag);
  _printAndAddTagToPack(tlvPackage, tag, value);
}

void _printAndAddTagToPack(TlvPackage tlvPackage, int tag, Uint8List? value) {
  print("${tag.toRadixString(16).toUpperCase()}: '${value?.toHexStr()}'");
  if (value != null) {
    tlvPackage.add(tag, value);
  }
}

class InfoTags {
  final Uint8List? transactionType;
  final Uint8List? amount;
  final Uint8List? amountOther;
  final Uint8List? cardNo;
  final Uint8List? aid;
  final Uint8List? aip;
  final Uint8List? terminalCapabilities;
  final Uint8List? cvmResults;
  final Uint8List? cvmList;
  final Uint8List? atc;

  InfoTags(
    this.transactionType,
    this.amount,
    this.amountOther,
    this.cardNo,
    this.aid,
    this.aip,
    this.terminalCapabilities,
    this.cvmResults,
    this.cvmList,
    this.atc,
  );
}

Future<InfoTags> loadInfoTags() async {
  final emv = EmvModule.instance;
  return InfoTags(
    await emv.getTagValue(0x9C),
    await emv.getTagValue(0x9f02),
    await emv.getTagValue(0x9f03),
    await emv.getTagValue(0x5A),
    await emv.getTagValue(0x9F06),
    await emv.getTagValue(0x82),
    await emv.getTagValue(0x9f33),
    await emv.getTagValue(0x9f34),
    await emv.getTagValue(0x8e),
    await emv.getTagValue(0x9f36),
  );
}

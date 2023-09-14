// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  String bitCoinRate = '?';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem<String>(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (String? value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (int selectedIndex) {
        if (kDebugMode) {
          print(selectedIndex);
        }
        getData();
      },
      children: pickerItems,
    );
  }

  Map<String, String> cryptoRates = {};
  bool isWaiting = false;

  Future<void> getData() async {
    CoinData coinData = CoinData();
    isWaiting = true;
    var rates = await coinData.getCoinData(selectedCurrency);
    isWaiting = false;
    setState(() {
      cryptoRates = rates;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            bitCoinRate: isWaiting ? '?' : cryptoRates['BTC'],
            selectedCurrency: selectedCurrency,
            cryptocurrency: 'BTC',
          ),
          CryptoCard(
            bitCoinRate: isWaiting ? '?' : cryptoRates['ETH'],
            selectedCurrency: selectedCurrency,
            cryptocurrency: 'ETH',
          ),
          CryptoCard(
            bitCoinRate: isWaiting ? '?' : cryptoRates['LTC'],
            selectedCurrency: selectedCurrency,
            cryptocurrency: 'LTC',
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key? key,
    required this.bitCoinRate,
    required this.selectedCurrency,
    required this.cryptocurrency,
  }) : super(key: key);

  final String? bitCoinRate;
  final String selectedCurrency;
  final String cryptocurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptocurrency = ${bitCoinRate ?? '?'} $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

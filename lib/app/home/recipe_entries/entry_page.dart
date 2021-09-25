import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/app/top_level_providers.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:starter_architecture_flutter_firebase/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';
import 'package:pedantic/pedantic.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class EntryPage extends ConsumerStatefulWidget {
  const EntryPage({required this.recipe, this.entry});
  final Recipe recipe;
  final Entry? entry;

  static Future<void> show(
      {required BuildContext context,
      required Recipe recipe,
      Entry? entry}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.entryPage,
      arguments: {
        'recipe': recipe,
        'entry': entry,
      },
    );
  }

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends ConsumerState<EntryPage> {
  late dynamic _calories;
  late String _foodName;
  // late dynamic _brandName;
  late String _servingNum;
  late String _barcode;

  @override
  void initState() {
    super.initState();
    _foodName = widget.entry?.foodName ?? '';
    _servingNum = widget.entry?.servingNum.toString() ?? '';
    _calories = widget.entry?.calories.toString() ?? '';
    _barcode = '';
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
      //getCalories();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (barcodeScanRes.length == 13) {
      barcodeScanRes = barcodeScanRes.substring(1, barcodeScanRes.length);
    }

    if (!mounted) return;

    Map<String, String> headers = {
      'accept': 'application/json',
      'Content-type': 'application/json',
      'X-Api-Key': 'tYC32GZiniA5o7HOjrl8bXRtjjsVxPIUQqG7qdiT',
    };

    Map<String, String> body = {
      'query': barcodeScanRes,
      'sortBy': 'dataType.keyword',
      'sortOrder': 'asc',
    };

    var body_json = json.encode(body);

    final response = await http.post(
      Uri.parse('https://api.nal.usda.gov/fdc/v1/foods/search'),
      // Send authorization headers to the backend.
      headers: headers,
      body: body_json,
    );
    final responseJson = jsonDecode(response.body);
    // indexing into the foodNutrient energy part to get kCals
    print(responseJson['foods'].length);
    print(responseJson['foods'][0]);
    print(responseJson['foods'][0]['foodNutrients'][3]['value']);

    // setState(() {

    setState(() {
      _barcode = barcodeScanRes;
      _calories = responseJson['foods'][0]['foodNutrients'][3]['value'] *
          double.parse(_servingNum);
    });
  }

  Entry _entryFromState() {
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
      id: id,
      recipeId: widget.recipe.id,
      recipeTime: widget.recipe.currentTime,
      servingNum: double.parse(_servingNum),
      calories: double.parse(_calories.toString()),
      foodName: _foodName,
    );
  }

  Future<void> _setEntryAndDismiss() async {
    try {
      final database = ref.read<FirestoreDatabase?>(databaseProvider)!;
      final entry = _entryFromState();
      await database.setEntry(entry);
      Navigator.of(context).pop();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.recipe.name),
        actions: <Widget>[
          FlatButton(
            child: Text(
              widget.entry != null ? 'Update' : 'Create',
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildFoodName(),
              const SizedBox(height: 8.0),
              _buildServingNum(),
              const SizedBox(height: 8.0),
              _buildBarcode(),
              const SizedBox(height: 8.0),
              _buildCalories(),
              const SizedBox(height: 8.0),
              const Text('Click below to take a picture of food barcode',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scanBarcodeNormal();
        },
        child: const Icon(Icons.camera_alt_outlined),
        backgroundColor: Colors.deepOrange[200],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildFoodName() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: TextEditingController(text: _foodName),
      decoration: const InputDecoration(
        labelText: 'Food Name',
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        suffixText: '*',
        suffixStyle: TextStyle(
          color: Colors.red,
        ),
      ),
      keyboardAppearance: Brightness.light,
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (foodName) => _foodName = foodName,
    );
  }

  Widget _buildServingNum() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: TextEditingController(text: _servingNum),
      //validator: (value) {}
      decoration: const InputDecoration(
        labelText: 'Serving Size',
        hintText: 'Enter number of servings',
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        suffixText: '*',
        suffixStyle: TextStyle(
          color: Colors.red,
        ),
      ),
      keyboardAppearance: Brightness.light,
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (servingNum) => _servingNum = servingNum,
    );
  }

  Widget _buildBarcode() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: TextEditingController(text: _barcode),
      decoration: const InputDecoration(
        labelText: 'Barcode',
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      keyboardAppearance: Brightness.light,
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (barcode) => _barcode = barcode,
    );
  }

  Widget _buildCalories() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: TextEditingController(text: _calories.toString()),
      decoration: const InputDecoration(
        labelText: 'Total Calories',
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      keyboardAppearance: Brightness.light,
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (calories) => _calories = calories,
    );
  }
}

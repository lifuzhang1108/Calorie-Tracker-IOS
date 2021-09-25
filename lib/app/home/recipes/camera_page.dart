import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:starter_architecture_flutter_firebase/app/top_level_providers.dart';
import 'package:starter_architecture_flutter_firebase/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';
import 'package:pedantic/pedantic.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({Key? key, this.recipe}) : super(key: key);
  final Recipe? recipe;

  static Future<void> show(BuildContext context, {Recipe? recipe}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.cameraPage,
      arguments: recipe,
    );
  }

  @override
  _CameraPageState createState() => _CameraPageState();
}

Future<void> scanBarcodeNormal() async {
  String barcodeScanRes;
  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    print(barcodeScanRes);
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
  }
}

class _CameraPageState extends ConsumerState<CameraPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.recipe == null ? 'New Recipe' : 'Edit Recipe'),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => scanBarcodeNormal(),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'TESTING CAMERA'),
        keyboardAppearance: Brightness.light,
        validator: (value) =>
            (value ?? '').isNotEmpty ? null : 'Name can\'t be empty',
      ),
    ];
  }
}

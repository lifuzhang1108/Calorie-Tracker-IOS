import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:starter_architecture_flutter_firebase/app/top_level_providers.dart';
import 'package:starter_architecture_flutter_firebase/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';
import 'package:pedantic/pedantic.dart';

class EditRecipePage extends ConsumerStatefulWidget {
  const EditRecipePage({Key? key, this.recipe}) : super(key: key);
  final Recipe? recipe;

  static Future<void> show(BuildContext context, {Recipe? recipe}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.editRecipePage,
      arguments: recipe,
    );
  }

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends ConsumerState<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _name = widget.recipe?.name;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final database = ref.read<FirestoreDatabase?>(databaseProvider)!;
        final recipes = await database.recipesStream().first;
        final allLowerCaseNames =
            recipes.map((recipe) => recipe.name.toLowerCase()).toList();
        if (widget.recipe != null) {
          allLowerCaseNames.remove(widget.recipe!.name.toLowerCase());
        }
        if (allLowerCaseNames.contains(_name?.toLowerCase())) {
          unawaited(showAlertDialog(
            context: context,
            title: 'Name already used',
            content: 'Please choose a different recipe name',
            defaultActionText: 'OK',
          ));
        } else {
          final id = widget.recipe?.id ?? documentIdFromCurrentDate();
          final recipe =
              Recipe(id: id, name: _name ?? '', currentTime: DateTime.now());
          await database.setJob(recipe);
          Navigator.of(context).pop();
        }
      } catch (e) {
        unawaited(showExceptionAlertDialog(
          context: context,
          title: 'Operation failed',
          exception: e,
        ));
      }
    }
  }

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
            onPressed: () => _submit(),
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
        decoration: const InputDecoration(labelText: 'Recipe Name'),
        keyboardAppearance: Brightness.light,
        initialValue: _name,
        validator: (value) =>
            (value ?? '').isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
    ];
  }
}

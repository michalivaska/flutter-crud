import 'package:crud/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class UserWidget extends StatefulWidget {
  final User? user;
  final Function() onUpdate;

  const UserWidget({super.key, required this.user, required this.onUpdate});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  final _formKey = GlobalKey<FormBuilderState>();

  void save() async {
    _formKey.currentState?.saveAndValidate();
    final data = _formKey.currentState?.value;
    final user = widget.user;
    if ((_formKey.currentState?.isValid ?? false) && data != null) {
      if (user == null) {
        await User.create(data);
      } else {
        await user.update(data);
      }
      widget.onUpdate();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void delete() async {
    await widget.user?.delete();
    widget.onUpdate();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Widget _wBody() {
    return FormBuilder(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FormBuilderRadioGroup(
            name: 'civilite',
            initialValue: widget.user?.civilite.name,
            decoration: const InputDecoration(
              labelText: 'Civilité',
            ),
            options: [
              FormBuilderFieldOption(
                value: Civilite.madame.name,
                child: const Text('Madame'),
              ),
              FormBuilderFieldOption(
                value: Civilite.monsieur.name,
                child: const Text('Monsieur'),
              ),
            ],
            validator: FormBuilderValidators.required(),
          ),
          FormBuilderTextField(
            name: 'nom',
            initialValue: widget.user?.nom,
            decoration: const InputDecoration(
              labelText: 'Nom',
            ),
            validator: FormBuilderValidators.required(),
          ),
          FormBuilderTextField(
            name: 'email',
            decoration: const InputDecoration(
              labelText: 'Adresse e-mail',
            ),
            validator: FormBuilderValidators.email(),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: save,
            child: const Text('Enregistrer'),
          ),
          TextButton(
            onPressed: delete,
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: e,
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Création' : 'Modification'),
      ),
      body: _wBody(),
    );
  }
}

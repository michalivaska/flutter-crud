import 'package:crud/models/user.dart';
import 'package:crud/widgets/user_widget.dart';
import 'package:flutter/material.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  List<User>? _users;

  void _load() async {
    final users = await User.getAll();
    users.sort((a, b) => a.nom.toLowerCase().compareTo(b.nom.toLowerCase()));
    setState(() {
      _users = users;
    });
  }

  void _editUser([User? user]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserWidget(
          user: user,
          onUpdate: _load,
        ),
      ),
    );
  }

  Widget _wUserTile(User user) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(user.civilite == Civilite.madame ? Icons.female : Icons.male),
        ],
      ),
      title: Text(user.nom),
      subtitle: Text(user.email ?? 'Adresse e-mail inconnue'),
      onTap: () => _editUser(user),
    );
  }

  Widget _wBody() {
    final users = _users;
    if (users == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (users.isEmpty) {
      return const Center(child: Text('Aucun utilisateur n\'a été trouvé.'));
    }
    return ListView(
      children: users.map((user) => _wUserTile(user)).toList(),
    );
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des utilisateurs'),
      ),
      body: _wBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _editUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}

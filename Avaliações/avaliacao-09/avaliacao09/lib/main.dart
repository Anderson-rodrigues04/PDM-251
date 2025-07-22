import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Usuario {
  final int id;
  final String nome;
  final String email;
  final String telefone;
  final String website;
  final String empresa;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.website,
    required this.empresa,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['name'],
      email: json['email'],
      telefone: json['phone'],
      website: json['website'],
      empresa: json['company']['name'],
    );
  }
}

void main() {
  runApp(const AvaliacaoApp());
}

class AvaliacaoApp extends StatelessWidget {
  const AvaliacaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avaliação 09 - Lista de Usuários',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: const UsuariosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  List<Usuario> _usuarios = [];
  List<Usuario> _usuariosFiltrados = [];
  final TextEditingController _controllerPesquisa = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarUsuarios();
  }

  Future<void> carregarUsuarios() async {
    final String jsonString = await rootBundle.loadString('assets/usuarios.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    final usuariosList = jsonResponse.map((u) => Usuario.fromJson(u)).toList();

    setState(() {
      _usuarios = usuariosList;
      _usuariosFiltrados = usuariosList;
    });
  }

  void _pesquisarUsuario(String query) {
    final buscaLower = query.toLowerCase();

    final resultados = _usuarios.where((user) {
      final nomeLower = user.nome.toLowerCase();
      final emailLower = user.email.toLowerCase();
      final idStr = user.id.toString();

      return nomeLower.contains(buscaLower) ||
          emailLower.contains(buscaLower) ||
          idStr.contains(buscaLower);
    }).toList();

    setState(() {
      _usuariosFiltrados = resultados;
    });
  }

  @override
  void dispose() {
    _controllerPesquisa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              carregarUsuarios();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lista recarregada')),
              );
            },
            tooltip: 'Recarregar lista',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controllerPesquisa,
              decoration: const InputDecoration(
                labelText: 'Pesquisar por nome, e-mail ou ID',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _pesquisarUsuario,
            ),
          ),
          Expanded(
            child: _usuariosFiltrados.isEmpty
                ? const Center(child: Text('Nenhum usuário encontrado.'))
                : ListView.builder(
                    itemCount: _usuariosFiltrados.length,
                    itemBuilder: (context, index) {
                      final user = _usuariosFiltrados[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(user.id.toString()),
                          ),
                          title: Text(user.nome),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.email),
                              Text('📞 ${user.telefone}'),
                              Text('🌐 ${user.website}'),
                              Text('🏢 ${user.empresa}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

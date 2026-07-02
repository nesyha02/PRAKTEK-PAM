import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

//////////////////////////////////////////////////////
// DATABASE SERVICE (SQLITE)
//////////////////////////////////////////////////////

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT
        )
        ''');
      },
    );
  }

  static Future<void> insertNote(String title, String content) async {
    final db = await database;

    await db.insert('notes', {'title': title, 'content': content});
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes');
  }

  static Future<void> deleteNote(int id) async {
    final db = await database;

    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}

//////////////////////////////////////////////////////
// APP ROOT
//////////////////////////////////////////////////////

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDark = prefs.getBool('dark') ?? false;
      isLogin = prefs.getBool('login') ?? false;
    });
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDark = !isDark;
    });

    await prefs.setBool('dark', isDark);
  }

  Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isLogin = value;
    });

    await prefs.setBool('login', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: isLogin
          ? HomePage(toggleTheme: toggleTheme, logout: () => setLogin(false))
          : LoginPage(onLogin: () => setLogin(true)),
    );
  }
}

//////////////////////////////////////////////////////
// LOGIN PAGE
//////////////////////////////////////////////////////

class LoginPage extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login", style: TextStyle(fontSize: 26)),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onLogin, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////
// HOME PAGE
//////////////////////////////////////////////////////

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback logout;

  const HomePage({super.key, required this.toggleTheme, required this.logout});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await DBHelper.getNotes();

    setState(() {
      notes = data;
    });
  }

  Future<void> addNote(String title, String content) async {
    await DBHelper.insertNote(title, content);
    loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await DBHelper.deleteNote(id);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Storage App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: widget.logout),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(note['title']),
              subtitle: Text(note['content']),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteNote(note['id']),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNotePage()),
          );

          if (result != null) {
            addNote(result['title'], result['content']);
          }
        },
      ),
    );
  }
}

//////////////////////////////////////////////////////
// ADD NOTE PAGE
//////////////////////////////////////////////////////

class AddNotePage extends StatelessWidget {
  const AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final content = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: content,
              decoration: const InputDecoration(labelText: "Content"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'title': title.text,
                  'content': content.text,
                });
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  late Box<User> userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<User>('users');
  }

  // CREATE
  void addUser() {
    final user = User(
      name: nameController.text,
      age: int.parse(ageController.text),
    );
    userBox.add(user);
    nameController.clear();
    ageController.clear();
    setState(() {});
  }

  // UPDATE
  void updateUser(int index) {
    final user = userBox.getAt(index);
    user!.name = nameController.text;
    user.age = int.parse(ageController.text);
    user.save();
    setState(() {});
  }

  // DELETE
  void deleteUser(int index) {
    userBox.deleteAt(index);
    setState(() {});
  }

  // LOAD DATA INTO FIELDS
  void loadUser(int index) {
    final user = userBox.getAt(index);
    nameController.text = user!.name;
    ageController.text = user.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hive CRUD Example")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: addUser, child: Text("Add")),
              ],
            ),

            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: userBox.length,
                itemBuilder: (context, index) {
                  final user = userBox.getAt(index);

                  return Card(
                    child: ListTile(
                      title: Text(user!.name),
                      subtitle: Text("Age: ${user.age}"),
                      onTap: () => loadUser(index),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => updateUser(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteUser(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

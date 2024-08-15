// ignore_for_file: use_super_parameters, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter_school_app/data/utils/database_helper.dart';
// import 'package:flutter_school_app/screen/navbar.dart';
// import 'package:abc/services/auth_repository.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> myData = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.getItems();
    setState(() {
      myData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      // drawer: NavBar(),
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       CircleAvatar(
      //         backgroundImage: NetworkImage(user!.photoURL!),
      //         radius: 17,
      //       ),
      //       SizedBox(
      //         width: 10,
      //       ),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Text(
      //             user.displayName!,
      //             style: TextStyle(
      //                 fontSize: 18.0,
      //                 fontWeight: FontWeight.bold), // Customize title style
      //           ),
      //           Text(
      //             user.email!,
      //             style: TextStyle(
      //                 fontSize: 12.0,
      //                 color: Colors.grey), // Customize subtitle style
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //   backgroundColor: Colors.red,

      //   // actions: <Widget>[
      //   //   ElevatedButton.icon(
      //   //     onPressed: () {
      //   //       AuthRepository()
      //   //           .signOutWithGoogle()
      //   //           .whenComplete(Navigator.of(context).pop);
      //   //     },
      //   //     icon: Icon(Icons.logout),
      //   //     label: Text("Log Out"),
      //   //   ),
      //   // ],
      //   // centerTitle: true,
      //   //  automaticallyImplyLeading: false,
      // ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : myData.isEmpty
              ? const Center(child: Text("No Data Available!!!"))
              : ListView.builder(
                  itemCount: myData.length,
                  itemBuilder: (context, index) => _buildListItem(index),
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showMyForm(null),
      ),
    );
  }

  Widget _buildListItem(int index) {
    return Card(
      color: index % 2 == 0 ? Colors.green : Colors.green[200],
      margin: const EdgeInsets.all(15),
      child: ListTile(
        title: Text(myData[index]['title']),
        subtitle: Text(myData[index]['description']),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => showMyForm(myData[index]['id']),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteItem(myData[index]['id']),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showMyForm(int? id) async {
    if (id != null) {
      final existingData = myData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descriptionController.text = existingData['description'];
    } else {
      _titleController.text = '';
      _descriptionController.text = '';
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isDismissible: false,
      isScrollControlled: true,
      builder: (_) => _buildForm(id),
    );
  }

  Widget _buildForm(int? id) {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 120,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: _titleController,
              validator: (value) => _formValidator(value, 'Title'),
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              validator: (value) => _formValidator(value, 'Description'),
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Exit"),
                ),
                ElevatedButton(
                  onPressed: () => _saveItem(id),
                  child: Text(id == null ? 'Create New' : 'Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _formValidator(String? value, String fieldName) {
    if (value!.isEmpty) return '$fieldName is Required';
    return null;
  }

  //Save data
  Future<void> _saveItem(int? id) async {
    if (formKey.currentState!.validate()) {
      if (id == null) {
        await addItem();
      } else {
        await updateItem(id);
      }

      setState(() {
        _titleController.text = '';
        _descriptionController.text = '';
      });
      if (mounted) Navigator.of(context).pop();
    }
  }

  //Add data
  Future<void> addItem() async {
    try {
      await DatabaseHelper.createItem(
          _titleController.text, _descriptionController.text);
      await _refreshData();
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  //Update data
  Future<void> updateItem(int id) async {
    try {
      await DatabaseHelper.updateItem(
          id, _titleController.text, _descriptionController.text);
      await _refreshData();
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  //Delete data
  void deleteItem(int id) async {
    try {
      await DatabaseHelper.deleteItem(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully deleted!'),
          backgroundColor: Colors.green,
        ),
      );
      await _refreshData();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
}

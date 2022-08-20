// ignore_for_file: unrelated_type_equality_checks

import 'package:database/authentications/firebase_loging.dart';
import 'package:database/views/edit.dart';
import 'package:database/views/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuthentication auth = FirebaseAuthentication();
  final _formKey = GlobalKey<FormState>();
  String message = '';

  final TextEditingController title = TextEditingController();

  final TextEditingController description = TextEditingController();
  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments;
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  auth.logout();
                  Navigator.pushNamed(context, 'login');
                });
              },
              child: Center(
                child: Text(
                  'Log out ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.redAccent),
                ),
              ),
            ),
          ],
          // elevation: 0.0,
          title: Text(
            'Tasks',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: isAdding
                ? addTask(
                    context, _formKey, title, description, userId.toString())
                : StreamBuilder(
                    stream: tasks.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapShot) {
                      if (snapShot.hasError) {
                        return Text(
                          'Error ${snapShot.error.toString()}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                      }
                      if (snapShot.hasData) {
                        return ListView.builder(
                            itemCount: snapShot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  snapShot.data!.docs[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UpdateTaskScreen(
                                          title: documentSnapshot['title'],
                                          taskId: documentSnapshot.id,
                                          description:
                                              documentSnapshot['description']),
                                    ),
                                  );
                                },
                                leading: const Icon(Icons.check_circle),
                                title: Text(
                                  documentSnapshot['title'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                subtitle: Text(documentSnapshot['description']),
                                trailing: InkWell(
                                  onTap: () {
                                    tasks.doc(documentSnapshot.id).delete();
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }));
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.green,
                        value: snapShot.connectionState.index / 2,
                      ));
                    })),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isAdding = !isAdding;
            });
          },
          child: Center(
              child: Icon(isAdding ? Icons.minimize_outlined : Icons.add)),
        ),
      ),
    );
  }
}

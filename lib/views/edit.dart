import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateTaskScreen extends StatefulWidget {
  String title;
  String description;
  String taskId;
  UpdateTaskScreen(
      {Key? key,
      required this.title,
      required this.taskId,
      required this.description})
      : super(key: key);

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  void initialize() {
    titleController.text = widget.title;
    descriptionController.text = widget.description;

    setState(() {});
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var message = '';
    final formKey = GlobalKey<FormState>();
    // Future<void> updateTask() {
    //   return tasks.add({
    //     'title': headline6.text, // John Doe
    //     'description': description.text, // Stokes and Sons
    //   }).then((value) {
    //     message = 'Task Edited Successfully';
    //     // print(value.id)
    //     // Navigator.pushNamed(context, 'HOME', arguments: value.id);
    //   }).catchError((error) {
    //     message = "Failed to add Task: $error";
    //   });
    // }

    // tasks.doc(documentSnapshot.id).delete();

    Future<void> updateTask(String title, String id, String desc) async {
      await tasks
          .doc(id)
          .update({'title': title, 'description': desc}).then((value) {
        message = 'Task Edited Successfully';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        setState(() {});
        // print(value.id)
        Navigator.pushNamed(context, 'HOME', arguments: id);
      }).catchError((error) {
        message = "Failed to add Task: $error";
        setState(() {});
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,

        // elevation: 0.0,

        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Spacer(
                flex: 3,
              ),
              Center(
                child: TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey, fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 1.2, color: Colors.redAccent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 0.4, color: Colors.red),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 0.4, color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 1.2, color: Colors.redAccent),
                    ),
                  ),
                  validator: ((val) {
                    if (val!.isEmpty) {
                      return 'Cannot be null';
                    }
                    return null;
                  }),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              TextFormField(
                controller: descriptionController,
                maxLength: 100,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey, fontSize: 16),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 0.4, color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 0.4, color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(width: 1.2, color: Colors.redAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(width: 1.2, color: Colors.redAccent),
                  ),
                ),
                validator: ((val) {
                  if (val!.isEmpty) {
                    return 'Cannot be null';
                  }
                  return null;
                }),
              ),
              const Spacer(
                flex: 3,
              ),
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    updateTask(titleController.text, widget.taskId,
                        descriptionController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      'UPDATE',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

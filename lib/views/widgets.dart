import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget addTask(context, formKey, TextEditingController title,
    TextEditingController description, String userId) {
  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
  var message = '';

  Future<void> postTask() {
    return tasks.add({
      'title': title.text, // John Doe
      'description': description.text, // Stokes and Sons
    }).then((value) {
      message = 'Task added Successfully';
      // print(value.id)
      Navigator.pushNamed(context, 'HOME', arguments: value.id);
    }).catchError((error) {
      message = "Failed to add Task: $error";
    });
  }

  return Form(
    key: formKey,
    child: Column(
      children: [
        const Spacer(
          flex: 3,
        ),
        Center(
          child: TextFormField(
            controller: title,
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
                borderSide: const BorderSide(width: 0.4, color: Colors.red),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 0.4, color: Colors.red),
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
          controller: description,
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
              borderSide: const BorderSide(width: 1.2, color: Colors.redAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(width: 1.2, color: Colors.redAccent),
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
              postTask();

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
                'ADD TASK',
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
  );
}

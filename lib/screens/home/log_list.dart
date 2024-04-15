import 'package:firebase_auth_app/models/log.dart';
import 'package:firebase_auth_app/services/encrypt_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class LogList extends StatefulWidget {
  const LogList({super.key});

  @override
  State<LogList> createState() => _LogListState();
}

class _LogListState extends State<LogList> {

  

  @override
  Widget build(BuildContext context) {

    final logs = Provider.of<List<Log>?>(context);

    if (logs != null) {

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(logs[index].timeStamp!.toDate().toString()),
                  subtitle: Text(cypher.decrypt(logs[index].message!)),
                );
              }
            ),
          )
        ],
      )
    );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
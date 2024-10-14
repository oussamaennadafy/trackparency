import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _expenseSubscription;
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _expenseSubscription = FirebaseFirestore.instance.collection('expenses').orderBy("timestamp", descending: true).snapshots().listen(
          (snapshot) {
            _expenses = [];
            for (final document in snapshot.docs) {
              _expenses.add(
                Expense(
                  id: document.id,
                  paymentMethod: document.data()['paymentMethod'],
                  category: document.data()['category'],
                  title: document.data()['title'],
                  price: document.data()['price'],
                  comment: document.data()['comment'],
                  timestamp: document.data()['timestamp'].toDate(),
                ),
              );
            }
            notifyListeners();
          },
        );
      } else {
        _loggedIn = false;
        _expenses = [];
        _expenseSubscription?.cancel();
      }
      notifyListeners();
    });

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addExpense(Expense expense) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('expenses').add(<String, dynamic>{
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'paymentMethod': expense.paymentMethod,
      'category': expense.category,
      'comment': expense.comment,
      'title': expense.title,
      'price': expense.price,
      'timestamp': expense.timestamp,
    });
  }

  Future<void> deleteExpense(String expenseId) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('expenses').doc(expenseId).delete();
  }
}

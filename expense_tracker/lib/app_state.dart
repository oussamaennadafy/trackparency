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

  int _balance = 0;
  int get balance => _balance;

  bool _isBalanceLoading = true;
  bool get isBalanceLoading => _isBalanceLoading;

  StreamSubscription<QuerySnapshot>? _expenseSubscription;
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _fetchUserBalance();
        _expenseSubscription = FirebaseFirestore.instance.collection('expenses').where('userId', isEqualTo: user.uid).orderBy("timestamp", descending: true).snapshots().listen(
          (snapshot) {
            _expenses = [];
            for (final document in snapshot.docs) {
              _expenses.add(
                Expense(
                  id: document.id,
                  paymentMethod: document.data()['paymentMethod'] as String,
                  category: document.data()['category'] as String,
                  title: document.data()['title'] as String,
                  price: (document.data()['price'] as num).toInt(),
                  comment: document.data()['comment'] as String,
                  timestamp: (document.data()['timestamp'] as Timestamp).toDate(),
                ),
              );
            }
            notifyListeners();
          },
        );
      } else {
        _loggedIn = false;
        _balance = 0;
        _expenses = [];
        _isBalanceLoading = false;
        _expenseSubscription?.cancel();
      }
      notifyListeners();
    });

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
  }

  Future<void> _fetchUserBalance() async {
    _isBalanceLoading = true;
    notifyListeners();

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      if (userDoc.exists) {
        _balance = (userDoc.data()?['balance'] as num?)?.toInt() ?? 0;
      } else {
        // If the user document doesn't exist, create it with a default balance
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'balance': 0
        });
        _balance = 0;
      }
    } catch (e) {
      print('Error fetching user balance: $e');
      _balance = 0;
    } finally {
      _isBalanceLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBalance(int amount) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    _balance += amount;
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'balance': _balance
    });
    notifyListeners();
  }

  Future<void> setBalance(int newBalance) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    _balance = newBalance;
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'balance': _balance
    });
    notifyListeners();
  }

  Future<DocumentReference<Map<String, dynamic>>> addExpense(Expense expense) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    await updateBalance(-expense.price);

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

  Future<void> updateExpense(Expense oldExpense, Expense newExpense) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // Update balance: add back the old expense amount and subtract the new one
    await updateBalance(oldExpense.price - newExpense.price);

    await FirebaseFirestore.instance.collection('expenses').doc(oldExpense.id).update(<String, dynamic>{
      'paymentMethod': newExpense.paymentMethod,
      'category': newExpense.category,
      'comment': newExpense.comment,
      'title': newExpense.title,
      'price': newExpense.price,
      'timestamp': newExpense.timestamp,
    });
  }

  Future<void> deleteExpense(Expense expense) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // Update balance: add back the deleted expense amount
    await updateBalance(expense.price);

    await FirebaseFirestore.instance.collection('expenses').doc(expense.id).delete();
  }

  Future<void> addIncome(int amount, String description) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    await updateBalance(amount);

    await FirebaseFirestore.instance.collection('income').add(<String, dynamic>{
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'amount': amount,
      'description': description,
      'timestamp': DateTime.now(),
    });
  }
}

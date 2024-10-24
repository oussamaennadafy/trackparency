import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/tabs/transactions/models/transaction.dart' as transaction_model;
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'firebase_options.dart';

class TransactionActions {
  static const add = "ADD";
  static const update = "UPDATE";
  static const delete = "DELETE";
}

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

  StreamSubscription<QuerySnapshot>? _transactionSubscription;
  List<transaction_model.Transaction> _transactions = [];
  List<transaction_model.Transaction> get transactions => _transactions;

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _fetchUserBalance();
        _transactionSubscription = FirebaseFirestore.instance.collection('transactions').where('userId', isEqualTo: user.uid).orderBy("timestamp", descending: true).snapshots().listen(
          (snapshot) {
            _transactions = [];
            for (final document in snapshot.docs) {
              _transactions.add(
                transaction_model.Transaction(
                  id: document.id,
                  paymentMethod: document.data()['paymentMethod'] as String,
                  category: document.data()['category'] as String,
                  title: document.data()['title'] as String,
                  price: (document.data()['price'] as num).toInt(),
                  comment: document.data()['comment'] as String,
                  type: document.data()['type'] as String,
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
        _transactions = [];
        _isBalanceLoading = false;
        _transactionSubscription?.cancel();
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

  Future<void> updateBalance({
    String actionType = TransactionActions.add,
    String transactionType = transaction_model.TransactionType.expense,
    int amount = 0,
  }) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    switch (actionType) {
      case TransactionActions.add:
        {
          // handle balance logic
          if (transactionType == transaction_model.TransactionType.expense) {
            _balance -= amount;
          }

          if (transactionType == transaction_model.TransactionType.income) {
            _balance += amount;
          }
        }
        break;
      case TransactionActions.delete:
        {
          // handle balance logic
          if (transactionType == transaction_model.TransactionType.expense) {
            _balance += amount;
          }

          if (transactionType == transaction_model.TransactionType.income) {
            _balance -= amount;
          }
        }
        break;
      case TransactionActions.update:
        {
          // handle balance logic
          if (transactionType == transaction_model.TransactionType.expense) {
            _balance += amount;
          }

          if (transactionType == transaction_model.TransactionType.income) {
            _balance -= amount;
          }
        }
        break;
    }

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'balance': _balance
    });
    notifyListeners();
  }

  Future<DocumentReference<Map<String, dynamic>>> addTransaction(transaction_model.Transaction transaction) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    await updateBalance(
      actionType: TransactionActions.add,
      transactionType: transaction.type,
      amount: transaction.price,
    );

    return FirebaseFirestore.instance.collection('transactions').add(<String, dynamic>{
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'paymentMethod': transaction.paymentMethod,
      'category': transaction.category,
      'comment': transaction.comment,
      'title': transaction.title,
      'price': transaction.price,
      'timestamp': transaction.timestamp,
      'type': transaction.type,
    });
  }

  Future<void> updateTransaction(transaction_model.Transaction oldTransaction, transaction_model.Transaction newTransaction) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    // Update balance: add back the old transaction amount and subtract the new one
    await updateBalance(
      actionType: TransactionActions.update,
      transactionType: oldTransaction.type,
      amount: oldTransaction.price - newTransaction.price,
    );

    await FirebaseFirestore.instance.collection('transactions').doc(oldTransaction.id).update(<String, dynamic>{
      'paymentMethod': newTransaction.paymentMethod,
      'category': newTransaction.category,
      'comment': newTransaction.comment,
      'title': newTransaction.title,
      'price': newTransaction.price,
      'timestamp': newTransaction.timestamp,
    });
  }

  Future<void> deleteTransaction(transaction_model.Transaction transaction) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // Update balance: add back the deleted transaction amount
    await updateBalance(
      actionType: TransactionActions.delete,
      transactionType: transaction.type,
      amount: transaction.price,
    );

    await FirebaseFirestore.instance.collection('transactions').doc(transaction.id).delete();
  }
}

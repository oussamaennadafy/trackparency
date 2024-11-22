import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/categories/models/category.dart';
import 'package:expense_tracker/features/categories/models/selected_category.dart';
import 'package:expense_tracker/features/home/models/top_category.dart';
import 'package:expense_tracker/features/transactions/models/transaction.dart' as transaction_model;
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'firebase_options.dart';

enum OnboardingStatus {
  notStarted,
  balanceSet,
  categoriesSet,
  completed
}

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

  OnboardingStatus _onboardingStatus = OnboardingStatus.notStarted;
  OnboardingStatus get onboardingStatus => _onboardingStatus;

  bool _isCheckingOnboarding = true;
  bool get isCheckingOnboarding => _isCheckingOnboarding;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isCategoriesLoading = true;
  bool get isCategoriesLoading => _isCategoriesLoading;

  // Added: User's selected categories
  List<SelectedCategory> _userSelectedCategories = [];
  List<SelectedCategory> get userSelectedCategories => _userSelectedCategories;

  // accumulations
  int _dayAccumulation = 0;
  int get dayAccumulation => _dayAccumulation;
  int _weekAccumulation = 0;
  int get weekAccumulation => _weekAccumulation;
  int _monthAccumulation = 0;
  int get monthAccumulation => _monthAccumulation;

  // list of three categories
  List<TopCategory> _topThreeSpendingCategories = [];
  List<TopCategory> get topThreeSpendingCategories => _topThreeSpendingCategories;
  // setter of _topThreeSpendingCategories
  set setTopThreeSpendingCategories(List<TopCategory> topThreeSpendingCategories) {
    _topThreeSpendingCategories = topThreeSpendingCategories;
  }

  // function getter
  get fetchTopThreeSpendingCategories => _fetchTopThreeSpendingCategories();

  bool _isTopThreeSpendingCategoriesLoading = true;
  bool get isTopThreeSpendingCategoriesLoading => _isTopThreeSpendingCategoriesLoading;

  StreamSubscription<QuerySnapshot>? _transactionSubscription;
  List<transaction_model.Transaction> _transactions = [];
  List<transaction_model.Transaction> get transactions => _transactions;

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;
        _checkOnboardingStatus();
        _fetchUserBalance();
        await _fetchCategories(user.uid);
        _fetchAccumulations();
        _fetchTopThreeSpendingCategories();
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
        _isCheckingOnboarding = false;
        _categories = [];
        _userSelectedCategories = [];
        _isCategoriesLoading = false;
        _dayAccumulation = 0;
        _topThreeSpendingCategories = [];
        _onboardingStatus = OnboardingStatus.notStarted;
        _transactionSubscription?.cancel();
      }
      notifyListeners();
    });

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
  }

  Future<void> _fetchTopThreeSpendingCategories() async {
    // now
    final now = DateTime.now();
    // Month range
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    // month total
    int mountTotal = 0;

    final monthTransactions = await FirebaseFirestore.instance
        .collection('transactions')
        .where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .where(
          "type",
          isEqualTo: transaction_model.TransactionType.expense,
        )
        .where(
          "timestamp",
          isGreaterThanOrEqualTo: startOfMonth,
          isLessThanOrEqualTo: endOfMonth,
        )
        .get();

    final Map<String, TopCategory> listOfTopThree = {};

    // loop throught monthTransactions and calculate sum of categories
    for (var i = 0; i < monthTransactions.docs.length; i++) {
      final transaction = monthTransactions.docs[i].data();
      final category = transaction["category"];
      TopCategory? topCategory = listOfTopThree[category];
      if (topCategory == null) {
        final fullcategory = userSelectedCategories.where((el) => el.name == category).first;
        listOfTopThree[category] = TopCategory(
          icon: fullcategory.icon,
          color: fullcategory.color,
          name: category,
          total: transaction["price"],
        );
      } else {
        topCategory.total += transaction["price"] as int;
      }
      // add mountTotal
      mountTotal += transaction["price"] as int;
    }

    var sortedList = (listOfTopThree.values.toList()..sort((a, b) => b.total.compareTo(a.total)));

    if (sortedList.length >= 3) sortedList = sortedList.sublist(0, 3);

    // fill listOfTopThree with empty categories if not enough
    if (sortedList.length < 3) {
      final List<SelectedCategory> placeHolderCategories = [];
      for (var i = 0; i < userSelectedCategories.length; i++) {
        if (sortedList.length + placeHolderCategories.length >= 3) break;
        final item = sortedList.where((element) => element.name == userSelectedCategories[i].name);
        if (item.isEmpty) {
          placeHolderCategories.add(userSelectedCategories[i]);
        }
      }

      for (var i = 0; i < placeHolderCategories.length; i++) {
        sortedList.add(
          TopCategory(
            icon: placeHolderCategories[i].icon,
            name: placeHolderCategories[i].name,
            color: placeHolderCategories[i].color,
            total: 0,
            percentage: 0,
          ),
        );
      }
    }

    for (var i = 0; i < sortedList.length; i++) {
      if (mountTotal == 0) {
        mountTotal = 1;
      }
      sortedList[i].percentage = (sortedList[i].total / mountTotal * 100);
    }

    _topThreeSpendingCategories = sortedList;
    _isTopThreeSpendingCategoriesLoading = false;
    notifyListeners();
  }

  Future<void> _fetchAccumulations() async {
    try {
      final now = DateTime.now();

      // Get correct week boundaries
      final currentDay = now.day;
      int weekStart;
      int weekEnd;

      if (currentDay <= 7) {
        weekStart = 1;
        weekEnd = 7;
      } else if (currentDay <= 14) {
        weekStart = 8;
        weekEnd = 14;
      } else if (currentDay <= 21) {
        weekStart = 15;
        weekEnd = 21;
      } else if (currentDay <= 28) {
        weekStart = 22;
        weekEnd = 28;
      } else {
        // For days 29-31, they form their own "week"
        weekStart = 29;
        weekEnd = DateTime(now.year, now.month + 1, 0).day; // Last day of current month
      }

      // Day range (current day)
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Week range
      final startOfWeek = DateTime(now.year, now.month, weekStart);
      final endOfWeek = DateTime(now.year, now.month, weekEnd, 23, 59, 59);

      // Month range
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final transactions = FirebaseFirestore.instance
          .collection('transactions')
          .where(
            "userId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .where(
            "type",
            isEqualTo: transaction_model.TransactionType.expense,
          );

      final dayTransactions = await transactions
          .where(
            "timestamp",
            isGreaterThanOrEqualTo: startOfDay,
            isLessThanOrEqualTo: endOfDay,
          )
          .get();

      final weekTransactions = await transactions
          .where(
            "timestamp",
            isGreaterThanOrEqualTo: startOfWeek,
            isLessThanOrEqualTo: endOfWeek,
          )
          .get();

      final monthTransactions = await transactions
          .where(
            "timestamp",
            isGreaterThanOrEqualTo: startOfMonth,
            isLessThanOrEqualTo: endOfMonth,
          )
          .get();

      // Calculate totals
      int dayTotalExpenses = 0;
      for (var doc in dayTransactions.docs) {
        dayTotalExpenses += (doc.data()['price'] as num).toInt();
      }

      int weekTotalExpenses = 0;
      if (startOfWeek.month == now.month) {
        for (var doc in weekTransactions.docs) {
          weekTotalExpenses += (doc.data()['price'] as num).toInt();
        }
      }

      int monthTotalExpenses = 0;
      if (startOfMonth.month == now.month) {
        for (var doc in monthTransactions.docs) {
          monthTotalExpenses += (doc.data()['price'] as num).toInt();
        }
      }

      _dayAccumulation = dayTotalExpenses;
      _weekAccumulation = weekTotalExpenses;
      _monthAccumulation = monthTotalExpenses;

      notifyListeners();
    } catch (e) {
      print('Error fetching accumulations: $e');
    }
  }

  Future<void> _updateAccumulations({
    required String actionType,
    required int amount,
    required DateTime transactionDate,
    DateTime? oldTransactionDate, // Add this for updates
  }) async {
    final now = DateTime.now();

    // Helper function to get week number
    int getWeekNumber(DateTime date) {
      final day = date.day;
      if (day <= 7) return 1;
      if (day <= 14) return 2;
      if (day <= 21) return 3;
      if (day <= 28) return 4;
      return 5; // days 29-31
    }

    // Helper function to check if date is in current month
    bool isCurrentMonth(DateTime date) {
      return date.year == now.year && date.month == now.month;
    }

    // Helper function to check if date is today
    bool isCurrentDay(DateTime date) {
      return date.year == now.year && date.month == now.month && date.day == now.day;
    }

    // Helper function to check if date is in specific week
    bool isInWeek(DateTime date, int weekNumber) {
      if (!isCurrentMonth(date)) return false;
      return getWeekNumber(date) == weekNumber;
    }

    switch (actionType) {
      case TransactionActions.add:
        if (isCurrentDay(transactionDate)) {
          _dayAccumulation += amount;
        }
        if (isCurrentMonth(transactionDate)) {
          _monthAccumulation += amount;
          if (isInWeek(transactionDate, getWeekNumber(now))) {
            _weekAccumulation += amount;
          }
        }
        break;

      case TransactionActions.delete:
        if (isCurrentDay(transactionDate)) {
          _dayAccumulation -= amount;
        }
        if (isCurrentMonth(transactionDate)) {
          _monthAccumulation -= amount;
          if (isInWeek(transactionDate, getWeekNumber(now))) {
            _weekAccumulation -= amount;
          }
        }
        break;

      case TransactionActions.update:
        if (oldTransactionDate != null) {
          // First remove the old transaction's effect
          if (isCurrentDay(oldTransactionDate)) {
            _dayAccumulation += amount; // amount is already negative for expense
          }
          if (isCurrentMonth(oldTransactionDate)) {
            _monthAccumulation += amount;
            if (isInWeek(oldTransactionDate, getWeekNumber(now))) {
              _weekAccumulation += amount;
            }
          }

          // Then add the new transaction's effect
          final newAmount = -amount; // Reverse the amount for the new transaction
          if (isCurrentDay(transactionDate)) {
            _dayAccumulation += newAmount;
          }
          if (isCurrentMonth(transactionDate)) {
            _monthAccumulation += newAmount;
            if (isInWeek(transactionDate, getWeekNumber(now))) {
              _weekAccumulation += newAmount;
            }
          }
        }
        break;
    }

    notifyListeners();
  }

  Future<void> _fetchCategories(String userId) async {
    _isCategoriesLoading = true;
    notifyListeners();

    try {
      // Fetch all categories (default and user's custom)
      final categorySnapshot = await FirebaseFirestore.instance.collection('categories').where('userId', whereIn: [
        userId,
        'ALL'
      ]).get();

      _categories = categorySnapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();

      // Fetch user's selected categories
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists && userDoc.data()?['selectedCategories'] != null) {
        _userSelectedCategories = List<dynamic>.from(userDoc.data()?['selectedCategories'] as List).map((data) => SelectedCategory.fromMap(data as Map<String, dynamic>)).toList();
      } else {
        _userSelectedCategories = [];
      }
    } catch (e) {
      print('Error fetching categories: $e');
      _categories = [];
      _userSelectedCategories = [];
    } finally {
      _isCategoriesLoading = false;
      notifyListeners();
    }
  }

  // Added: Save user's selected categories
  Future<void> saveUserCategories(List<SelectedCategory> selectedCategories) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'selectedCategories': selectedCategories.map((cat) => cat.toMap()).toList(),
    }, SetOptions(merge: true));

    _userSelectedCategories = selectedCategories;
    notifyListeners();
  }

  Future<Category> addCustomCategory(String name, String icon) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    final docRef = await FirebaseFirestore.instance.collection('categories').add({
      'name': name,
      'icon': icon,
      'color': 'onSurface',
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });

    final newCategory = Category(
      id: docRef.id,
      name: name,
      icon: icon,
      color: 'onSurface',
      userId: FirebaseAuth.instance.currentUser!.uid,
    );

    _categories.add(newCategory);
    notifyListeners();

    return newCategory;
  }

  Future<void> _checkOnboardingStatus() async {
    _isCheckingOnboarding = true;
    notifyListeners();

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      if (!userDoc.exists) {
        _onboardingStatus = OnboardingStatus.notStarted;
      } else {
        final status = userDoc.data()?['onboardingStatus'] as String?;
        _onboardingStatus = status != null ? OnboardingStatus.values.firstWhere((e) => e.toString() == 'OnboardingStatus.$status', orElse: () => OnboardingStatus.notStarted) : OnboardingStatus.notStarted;
      }
    } catch (e) {
      print('Error checking onboarding status: $e');
      _onboardingStatus = OnboardingStatus.notStarted;
    } finally {
      _isCheckingOnboarding = false;
      notifyListeners();
    }
  }

  Future<void> updateOnboardingStatus(OnboardingStatus status) async {
    _onboardingStatus = status;
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'onboardingStatus': status.toString().split('.').last,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future<void> _fetchUserBalance() async {
    _isBalanceLoading = true;
    notifyListeners();

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      if (userDoc.exists) {
        _balance = (userDoc.data()?['balance'] as num?)?.toInt() ?? 0;
      } else {
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

  void addTransaction(transaction_model.Transaction transaction) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // update Accumulations
    // if (transaction.type == transaction_model.TransactionType.expense) {
    //   await _updateAccumulations(
    //     actionType: TransactionActions.add,
    //     amount: transaction.price,
    //     transactionDate: transaction.timestamp,
    //   );
    // }
    _fetchAccumulations();

    // update balance
    updateBalance(
      actionType: TransactionActions.add,
      transactionType: transaction.type,
      amount: transaction.price,
    );

    // add transaction
    await FirebaseFirestore.instance.collection('transactions').add(<String, dynamic>{
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'paymentMethod': transaction.paymentMethod,
      'category': transaction.category,
      'comment': transaction.comment,
      'title': transaction.title,
      'price': transaction.price,
      'timestamp': transaction.timestamp,
      'type': transaction.type,
    });

    // update top categories
    _fetchTopThreeSpendingCategories();
  }

  void updateTransaction(transaction_model.Transaction oldTransaction, transaction_model.Transaction newTransaction) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // if (oldTransaction.type == transaction_model.TransactionType.expense) {
    //   await _updateAccumulations(
    //     actionType: TransactionActions.update,
    //     amount: oldTransaction.price - newTransaction.price,
    //     transactionDate: newTransaction.timestamp,
    //     oldTransactionDate: oldTransaction.timestamp,
    //   );
    // }
    _fetchAccumulations();

    updateBalance(
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

    // update top categories
    _fetchTopThreeSpendingCategories();
  }

  Future<void> deleteTransaction(transaction_model.Transaction transaction) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // if (transaction.type == transaction_model.TransactionType.expense) {
    //   await _updateAccumulations(
    //     actionType: TransactionActions.delete,
    //     amount: transaction.price,
    //     transactionDate: transaction.timestamp,
    //   );
    // }
    _fetchAccumulations();

    updateBalance(
      actionType: TransactionActions.delete,
      transactionType: transaction.type,
      amount: transaction.price,
    );

    await FirebaseFirestore.instance.collection('transactions').doc(transaction.id).delete();

    // update top categories
    _fetchTopThreeSpendingCategories();
  }
}

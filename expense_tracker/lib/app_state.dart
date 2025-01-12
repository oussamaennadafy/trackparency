import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/categories/models/category.dart';
import 'package:expense_tracker/features/categories/models/selected_category.dart';
import 'package:expense_tracker/enums/index.dart';
import 'package:expense_tracker/features/home/models/chart_data.dart';
import 'package:expense_tracker/features/home/models/top_category.dart';
import 'package:expense_tracker/features/transactions/models/transaction.dart' as transaction_model;
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/data/drop_down_items.dart';
import 'package:expense_tracker/utils/date_manipulators/get_last_seven_months.dart';
import 'package:expense_tracker/utils/date_manipulators/get_last_seven_weeks.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'firebase_options.dart';

// Day range (current day)
final now = DateTime.now();
final startOfDay = DateTime(now.year, now.month, now.day);
final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

// Week range
final startOfWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));
final endOfWeek = DateTime(now.year, now.month, now.day + (7 - now.weekday));

// Month range
final startOfMonth = DateTime(now.year, now.month, 1);
final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  int _balance = 0;
  int get balance => _balance;

  // bool _isBalanceLoading = true;
  // bool get isBalanceLoading => _isBalanceLoading;

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

  // selected dateFrame
  DateFrame _selectedDateFrame = DateFrame.day;
  DateFrame get selectedDateFrame => _selectedDateFrame;

  // _setSelectedDateFrame
  set setSelectedDateFrame(DateFrame selectedDateFrame) {
    _selectedDateFrame = selectedDateFrame;
    _fetchTopThreeSpendingCategories(_selectedDateFrame);
    _fetchChartData(_selectedDateFrame, _selectedTab);
    notifyListeners();
  }

  // selected month
  String _selectedMonth = Months.values[DateTime.now().month - 1].toString().split(".")[1].toLowerCase();
  String get selectedMonth => _selectedMonth;

  String _selectedTab = "Expenses";
  String get selectedTab => _selectedTab;

  set setSelectedTab(String selectedTab) {
    _selectedTab = selectedTab;
    _fetchChartData(_selectedDateFrame, selectedTab);
    _fetchAccumulations(selectedTab);
    _fetchTopThreeSpendingCategories(_selectedDateFrame);
    notifyListeners();
  }

  // set selected month
  set setSelectedMonth(String selectedMonth) {
    _selectedDateFrame = DateFrame.month;
    _selectedMonth = selectedMonth;
    _fetchMonthAccumulation(selectedMonth);
    _fetchTopThreeSpendingCategories(_selectedDateFrame, selectedMonth);
    notifyListeners();
  }

  // function getter
  get fetchTopThreeSpendingCategories => _fetchTopThreeSpendingCategories(_selectedDateFrame);

  bool _deleteCustomCategoryLoading = false;
  bool get deleteCustomCategoryLoading => _deleteCustomCategoryLoading;

  ChartData? _chartData;
  ChartData? get chartData => _chartData;

  bool _chartDataLoading = true;
  get chartDataLoading => _chartDataLoading;

  StreamSubscription<QuerySnapshot>? _transactionSubscription;
  List<transaction_model.Transaction> _transactions = [];
  List<transaction_model.Transaction> get transactions => _transactions;

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;
        _checkOnboardingStatus();
        await _fetchCategories(user.uid);
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
            _fetchUserBalance();
            _fetchChartData(_selectedDateFrame, _selectedTab);
            _fetchAccumulations(_selectedTab);
            _fetchTopThreeSpendingCategories(_selectedDateFrame);
            notifyListeners();
          },
        );
      } else {
        _loggedIn = false;
        _balance = 0;
        _transactions = [];
        // _isBalanceLoading = false;
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

  Future<void> refreshTransactions() async {
    final transactions = await FirebaseFirestore.instance.collection('transactions').where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).orderBy("timestamp", descending: true).get();
    List<transaction_model.Transaction> transactionsList = [];
    for (final document in transactions.docs) {
      transactionsList.add(
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
    _transactions = transactionsList;
    notifyListeners();
  }

  Future<void> refreshHome() async {
    _selectedTab = "Expenses";
    _selectedDateFrame = DateFrame.day;
    _selectedMonth = Months.values[DateTime.now().month - 1].toString().split(".")[1].toLowerCase();
    await _fetchUserBalance();
    await _fetchChartData(_selectedDateFrame, _selectedTab);
    await _fetchAccumulations(_selectedTab);
    await _fetchTopThreeSpendingCategories(_selectedDateFrame);
    notifyListeners();
  }

  void _fillIncomeCategories() async {
    // Month range
    late final DateTime startOfDateFrame;
    late final DateTime endOfDateFrame;

    switch (_selectedDateFrame) {
      case DateFrame.day:
        startOfDateFrame = startOfDay;
        endOfDateFrame = endOfDay;
        break;
      case DateFrame.week:
        startOfDateFrame = startOfWeek;
        endOfDateFrame = endOfWeek;
        break;
      case DateFrame.month:
        {
          if (_selectedMonth != null) {
            final thisYear = DateTime.now().year;
            final monthNumber = Months.values.map((e) => e.toString().split(".")[1]).toList().indexOf(_selectedMonth) + 1;
            final startOfMonth = DateTime(thisYear, monthNumber, 1);
            final endOfMonth = DateTime(thisYear, monthNumber + 1, 0, 23, 59, 59);
            startOfDateFrame = startOfMonth;
            endOfDateFrame = endOfMonth;
          } else {
            startOfDateFrame = startOfMonth;
            endOfDateFrame = endOfMonth;
          }
        }
        break;
    }
    final transactions = await FirebaseFirestore.instance
        .collection("transactions")
        .where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .where(
          "type",
          isEqualTo: transaction_model.TransactionType.income,
        )
        .where(
          "timestamp",
          isGreaterThanOrEqualTo: startOfDateFrame,
          isLessThanOrEqualTo: endOfDateFrame,
        )
        .get();

    final incomeTransactions = transactions.docs;
    final resultsMap = {};
    var totalAccumulation = 0;
    resultsMap[incomeCategories[0].label] = 0;
    resultsMap[incomeCategories[1].label] = 0;
    resultsMap[incomeCategories[2].label] = 0;
    for (final transaction in incomeTransactions) {
      final category = transaction.data()["category"];
      final price = transaction.data()["price"];
      resultsMap[category] += price;
      totalAccumulation += price as int;
    }
    // print(totalAccumulation);
    final List<TopCategory> topThree = [];
    for (final category in incomeCategories) {
      topThree.add(
        TopCategory(
          icon: category.icon!,
          name: category.label,
          color: category.backgroundColor,
          total: resultsMap[category.label],
          percentage: 0,
        ),
      );
    }
    for (var i = 0; i < topThree.length; i++) {
      if (totalAccumulation == 0) {
        totalAccumulation = 1;
      }
      topThree[i].percentage = (topThree[i].total / totalAccumulation * 100);
    }
    var sortedList = (topThree.toList()..sort((a, b) => b.total.compareTo(a.total)));
    _topThreeSpendingCategories = sortedList;
  }

  Future<void> _fetchMonthAccumulation(String month) async {
    final thisYear = DateTime.now().year;
    final monthNumber = Months.values.map((e) => e.toString().split(".")[1]).toList().indexOf(month) + 1;
    final startOfMonth = DateTime(thisYear, monthNumber, 1);
    final endOfMonth = DateTime(thisYear, monthNumber + 1, 0, 23, 59, 59);

    final transactions = FirebaseFirestore.instance
        .collection('transactions')
        .where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .where(
          "type",
          isEqualTo: _selectedTab == "Income" ? transaction_model.TransactionType.income : transaction_model.TransactionType.expense,
        );

    final monthTransactions = await transactions
        .where(
          "timestamp",
          isGreaterThanOrEqualTo: startOfMonth,
          isLessThanOrEqualTo: endOfMonth,
        )
        .get();

    int monthTotalExpenses = 0;
    for (var doc in monthTransactions.docs) {
      monthTotalExpenses += (doc.data()['price'] as num).toInt();
    }

    _monthAccumulation = monthTotalExpenses;
    notifyListeners();
  }

  Future<void> _fetchChartData(DateFrame frametime, [String? selectedTab]) async {
    // // Month range
    late final DateTime startOfDateFrame;
    late final DateTime endOfDateFrame;

    final lastSevenWeeksFrame = getLastSevenWeeks();

    final lastSevenMonthsFrame = getLastSevenMonths();

    switch (frametime) {
      case DateFrame.day:
        startOfDateFrame = startOfWeek;
        endOfDateFrame = endOfWeek;
        break;
      case DateFrame.week:
        startOfDateFrame = lastSevenWeeksFrame.startOfPeriod;
        endOfDateFrame = lastSevenWeeksFrame.endOfPeriod;
        break;
      case DateFrame.month:
        startOfDateFrame = lastSevenMonthsFrame.startOfPeriod;
        endOfDateFrame = lastSevenMonthsFrame.endOfPeriod;
        break;
    }

    final transactions = await FirebaseFirestore.instance
        .collection('transactions')
        .where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .where(
          "type",
          isEqualTo: selectedTab == "Income" ? transaction_model.TransactionType.income : transaction_model.TransactionType.expense,
        )
        .where(
          "timestamp",
          isGreaterThanOrEqualTo: startOfDateFrame,
          isLessThanOrEqualTo: endOfDateFrame,
        )
        .get();

    Map<String, int> resultsMap = {};
    // create resultsMap keys
    for (var i = 0; i < 7; i++) {
      switch (frametime) {
        case DateFrame.day:
          resultsMap[WeekdaysSortcut.values[i].toString().split(".")[1]] = 0;
          break;
        case DateFrame.week:
          {
            final startOfPeriod = lastSevenWeeksFrame.startOfPeriod;
            final start = DateTime(startOfPeriod.year, startOfPeriod.month, startOfPeriod.day + (7 * i)).day;
            final end = DateTime(startOfPeriod.year, startOfPeriod.month, startOfPeriod.day + (7 * (i + 1)) - 1).day;
            resultsMap['$start-$end'] = 0;
          }
          break;
        case DateFrame.month:
          final startOfPeriod = lastSevenMonthsFrame.startOfPeriod;
          final month = DateTime(startOfPeriod.year, startOfPeriod.month + i, 1).month;
          // resultsMap[MonthsShortcut.values[month - 1].toString().split(".")[1]] = 0;
          resultsMap[month.toString()] = 0;
          break;
      }
    }

    // fill resultsMap values
    switch (frametime) {
      case DateFrame.day:
        {
          for (final transaction in transactions.docs) {
            final day = (transaction.data()["timestamp"] as Timestamp).toDate().weekday;
            final price = int.tryParse(transaction.data()["price"].toString());
            resultsMap[WeekdaysSortcut.values[day - 1].toString().split(".")[1]] = resultsMap[WeekdaysSortcut.values[day - 1].toString().split(".")[1]]! + price!;
          }
        }
        break;
      case DateFrame.week:
        {
          final List<int> listOfAccumulations = List.filled(7, 0);
          for (final transaction in transactions.docs) {
            final date = (transaction.data()["timestamp"] as Timestamp).toDate();
            final price = int.tryParse(transaction.data()["price"].toString());
            final index = (date.difference(lastSevenWeeksFrame.startOfPeriod).inDays / 7).floor();
            listOfAccumulations[index] += price ?? 0;
          }
          final listKeys = resultsMap.keys.toList();
          for (var i = 0; i < listKeys.length; i++) {
            resultsMap[listKeys[i]] = listOfAccumulations[i];
          }
        }
        break;
      case DateFrame.month:
        {
          for (final transaction in transactions.docs) {
            final date = (transaction.data()["timestamp"] as Timestamp).toDate();
            if (resultsMap.containsKey(date.month.toString())) {
              final price = int.tryParse(transaction.data()["price"].toString());
              resultsMap[date.month.toString()] = resultsMap[date.month.toString()]! + price!;
            }
          }
          final Map<String, int> tempList = {};
          final listEntries = resultsMap.entries.toList();
          for (var i = 0; i < listEntries.length; i++) {
            tempList[MonthsShortcut.values[int.parse(listEntries[i].key) - 1].toString().split(".")[1]] = listEntries[i].value;
          }
          resultsMap = tempList;
        }
        break;
    }

    Map<String, int> biggestDay = {
      resultsMap.keys.first: resultsMap[resultsMap.keys.first]!,
    };

    resultsMap.forEach((key, value) {
      if (value > biggestDay[biggestDay.keys.first]!) {
        biggestDay = {
          key: value
        };
      }
    });

    _chartData = ChartData(
      biggestDay: BiggestDay(day: biggestDay.keys.first, total: biggestDay.values.first),
      resultsMap: resultsMap.entries.toList(),
    );

    if (_chartDataLoading == true) {
      _chartDataLoading = false;
    }
    notifyListeners();
  }

  Future<void> _fetchTopThreeSpendingCategories(DateFrame frametime, [String? speacialMonth]) async {
    if (_selectedTab == "Income") {
      _fillIncomeCategories();
      return;
    }
    // Month range
    late final DateTime startOfDateFrame;
    late final DateTime endOfDateFrame;

    switch (frametime) {
      case DateFrame.day:
        startOfDateFrame = startOfDay;
        endOfDateFrame = endOfDay;
        break;
      case DateFrame.week:
        startOfDateFrame = startOfWeek;
        endOfDateFrame = endOfWeek;
        break;
      case DateFrame.month:
        {
          if (speacialMonth != null) {
            final thisYear = DateTime.now().year;
            final monthNumber = Months.values.map((e) => e.toString().split(".")[1]).toList().indexOf(speacialMonth) + 1;
            final startOfMonth = DateTime(thisYear, monthNumber, 1);
            final endOfMonth = DateTime(thisYear, monthNumber + 1, 0, 23, 59, 59);
            startOfDateFrame = startOfMonth;
            endOfDateFrame = endOfMonth;
          } else {
            startOfDateFrame = startOfMonth;
            endOfDateFrame = endOfMonth;
          }
        }
        break;
    }
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
          isEqualTo: _selectedTab == "Income" ? transaction_model.TransactionType.income : transaction_model.TransactionType.expense,
        )
        .where(
          "timestamp",
          isGreaterThanOrEqualTo: startOfDateFrame,
          isLessThanOrEqualTo: endOfDateFrame,
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
    notifyListeners();
  }

  Future<void> _fetchAccumulations(String selectedTab) async {
    try {
      final transactions = FirebaseFirestore.instance
          .collection('transactions')
          .where(
            "userId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .where(
            "type",
            isEqualTo: selectedTab == "Income" ? transaction_model.TransactionType.income : transaction_model.TransactionType.expense,
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
      for (var doc in weekTransactions.docs) {
        weekTotalExpenses += (doc.data()['price'] as num).toInt();
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
      //
    }
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
      //
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

  Future<void> deleteCustomCategory(Category category) async {
    _deleteCustomCategoryLoading = true;
    notifyListeners();
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // delete category
    await FirebaseFirestore.instance.collection('categories').doc(category.id).delete();
    // delete userSelectedCategory
    final selectedCategories = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

    final selectedCategoriesDocs = await selectedCategories.get();

    final filteredList = selectedCategoriesDocs.data()!["selectedCategories"].where((item) => item["id"] != category.id);

    await selectedCategories.update({
      "selectedCategories": filteredList,
    });

    _categories = _categories.where((item) => item.name != category.name).toList();

    // delete related transactions
    await deleteAllTransactionsOfCategory(category.name);

    await _fetchTopThreeSpendingCategories(_selectedDateFrame);
    await _fetchAccumulations(_selectedTab);
    _deleteCustomCategoryLoading = false;
    notifyListeners();
  }

  Future<void> deleteAllTransactionsOfCategory(String categoryName) async {
    final transactionsOfCategory = await FirebaseFirestore.instance.collection('transactions').where("category", isEqualTo: categoryName).get();

    final transactionsOfCategoryDoc = transactionsOfCategory.docs;

    for (var i = 0; i < transactionsOfCategoryDoc.length; i++) {
      final transaction = transactionsOfCategoryDoc[i];
      updateBalanceSync(
        actionType: TransactionActions.delete,
        transactionType: transaction.data()["type"],
        amount: transaction.data()["price"],
      );
      await FirebaseFirestore.instance.collection("transactions").doc(transaction.id).delete();
    }
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

  Future<void> updateBalanceSync({
    TransactionActions actionType = TransactionActions.add,
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

  Future<void> updateBalanceAsync() async {
    final user = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    _balance = user.data()?["balance"];
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
    // _fetchAccumulations();

    // update balance
    updateBalanceSync(
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
    // _fetchTopThreeSpendingCategories();
    // fetchChartData
    // _fetchChartData();
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
    // _fetchAccumulations();

    updateBalanceSync(
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
    // _fetchTopThreeSpendingCategories();
    // fetchChartData
    // _fetchChartData();
  }

  Future<void> deleteTransaction(transaction_model.Transaction transaction, [bool? shouldUpdatebalance = true]) async {
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
    // _fetchAccumulations();
    if (shouldUpdatebalance!) {
      updateBalanceSync(
        actionType: TransactionActions.delete,
        transactionType: transaction.type,
        amount: transaction.price,
      );
    }

    await FirebaseFirestore.instance.collection('transactions').doc(transaction.id).delete();

    // // update top categories
    // _fetchTopThreeSpendingCategories();
    // // fetchChartData
    // _fetchChartData();
  }

  Future<void> unselectCategory(List<SelectedCategory> unSelectedCategories) async {
    for (var i = 0; i < unSelectedCategories.length; i++) {
      final category = unSelectedCategories[i];
      await deleteAllTransactionsOfCategory(category.name);
    }
    await _fetchTopThreeSpendingCategories(_selectedDateFrame);
    await _fetchAccumulations(_selectedTab);
    notifyListeners();
  }
}

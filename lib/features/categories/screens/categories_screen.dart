import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/enums/index.dart';
import 'package:expense_tracker/features/categories/models/category.dart';
import 'package:expense_tracker/features/categories/models/selected_category.dart';
import 'package:expense_tracker/features/categories/utils/get_icon_from_string.dart';
import 'package:expense_tracker/features/home/utils/fill_top_categories.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/features/categories/widgets/add_category_modal.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<SelectedCategory> selectedCategories = [];
  List<SelectedCategory> unSelectedCategories = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<ApplicationState>(context, listen: false);
      setState(() {
        selectedCategories = List.from(appState.userSelectedCategories);
      });
    });
  }

  void _handleAddCustomCategory(BuildContext context) {
    AddCategoryModal.show(
      context,
      (name, icon) async {
        final appState = Provider.of<ApplicationState>(context, listen: false);
        final existingCategory = selectedCategories.where((selectedCategory) {
          return selectedCategory.name == name;
        });
        if (existingCategory.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'the category is already exist !',
                style: TextStyle(color: AppColors.primary),
              ),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        final newCategory = await appState.addCustomCategory(name, icon);
        final selectedCategory = SelectedCategory.fromCategory(newCategory);
        setState(() {
          selectedCategories.add(selectedCategory);
        });
      },
    );
  }

  void reSelectCategories() {
    selectedCategories.addAll(unSelectedCategories);
    unSelectedCategories = [];
  }

  Future<void> deleteTransactions() async {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    appState.unselectCategory(unSelectedCategories);
  }

  Future<bool> deleteUnselectedTransactions() async {
    if (unSelectedCategories.isEmpty) return true;
    final confirmed = await confirm(
      context,
      title: const Text("unselect categories detected!"),
      content: const Text("by unselecting a category, means you dont need it any more so we will delete all transactions associated with it. Are you sure you want to proceed?"),
      textOK: const Text(
        "Delete",
      ),
      textCancel: const Text("Cancel"),
    );
    if (confirmed) {
      await deleteTransactions();
    } else {
      reSelectCategories();
    }

    return confirmed;
  }

  Future<void> _handleSubmit() async {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    if (appState.deleteCustomCategoryLoading) return;
    if (selectedCategories.length < 3) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least 3 categories',
            style: TextStyle(color: AppColors.primary),
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      // delete unselected transactions
      final confirmed = await deleteUnselectedTransactions();

      setState(() {
        _isSaving = true;
      });
      // Save selected categories
      await appState.saveUserCategories(selectedCategories);

      // fill top categories
      if (appState.topThreeSpendingCategories.isEmpty) {
        fillTopCategories(context, selectedCategories);
      }

      // Update onboarding status
      await appState.updateOnboardingStatus(OnboardingStatus.completed);

      if (mounted && confirmed) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error saving categories: ${e.toString()}',
              style: const TextStyle(color: AppColors.surface),
            ),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> deleteCategory(Category category) async {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    await appState.deleteCustomCategory(category);
    selectedCategories = selectedCategories.where((item) => item.name != category.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) {
            if (appState.isCategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.onSurface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.category_rounded,
                                    size: 48,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Choose your expense categories',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Select the categories that match your spending habits',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.darkGray,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == appState.categories.length) {
                              return InkWell(
                                onTap: () => _handleAddCustomCategory(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.onSurface,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 32,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Add Custom',
                                        style: TextStyle(
                                          color: AppColors.extraDarkGray,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final category = appState.categories[index];
                            final isSelected = selectedCategories.any((selectedCat) => selectedCat.id == category.id);

                            return InkWell(
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                if (category.userId == "ALL") {}
                                setState(() {
                                  if (isSelected) {
                                    // remove from selectedCategories
                                    selectedCategories.removeWhere((selectedCat) => selectedCat.id == category.id);
                                    //add to unSelectedCategories
                                    unSelectedCategories.add(SelectedCategory.fromCategory(category));
                                  } else {
                                    // add to selectedCategories
                                    selectedCategories.add(SelectedCategory.fromCategory(category));
                                    // remove from unSelectedCategories
                                    unSelectedCategories.removeWhere((selectedCat) => selectedCat.id == category.id);
                                  }
                                });
                              },
                              onLongPress: () async {
                                if (category.userId == "ALL") return;
                                final confirmed = await confirm(
                                  context,
                                  title: const Text("do you want to delete this category?"),
                                  content: const Text("Deleting this category will also delete all transactions associated with it. Are you sure you want to proceed?"),
                                  textOK: const Text(
                                    "Delete",
                                  ),
                                  textCancel: const Text("Cancel"),
                                );
                                if (confirmed) await deleteCategory(category);
                              },
                              child: AnimatedContainer(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: AppColors().get(category.color ?? '') ?? AppColors.onSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (category.icon.startsWith("assets/icons/")) ...[
                                            SvgPicture.asset(category.icon),
                                            const SizedBox(width: 4),
                                          ] else ...[
                                            Icon(
                                              getIconFromString(category.icon),
                                              size: 32,
                                              color: AppColors.extraDarkGray,
                                            ),
                                            const SizedBox(width: 4),
                                          ],
                                          const SizedBox(height: 8),
                                          Text(
                                            category.name,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        right: 6,
                                        top: 10,
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12.0),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            size: 18.0,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: appState.categories.length + 1,
                        ),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 130)),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _isSaving || appState.deleteCustomCategoryLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: AppColors.extraDarkGray,
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.surface,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isSaving) ...[
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.surface,
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              Text(
                                _isSaving ? 'Saving...' : 'Complete Setup (${selectedCategories.length})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!_isSaving) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

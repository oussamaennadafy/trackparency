import 'package:expense_tracker/features/transactions/models/transaction.dart';
import 'package:expense_tracker/shared/components/list_tiles/list_tile.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/utils/formaters/formate_date.dart';
import 'package:expense_tracker/utils/formaters/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableItem extends StatefulWidget {
  const SlidableItem({
    super.key,
    required this.item,
    required this.handleDelete,
    required this.handleEdit,
  });

  final Transaction item;
  final void Function(Transaction transaction) handleDelete;
  final void Function(Transaction) handleEdit;

  @override
  State<SlidableItem> createState() => _SlidableItemState();
}

class _SlidableItemState extends State<SlidableItem> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: AppColors.green,
            icon: Icons.edit,
            label: "edit",
            onPressed: (context) {
              widget.handleEdit(widget.item);
            },
            padding: const EdgeInsets.all(4.0),
          ),
          SlidableAction(
            backgroundColor: AppColors.red,
            icon: Icons.delete,
            label: "delete",
            onPressed: (context) {
              widget.handleDelete(widget.item);
            },
            padding: const EdgeInsets.all(4.0),
          ),
        ],
      ),
      child: AppListTile(
        title: widget.item.title.toString(),
        icon: widget.item.type == TransactionType.expense ? "arrow_downward" : "arrow_upward",
        iconBackgroundColor: widget.item.type == TransactionType.expense ? AppColors.red : AppColors.green,
        trailingTitle: formatePrice(widget.item.price),
        trailingSubTitle: formateDate(widget.item.timestamp),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.w300,
        ),
        subTitle: widget.item.category,
      ),
    );
  }
}

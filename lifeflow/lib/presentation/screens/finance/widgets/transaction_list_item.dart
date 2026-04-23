import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/transaction_model.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TransactionListItem({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'zh_CN',
      symbol: '¥',
    );
    final dateFormat = DateFormat('MM-dd HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: _buildLeadingIcon(),
        title: Row(
          children: [
            Expanded(
              child: Text(
                transaction.category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              currencyFormat.format(transaction.amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction.type == TransactionType.expense
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.note != null && transaction.note!.isNotEmpty)
              Text(
                transaction.note!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              dateFormat.format(transaction.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        isThreeLine: transaction.note != null && transaction.note!.isNotEmpty,
      ),
    );
  }

  Widget _buildLeadingIcon() {
    IconData iconData;
    Color iconColor;

    switch (transaction.category) {
      case '餐饮':
        iconData = Icons.restaurant;
        iconColor = Colors.orange;
        break;
      case '交通':
        iconData = Icons.directions_car;
        iconColor = Colors.blue;
        break;
      case '购物':
        iconData = Icons.shopping_bag;
        iconColor = Colors.pink;
        break;
      case '娱乐':
        iconData = Icons.movie;
        iconColor = Colors.purple;
        break;
      case '居住':
        iconData = Icons.home;
        iconColor = Colors.brown;
        break;
      case '医疗':
        iconData = Icons.local_hospital;
        iconColor = Colors.red;
        break;
      case '教育':
        iconData = Icons.school;
        iconColor = Colors.indigo;
        break;
      case '工资':
        iconData = Icons.work;
        iconColor = Colors.green;
        break;
      case '投资':
        iconData = Icons.trending_up;
        iconColor = Colors.teal;
        break;
      default:
        iconData = Icons.attach_money;
        iconColor = transaction.type == TransactionType.expense
            ? Colors.red
            : Colors.green;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(iconData, color: iconColor),
    );
  }
}

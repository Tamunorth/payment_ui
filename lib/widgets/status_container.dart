import 'package:flutter/material.dart';
import 'package:payment_ui/pages/details_page.dart';

class StatusContainer extends StatelessWidget {
  const StatusContainer({
    super.key,
    required this.status,
  });

  final InvoiceStatus status;

  Color _getTextColor() {
    switch (status) {
      case InvoiceStatus.draft:
        return Colors.grey;
      case InvoiceStatus.done:
        return Colors.green;
      case InvoiceStatus.rejected:
        return Colors.red;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getTextColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.name,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: _getTextColor(),
            ),
      ),
    );
  }
}

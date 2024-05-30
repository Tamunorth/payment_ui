import 'package:flutter/material.dart';
import 'package:payment_ui/pages/details_page.dart';

///SLOW NAVIGATION TRANSITION
class SlowTransitionPageRoute<T> extends MaterialPageRoute<T> {
  SlowTransitionPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 1000);
  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);
}

///INVOICE LIST
ValueNotifier<List<InvoiceData>> invoices = ValueNotifier(
  [
    InvoiceData(
      id: 'INV001',
      image: '',
      // 'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=200',
      status: InvoiceStatus.draft,
      receiverName: 'No selected Receiver',
      receiverEmail: 'alice.johnson@example.com',
      subtotal: 100.50,
      tax: 8.50,
    ),
    InvoiceData(
      id: 'INV002',
      image:
          'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=200',
      status: InvoiceStatus.done,
      receiverName: 'Bob Smith',
      receiverEmail: 'bob.smith@example.com',
      subtotal: 200.75,
      tax: 16.00,
    ),
    InvoiceData(
      id: 'INV003',
      image:
          'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=200',
      status: InvoiceStatus.pending,
      receiverName: 'Charlie Brown',
      receiverEmail: 'charlie.brown@example.com',
      subtotal: 150.00,
      tax: 12.00,
    ),
    InvoiceData(
      id: 'INV004',
      image:
          'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=200',
      status: InvoiceStatus.done,
      receiverName: 'Diana Prince',
      receiverEmail: 'diana.prince@example.com',
      subtotal: 250.00,
      tax: 20.00,
    ),
    InvoiceData(
      id: 'INV005',
      image:
          'https://images.pexels.com/photos/1680010/pexels-photo-1680010.jpeg?auto=compress&cs=tinysrgb&w=200',
      status: InvoiceStatus.done,
      receiverName: 'Dan Fresh',
      receiverEmail: 'dan.dresh@example.com',
      subtotal: 1000.00,
      tax: 20.00,
    ),
  ],
);

class Receiver {
  final String name;
  final String email;

  Receiver({required this.name, required this.email});
}

import 'package:payment_ui/details_page.dart';

List<InvoiceData> invoices = [
  InvoiceData(
    id: 'INV001',
    image:
        'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=200',
    status: InvoiceStatus.draft,
    receiverName: 'Alice Johnson',
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
    status: InvoiceStatus.rejected,
    receiverName: 'Diana Prince',
    receiverEmail: 'diana.prince@example.com',
    subtotal: 250.00,
    tax: 20.00,
  ),
];

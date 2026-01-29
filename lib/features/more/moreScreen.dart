import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vtu_topup/apps/core/constant/app_color.dart';

enum TransactionType {
  walletFunding,
  airtimePurchase,
  dataPurchase,
  cablePayment,
  electricityPayment,
  cashbackEarned,
  referralBonus,
  withdrawal,
  refund,
}

enum TransactionStatus {
  completed,
  pending,
  failed,
  processing,
}

class TransactionItem {
  final String id;
  final TransactionType type;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionStatus status;
  final String? recipientNumber;
  final String? reference;
  final bool isCredit; // true for money in, false for money out

  const TransactionItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
    this.recipientNumber,
    this.reference,
    required this.isCredit,
  });
}

class ViewmoreScreen extends StatefulWidget {
  const ViewmoreScreen({super.key});

  @override
  State<ViewmoreScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<ViewmoreScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  TransactionType? _selectedFilter;
  
  // Mock data - replace with API call
  static final List<TransactionItem> transactions = [
    TransactionItem(
      id: "TXN001",
      type: TransactionType.walletFunding,
      title: "Wallet Funded",
      description: "Bank transfer deposit",
      amount: 5000.0,
      date: DateTime(2025, 8, 13, 14, 30),
      status: TransactionStatus.completed,
      reference: "BNK/2025/001234",
      isCredit: true,
    ),
    TransactionItem(
      id: "TXN002",
      type: TransactionType.airtimePurchase,
      title: "Airtime Purchase",
      description: "MTN Airtime",
      amount: 500.0,
      date: DateTime(2025, 8, 13, 12, 15),
      status: TransactionStatus.completed,
      recipientNumber: "0803****567",
      reference: "AIR/2025/001235",
      isCredit: false,
    ),
    TransactionItem(
      id: "TXN003",
      type: TransactionType.cashbackEarned,
      title: "Cashback Earned",
      description: "2% cashback on data purchase",
      amount: 20.0,
      date: DateTime(2025, 8, 13, 11, 45),
      status: TransactionStatus.completed,
      reference: "CSH/2025/001236",
      isCredit: true,
    ),
    TransactionItem(
      id: "TXN004",
      type: TransactionType.dataPurchase,
      title: "Data Purchase",
      description: "MTN 1GB Data",
      amount: 1000.0,
      date: DateTime(2025, 8, 13, 11, 30),
      status: TransactionStatus.completed,
      recipientNumber: "0803****567",
      reference: "DAT/2025/001237",
      isCredit: false,
    ),
    TransactionItem(
      id: "TXN005",
      type: TransactionType.electricityPayment,
      title: "Electricity Token",
      description: "AEDC Electricity Token",
      amount: 2500.0,
      date: DateTime(2025, 8, 12, 16, 20),
      status: TransactionStatus.completed,
      recipientNumber: "12345678901",
      reference: "ELE/2025/001238",
      isCredit: false,
    ),
    TransactionItem(
      id: "TXN006",
      type: TransactionType.referralBonus,
      title: "Referral Bonus",
      description: "Bonus for referring John Doe",
      amount: 100.0,
      date: DateTime(2025, 8, 12, 9, 15),
      status: TransactionStatus.completed,
      reference: "REF/2025/001239",
      isCredit: true,
    ),
    TransactionItem(
      id: "TXN007",
      type: TransactionType.cablePayment,
      title: "Cable TV Subscription",
      description: "DStv Compact Plus",
      amount: 15700.0,
      date: DateTime(2025, 8, 11, 14, 45),
      status: TransactionStatus.failed,
      recipientNumber: "0012345678",
      reference: "CAB/2025/001240",
      isCredit: false,
    ),
    TransactionItem(
      id: "TXN008",
      type: TransactionType.walletFunding,
      title: "Wallet Funded",
      description: "Card payment",
      amount: 10000.0,
      date: DateTime(2025, 8, 10, 10, 30),
      status: TransactionStatus.completed,
      reference: "CRD/2025/001241",
      isCredit: true,
    ),
    TransactionItem(
      id: "TXN009",
      type: TransactionType.withdrawal,
      title: "Wallet Withdrawal",
      description: "Bank transfer withdrawal",
      amount: 3000.0,
      date: DateTime(2025, 8, 9, 13, 20),
      status: TransactionStatus.processing,
      reference: "WTH/2025/001242",
      isCredit: false,
    ),
    TransactionItem(
      id: "TXN010",
      type: TransactionType.refund,
      title: "Transaction Refund",
      description: "Failed electricity payment refund",
      amount: 2500.0,
      date: DateTime(2025, 8, 8, 15, 10),
      status: TransactionStatus.completed,
      reference: "RFD/2025/001243",
      isCredit: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TransactionItem> get filteredTransactions {
    if (_selectedFilter == null) return transactions;
    return transactions.where((t) => t.type == _selectedFilter).toList();
  }

  List<TransactionItem> get creditTransactions {
    return transactions.where((t) => t.isCredit).toList();
  }

  List<TransactionItem> get debitTransactions {
    return transactions.where((t) => !t.isCredit).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Transaction History",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: _showFilterBottomSheet,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColor.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: AppColor.primary,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Credit"),
            Tab(text: "Debit"),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Summary Cards
            _buildSummaryCards(),
            const SizedBox(height: 16),
            // Transaction List
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionList(filteredTransactions),
                  _buildTransactionList(creditTransactions),
                  _buildTransactionList(debitTransactions),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalCredit = transactions.where((t) => t.isCredit && t.status == TransactionStatus.completed)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalDebit = transactions.where((t) => !t.isCredit && t.status == TransactionStatus.completed)
        .fold(0.0, (sum, t) => sum + t.amount);

    return Container(
      height: 107,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              "Total Credit",
              "₦${totalCredit.toStringAsFixed(2)}",
              Colors.green,
              Icons.arrow_downward,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              "Total Debit",
              "₦${totalDebit.toStringAsFixed(2)}",
              Colors.red,
              Icons.arrow_upward,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionItem> transactionList) {
    if (transactionList.isEmpty) {
      return _EmptyTransactionState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: transactionList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _TransactionTile(
          transaction: transactionList[index],
          onTap: () => _showTransactionDetails(transactionList[index]),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterBottomSheet(
        selectedFilter: _selectedFilter,
        onFilterChanged: (filter) {
          setState(() {
            _selectedFilter = filter;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showTransactionDetails(TransactionItem transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _TransactionDetailsModal(transaction: transaction),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionItem transaction;
  final VoidCallback onTap;

  const _TransactionTile({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.grey[50]!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: cardColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(transaction.type).withOpacity(0.2),
          child: Icon(
            _getTypeIcon(transaction.type),
            color: _getTypeColor(transaction.type),
            size: 20,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                transaction.title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Text(
              "${transaction.isCredit ? '+' : '-'}₦${transaction.amount.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: transaction.isCredit ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              transaction.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(transaction.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(transaction.status),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(transaction.status),
                    ),
                  ),
                ),
                Text(
                  _formatDate(transaction.date),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.walletFunding:
        return Colors.blue;
      case TransactionType.airtimePurchase:
        return Colors.purple;
      case TransactionType.dataPurchase:
        return Colors.green;
      case TransactionType.cablePayment:
        return Colors.red;
      case TransactionType.electricityPayment:
        return Colors.orange;
      case TransactionType.cashbackEarned:
        return Colors.teal;
      case TransactionType.referralBonus:
        return Colors.indigo;
      case TransactionType.withdrawal:
        return Colors.brown;
      case TransactionType.refund:
        return Colors.cyan;
    }
  }

  IconData _getTypeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.walletFunding:
        return Icons.account_balance_wallet;
      case TransactionType.airtimePurchase:
        return Icons.phone_android;
      case TransactionType.dataPurchase:
        return Icons.wifi;
      case TransactionType.cablePayment:
        return Icons.tv;
      case TransactionType.electricityPayment:
        return Icons.lightbulb;
      case TransactionType.cashbackEarned:
        return Icons.card_giftcard;
      case TransactionType.referralBonus:
        return Icons.people;
      case TransactionType.withdrawal:
        return Icons.money;
      case TransactionType.refund:
        return Icons.refresh;
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.processing:
        return Colors.blue;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return "Completed";
      case TransactionStatus.pending:
        return "Pending";
      case TransactionStatus.failed:
        return "Failed";
      case TransactionStatus.processing:
        return "Processing";
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}

class _FilterBottomSheet extends StatelessWidget {
  final TransactionType? selectedFilter;
  final Function(TransactionType?) onFilterChanged;

  const _FilterBottomSheet({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.6, // Max height to prevent overflow
    ),
    padding: const EdgeInsets.all(20),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filter by Transaction Type",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _FilterOption(
            title: "All Transactions",
            isSelected: selectedFilter == null,
            onTap: () => onFilterChanged(null),
          ),
          ...TransactionType.values.map(
            (type) => _FilterOption(
              title: _getTypeDisplayName(type),
              isSelected: selectedFilter == type,
              onTap: () => onFilterChanged(type),
            ),
          ),
        ],
      ),
    ),
  );
}
  }

  String _getTypeDisplayName(TransactionType type) {
    switch (type) {
      case TransactionType.walletFunding:
        return "Wallet Funding";
      case TransactionType.airtimePurchase:
        return "Airtime Purchase";
      case TransactionType.dataPurchase:
        return "Data Purchase";
      case TransactionType.cablePayment:
        return "Cable Payment";
      case TransactionType.electricityPayment:
        return "Electricity Payment";
      case TransactionType.cashbackEarned:
        return "Cashback Earned";
      case TransactionType.referralBonus:
        return "Referral Bonus";
      case TransactionType.withdrawal:
        return "Withdrawal";
      case TransactionType.refund:
        return "Refund";
    }
  }


class _FilterOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: AppColor.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _TransactionDetailsModal extends StatelessWidget {
  final TransactionItem transaction;

  const _TransactionDetailsModal({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transaction Details",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _DetailRow("Transaction ID", transaction.id),
          _DetailRow("Type", transaction.title),
          _DetailRow("Description", transaction.description),
          _DetailRow("Amount", "${transaction.isCredit ? '+' : '-'}₦${transaction.amount.toStringAsFixed(2)}"),
          _DetailRow("Status", _getStatusText(transaction.status)),
          _DetailRow("Date", _formatFullDate(transaction.date)),
          if (transaction.recipientNumber != null)
            _DetailRow("Recipient", transaction.recipientNumber!),
          if (transaction.reference != null)
            _DetailRow("Reference", transaction.reference!),
          const SizedBox(height: 20),
          if (transaction.status == TransactionStatus.failed)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Transaction retry initiated")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Retry Transaction",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _DetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return "Completed";
      case TransactionStatus.pending:
        return "Pending";
      case TransactionStatus.failed:
        return "Failed";
      case TransactionStatus.processing:
        return "Processing";
    }
  }

  String _formatFullDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}

class _EmptyTransactionState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.receipt_long,
          size: 64,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        const SizedBox(height: 16),
        Text(
          "No transactions found",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your transaction history will appear here",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
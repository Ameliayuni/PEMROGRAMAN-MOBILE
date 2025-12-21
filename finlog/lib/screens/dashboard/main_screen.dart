// lib/screens/dashboard/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/transaction_model.dart';
import '../transactions/add_edit_transaction_screen.dart';
import '../rekap/summary_screen.dart';
import '../settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: _screens[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditTransactionScreen(),
                  ),
                );
              },
              backgroundColor: Colors.blue[600],
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[600],
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  DateTime _selectedDate = DateTime.now();

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  String _formatDate(DateTime date) {
    final days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final dayTransactions = transactionProvider.getTransactionsForDate(_selectedDate);
        final income = transactionProvider.getTotalIncome(dayTransactions);
        final expense = transactionProvider.getTotalExpense(dayTransactions);
        final balance = income - expense;

        return Column(
          children: [
            // Date Header dengan Rekap di kanan - DIUBAH WARNA BIRU
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                // WARNA BIRU - DIUBAH
                color: const Color.fromARGB(255, 135, 187, 233), // Warna biru utama
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 152, 187, 228)!.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tanggal dengan navigasi kiri-kanan
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _changeDate(-1),
                          icon: Icon(Icons.chevron_left, 
                            color: Colors.white.withOpacity(0.9), // Putih untuk kontras
                            size: 28), // Sedikit lebih besar
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatDate(_selectedDate),
                              style: const TextStyle(
                                fontSize: 20, // Sedikit lebih besar
                                fontWeight: FontWeight.w700,
                                color: Colors.white, // Putih untuk kontras
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _selectedDate.day == DateTime.now().day ? 'Hari ini' : '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () => _changeDate(1),
                          icon: Icon(Icons.chevron_right, 
                            color: Colors.white.withOpacity(0.9), // Putih untuk kontras
                            size: 28), // Sedikit lebih besar
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  
                  // Tombol Rekap di kanan atas
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SummaryScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bar_chart, 
                        size: 26, 
                        color: Colors.white),
                      tooltip: 'Rekap',
                    ),
                  ),
                ],
              ),
            ),

            // Summary Table
            Padding(
              padding: const EdgeInsets.all(20),
              child: Table(
                border: TableBorder.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                  borderRadius: BorderRadius.circular(8),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 156, 201, 240), // DIUBAH ke biru yang sama
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    children: [
                      _buildTableHeader('Pemasukan'),
                      _buildTableHeader('Pengeluaran'),
                      _buildTableHeader('Selisih'),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                    ),
                    children: [
                      _buildTableCell(income, Colors.green),
                      _buildTableCell(expense, Colors.red),
                      _buildTableCell(balance, balance >= 0 ? const Color.fromARGB(255, 156, 201, 240) : Colors.red),
                    ],
                  ),
                ],
              ),
            ),

            // Empty State or Transaction List
            Expanded(
              child: dayTransactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada data',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Tambahkan transaksi pertama Anda untuk mulai melacak keuangan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode ? Colors.grey[500] : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: dayTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = dayTransactions[index];
                        return _buildTransactionItem(
                          transaction, 
                          transactionProvider,
                          index,
                          isDarkMode
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white, // Putih untuk kontras dengan latar biru
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(double amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          _formatCurrency(amount),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount == 0) {
      return 'Rp 0';
    }
    
    return 'Rp ${amount.abs().toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  Widget _buildTransactionItem(
    Transaction transaction, 
    TransactionProvider provider,
    int index,
    bool isDarkMode
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      // WARNA BIRU UNTUK LATAR BELAKANG TRANSAKSI - DIUBAH
      color: Colors.blue[50], // Warna biru muda untuk background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue[300]!, // Border biru
          width: 1.5, // Border lebih tebal
        ),
      ),
      child: InkWell(
        onTap: () {
          _showTransactionOptions(transaction, provider, isDarkMode);
        },
        onLongPress: () {
          _showTransactionOptions(transaction, provider, isDarkMode);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon dengan warna sesuai jenis transaksi
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: transaction.type == TransactionType.income 
                      ? Colors.green.withOpacity(0.15)
                      : Colors.red.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: transaction.type == TransactionType.income 
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  transaction.type == TransactionType.income 
                      ? Icons.arrow_downward 
                      : Icons.arrow_upward,
                  color: transaction.type == TransactionType.income 
                      ? Colors.green[700] 
                      : Colors.red[700],
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              
              // Konten transaksi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 164, 194, 238), // Warna biru tua untuk teks
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            transaction.category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _formatTime(transaction.date),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (transaction.notes != null && transaction.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 160, 203, 238).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            transaction.notes!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[800],
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Jumlah dan tombol aksi
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: transaction.type == TransactionType.income 
                          ? Colors.green[50]
                          : Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: transaction.type == TransactionType.income 
                            ? Colors.green[200]!
                            : Colors.red[200]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${transaction.type == TransactionType.income ? '+' : '-'}${_formatCurrency(transaction.amount)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: transaction.type == TransactionType.income 
                            ? Colors.green[800] 
                            : Colors.red[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tombol aksi kecil
                  Row(
                    children: [
                      // Tombol Edit
                      InkWell(
                        onTap: () {
                          _editTransaction(transaction);
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.blue[300]!,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Tombol Hapus
                      InkWell(
                        onTap: () {
                          _deleteTransaction(transaction, provider);
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.red[300]!,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.delete,
                            size: 16,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showTransactionOptions(Transaction transaction, TransactionProvider provider, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50], // DIUBAH jadi biru muda
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.blue[300]!,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[800]!.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        transaction.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${transaction.category} • ${_formatTime(transaction.date)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: transaction.type == TransactionType.income 
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: transaction.type == TransactionType.income 
                                ? Colors.green[300]!
                                : Colors.red[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          '${transaction.type == TransactionType.income ? '+' : '-'}${_formatCurrency(transaction.amount)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: transaction.type == TransactionType.income 
                                ? Colors.green[800] 
                                : Colors.red[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Divider(color: Colors.blue[200], height: 1, thickness: 1),
                
                // Tombol Edit
                ListTile(
                  leading: Icon(Icons.edit, color: Colors.blue[700]),
                  title: Text('Edit Transaksi', 
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    )),
                  onTap: () {
                    Navigator.pop(context);
                    _editTransaction(transaction);
                  },
                ),
                
                // Tombol Hapus
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red[700]),
                  title: Text('Hapus Transaksi', 
                    style: TextStyle(
                      color: Colors.red[900],
                      fontWeight: FontWeight.w500,
                    )),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteTransaction(transaction, provider);
                  },
                ),
                
                Divider(color: Colors.blue[200], height: 1, thickness: 1),
                
                // Tombol Batal
                ListTile(
                  leading: Icon(Icons.close, color: Colors.grey[600]),
                  title: Text('Batal', 
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    )),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editTransaction(Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTransactionScreen(
          transactionToEdit: transaction,
        ),
      ),
    );
  }

  Future<void> _deleteTransaction(Transaction transaction, TransactionProvider provider) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.blue[300]!, width: 1.5),
        ),
        title: Text(
          'Hapus Transaksi',
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Yakin ingin menghapus transaksi "${transaction.title}"?',
            style: TextStyle(
              color: Colors.blue[800],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      provider.deleteTransaction(transaction.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaksi "${transaction.title}" berhasil dihapus'),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: 'Batal',
            textColor: Colors.white,
            onPressed: () {
              provider.addTransaction(transaction);
            },
          ),
        ),
      );
    }
  }
}
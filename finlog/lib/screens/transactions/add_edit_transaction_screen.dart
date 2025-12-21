// lib/screens/transactions/add_edit_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final Transaction? transactionToEdit;
  final TransactionType? initialType;
  
  const AddEditTransactionScreen({
    super.key, 
    this.transactionToEdit,
    this.initialType,
  });
  
  @override
  State<AddEditTransactionScreen> createState() => _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();
  
  TransactionType? _selectedType; // Nullable untuk menunggu user memilih
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  
  final List<String> _paymentMethods = ['Uang Tunai', 'Kartu Kredit', 'Transfer Bank', 'E-Wallet'];
  String? _selectedPaymentMethod;
  
  
  @override
  void initState() {
    super.initState();
    // Format date like "Kam, 18 Des 2025"
    _dateController.text = _formatDate(_selectedDate);
    
    // Set default payment method
    _selectedPaymentMethod = _paymentMethods.first;
    
    // Set initial type if provided
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    } else if (widget.transactionToEdit != null) {
      // If editing, use transaction's type
      _selectedType = widget.transactionToEdit!.type;
    }
    
    // If editing existing transaction
    if (widget.transactionToEdit != null) {
      _loadTransactionData();
    }
  }
  
  String _formatDate(DateTime date) {
    final days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    
    final dayName = days[date.weekday % 7];
    final monthName = months[date.month - 1];
    
    return '$dayName, ${date.day} $monthName ${date.year}';
  }
  
  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
  
  void _loadTransactionData() {
    final transaction = widget.transactionToEdit!;
    _selectedType = transaction.type;
    _amountController.text = transaction.amount.toStringAsFixed(0);
    _titleController.text = transaction.title;
    _selectedDate = transaction.date;
    _selectedCategory = transaction.category;
    _dateController.text = _formatDate(transaction.date);
    
    // Load payment method if exists
    if (transaction.paymentMethod != null && _paymentMethods.contains(transaction.paymentMethod)) {
      _selectedPaymentMethod = transaction.paymentMethod;
    }
    
    // If transaction has notes, load it
    if (transaction.notes != null && transaction.notes!.isNotEmpty) {
      _descriptionController.text = transaction.notes!;
    }

    // Set category input
    _categoryController.text = transaction.category;
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
        _dateController.text = _formatDate(_selectedDate);
      });
    }
  }
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        final newDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
        _selectedDate = newDate;
      });
    }
  }
  
  void _saveTransaction() {
    // Validasi tipe transaksi harus dipilih
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jenis transaksi terlebih dahulu')),
      );
      return;
    }
    
    if (_formKey.currentState!.validate() && 
        _selectedCategory != null && 
        _selectedPaymentMethod != null) {
      
      // Parse amount (remove any dots/commas)
      final cleanAmount = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final amount = double.tryParse(cleanAmount) ?? 0.0;
      
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jumlah harus lebih dari 0')),
        );
        return;
      }
      
      // Create transaction object
      final transaction = Transaction(
        id: widget.transactionToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.isNotEmpty ? _titleController.text : _selectedCategory!,
        amount: amount,
        type: _selectedType!,
        date: _selectedDate,
        createdAt: widget.transactionToEdit?.createdAt ?? DateTime.now(),
        category: _selectedCategory!,
        paymentMethod: _selectedPaymentMethod!,
        notes: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      );
      
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      
      if (widget.transactionToEdit != null) {
        transactionProvider.updateTransaction(transaction);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi berhasil diperbarui')),
        );
      } else {
        transactionProvider.addTransaction(transaction);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi berhasil ditambahkan')),
        );
      }
      
      Navigator.pop(context);
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kategori terlebih dahulu')),
      );
    } else if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu')),
      );
    }
  }
  
  Widget _buildTypeSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jenis Transaksi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTypeButton(
                  type: TransactionType.income,
                  label: 'PEMASUKAN',
                  icon: Icons.arrow_downward,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTypeButton(
                  type: TransactionType.expense,
                  label: 'PENGELUARAN',
                  icon: Icons.arrow_upward,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTypeButton({
    required TransactionType type,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          // Auto-focus ke field amount setelah memilih tipe
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(_amountFocusNode);
          });
        });
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMainContent() {
    if (_selectedType == null) {
      return Column(
        children: [
          _buildTypeSelection(),
          Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.arrow_downward,
                  color: Colors.grey[400],
                  size: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  'Pilih jenis transaksi terlebih dahulu',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    return Column(
      children: [
        // Type indicator (show selected type at top)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          color: _selectedType == TransactionType.income 
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _selectedType == TransactionType.income 
                    ? Icons.arrow_downward 
                    : Icons.arrow_upward,
                color: _selectedType == TransactionType.income 
                    ? Colors.green 
                    : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _selectedType == TransactionType.income 
                    ? 'PEMASUKAN' 
                    : 'PENGELUARAN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _selectedType == TransactionType.income 
                      ? Colors.green 
                      : Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedType = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Date and Time Section
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(_selectedDate),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => _selectTime(context),
                      child: Row(
                        children: [
                          Text(
                            _formatTime(_selectedDate),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
        
        // Payment Method Section
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _paymentMethods.map((method) {
                  final isSelected = _selectedPaymentMethod == method;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = method;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        method,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        
        const Divider(height: 1, thickness: 1),
        
        // Amount Section
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jumlah',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                focusNode: _amountFocusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsSeparatorInputFormatter(),
                ],
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                  hintText: '0',
                  hintStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah';
                  }
                  
                  final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                  final amount = double.tryParse(cleanValue) ?? 0.0;
                  if (amount <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }
                  
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan jumlah transaksi',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        
        const Divider(height: 1, thickness: 1),
        
        // Title Section
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Judul',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ketik disini untuk judul baru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        
        const Divider(height: 1, thickness: 1),
        
        // Category Section
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _categoryController,
                focusNode: _categoryFocusNode,
                decoration: InputDecoration(
                  hintText: 'Masukkan kategori transaksi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  suffixIcon: _categoryController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            if (_categoryController.text.isNotEmpty) {
                              setState(() {
                                _selectedCategory = _categoryController.text.trim();
                              });
                              FocusScope.of(context).unfocus();
                            }
                          },
                        )
                      : null,
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      _selectedCategory = value.trim();
                    } else {
                      _selectedCategory = null;
                    }
                  });
                },
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _selectedCategory = value.trim();
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Masukkan kategori';
                  }
                  return null;
                },
              ),
              
              if (_selectedCategory != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Kategori: $_selectedCategory',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
        const Divider(height: 1, thickness: 1),
        
        // Description Section
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keterangan (opsional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tambahkan catatan atau deskripsi...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        
        // Save Button - HANYA TOMBOL BESAR DI BAWAH
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedType == TransactionType.income 
                    ? Colors.green 
                    : Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.transactionToEdit != null ? 'UPDATE TRANSAKSI' : 'SIMPAN TRANSAKSI',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 32),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transactionToEdit != null ? 'Edit Transaksi' : 'Tambah Transaksi',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        // DIHAPUS: Tombol SIMPAN di actions (atas kanan)
        // actions: [
        //   if (_selectedType != null)
        //     Padding(
        //       padding: const EdgeInsets.only(right: 16),
        //       child: TextButton(
        //         onPressed: _saveTransaction,
        //         style: TextButton.styleFrom(
        //           foregroundColor: Colors.blue,
        //         ),
        //         child: const Text(
        //           'SIMPAN',
        //           style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             fontSize: 16,
        //           ),
        //         ),
        //       ),
        //     ),
        // ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: _buildMainContent(),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _titleController.dispose(); // DIKOREKSI: hapus line _titleController.text = _selectedCategory ?? ''
    _categoryController.dispose();
    _amountFocusNode.dispose();
    _categoryFocusNode.dispose();
    super.dispose();
  }
}

// Custom input formatter untuk format ribuan (sama seperti sebelumnya)
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.';
  
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    
    // Remove all non-digits
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Don't format if empty
    if (newText.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    
    // Parse as integer
    final number = int.tryParse(newText) ?? 0;
    
    // Format with thousand separators
    final formatted = _formatNumber(number);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
  
  String _formatNumber(int number) {
    final numberStr = number.toString();
    final length = numberStr.length;
    final result = StringBuffer();
    
    for (int i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        result.write(separator);
      }
      result.write(numberStr[i]);
    }
    
    return result.toString();
  }
}
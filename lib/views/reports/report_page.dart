import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/expense_provider.dart';
import '../../providers/setting_provider.dart';
import '../../models/expense_model.dart';
import '../../core/utils/report_utils.dart';
import '../../core/constants/colors.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _customStart;
  DateTime? _customEnd;
  final DateFormat _displayDateFormat = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customStart ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _customStart = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customEnd ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _customEnd = picked);
    }
  }

  Widget _buildReportList(
    Map<String, double> aggregatedData,
    String currencySymbol,
    List<ExpenseModel> expenses,
  ) {
    final total = ReportUtils.calculateTotal(aggregatedData);
    final categoryBreakdown = ReportUtils.aggregateByCategory(expenses);

    return Column(
      children: [
        // Total Card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [primaryColor, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withAlpha((0.3*255).round()),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Total Expenses',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$currencySymbol${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${expenses.length} transaction${expenses.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Category Breakdown
        if (categoryBreakdown.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.category, size: 20, color: primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Category Breakdown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryBreakdown.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final category = categoryBreakdown.keys.elementAt(index);
                final amount = categoryBreakdown.values.elementAt(index);
                final percentage = (amount / total * 100).toStringAsFixed(1);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryColor.withAlpha((0.1*255).round()),
                    child: Text(
                      category[0].toUpperCase(),
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(category),
                  subtitle: Text('$percentage% of total'),
                  trailing: Text(
                    '$currencySymbol${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Time Period Breakdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 20, color: primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Time Period Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // List of aggregated data
        Expanded(
          child: aggregatedData.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No expenses found',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: aggregatedData.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final period = aggregatedData.keys.elementAt(index);
                    final amount = aggregatedData.values.elementAt(index);

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withAlpha((0.1*255).round()),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.receipt,
                            color: primaryColor,
                          ),
                        ),
                        title: Text(
                          period,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: Text(
                          '$currencySymbol${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDailyReport(
    List<ExpenseModel> allExpenses,
    String currencySymbol,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final filtered = ReportUtils.filterByRange(allExpenses, today, today);
    final aggregated = ReportUtils.aggregateByDay(filtered);

    return _buildReportList(aggregated, currencySymbol, filtered);
  }

  Widget _buildWeeklyReport(
    List<ExpenseModel> allExpenses,
    String currencySymbol,
  ) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = DateTime(weekEnd.year, weekEnd.month, weekEnd.day);
    final filtered = ReportUtils.filterByRange(allExpenses, start, end);
    final aggregated = ReportUtils.aggregateByWeek(filtered);

    return _buildReportList(aggregated, currencySymbol, filtered);
  }

  Widget _buildMonthlyReport(
    List<ExpenseModel> allExpenses,
    String currencySymbol,
  ) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final filtered = ReportUtils.filterByRange(allExpenses, monthStart, monthEnd);
    final aggregated = ReportUtils.aggregateByMonth(filtered);

    return _buildReportList(aggregated, currencySymbol, filtered);
  }

  Widget _buildCustomReport(
    List<ExpenseModel> allExpenses,
    String currencySymbol,
  ) {
    if (_customStart == null || _customEnd == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.date_range, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Select start and end dates',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickStartDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_customStart == null
                      ? 'Start Date'
                      : _displayDateFormat.format(_customStart!)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _pickEndDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_customEnd == null
                      ? 'End Date'
                      : _displayDateFormat.format(_customEnd!)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Validate date range
    if (_customStart!.isAfter(_customEnd!)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Start date must be before end date',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickStartDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_displayDateFormat.format(_customStart!)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _pickEndDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_displayDateFormat.format(_customEnd!)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final filtered = ReportUtils.filterByRange(allExpenses, _customStart!, _customEnd!);
    final aggregated = ReportUtils.aggregateByDay(filtered);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryColor.withAlpha((0.1*255).round()),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Custom Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_displayDateFormat.format(_customStart!)} - ${_displayDateFormat.format(_customEnd!)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: primaryColor),
                    onPressed: _pickStartDate,
                    tooltip: 'Change start date',
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: primaryColor),
                    onPressed: _pickEndDate,
                    tooltip: 'Change end date',
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(child: _buildReportList(aggregated, currencySymbol, filtered)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final settingProvider = Provider.of<SettingProvider>(context);
    final allExpenses = List<ExpenseModel>.from(expenseProvider.expenses);
    final currencySymbol = settingProvider.currencySymbol;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Reports'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.today), text: 'Daily'),
            Tab(icon: Icon(Icons.view_week), text: 'Weekly'),
            Tab(icon: Icon(Icons.calendar_month), text: 'Monthly'),
            Tab(icon: Icon(Icons.date_range), text: 'Custom'),
          ],
        ),
      ),
      body: expenseProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDailyReport(allExpenses, currencySymbol),
                _buildWeeklyReport(allExpenses, currencySymbol),
                _buildMonthlyReport(allExpenses, currencySymbol),
                _buildCustomReport(allExpenses, currencySymbol),
              ],
            ),
    );
  }
}


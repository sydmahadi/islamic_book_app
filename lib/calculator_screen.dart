import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ক্যালকুলেটর'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        children: [
          _CalculatorChoiceCard(
            icon: Icons.calculate_rounded,
            title: 'Normal Calculator',
            subtitle: 'সাধারণ যোগ, বিয়োগ, গুণ ও ভাগ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NormalCalculatorPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          _CalculatorChoiceCard(
            icon: Icons.access_time_rounded,
            title: 'Time Calculator',
            subtitle: '১.২০ = ১ ঘণ্টা ২০ মিনিট',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimeCalculatorPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalculatorChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CalculatorChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [
                  Color(0xFF176B45),
                  Color(0xFF0F5132),
                ]
              : const [
                  Color(0xFF176B45),
                  Color(0xFF0F5132),
                ],
        ),
        border: Border.all(
          color: const Color(0x55C9A45C),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: dark ? 0.20 : 0.08,
            ),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9A45C),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF18352A),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xD9FFFFFF),
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFE3C875),
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// NORMAL CALCULATOR
// ============================================================

class NormalCalculatorPage extends StatefulWidget {
  const NormalCalculatorPage({super.key});

  @override
  State<NormalCalculatorPage> createState() =>
      _NormalCalculatorPageState();
}

class _NormalCalculatorPageState extends State<NormalCalculatorPage> {
  String _expression = '';
  String _result = '0';

  final ScrollController _expressionScrollController =
      ScrollController();

  final List<String> _history = [];

  void _add(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
        return;
      }

      if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression =
              _expression.substring(0, _expression.length - 1);
        }
        _calculatePreview();
        return;
      }

      if (value == '=') {
        _calculateFinal();
        return;
      }

      if (_isOperator(value)) {
        if (_expression.isEmpty) {
          if (value == '-') {
            _expression = '-';
          }
        } else {
          final last = _expression[_expression.length - 1];

          if (_isOperator(last)) {
            _expression =
                _expression.substring(0, _expression.length - 1) +
                    value;
          } else {
            _expression += value;
          }
        }
      } else if (value == '.') {
        final currentNumber = _currentNumber();

        if (!currentNumber.contains('.')) {
          if (_expression.isEmpty ||
              _isOperator(_expression[_expression.length - 1])) {
            _expression += '0.';
          } else {
            _expression += '.';
          }
        }
      } else {
        _expression += value;
      }

      _calculatePreview();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_expressionScrollController.hasClients) {
          _expressionScrollController.jumpTo(
            _expressionScrollController.position.maxScrollExtent,
          );
        }
      });
    });
  }

  String _currentNumber() {
    if (_expression.isEmpty) return '';

    int index = _expression.length - 1;

    while (index >= 0 && !_isOperator(_expression[index])) {
      index--;
    }

    return _expression.substring(index + 1);
  }

  bool _isOperator(String value) {
    return value == '+' ||
        value == '-' ||
        value == '×' ||
        value == '÷';
  }

  List<String> _tokens(String expression) {
    final result = <String>[];
    String number = '';

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];

      if (_isOperator(char)) {
        if (number.isNotEmpty) {
          result.add(number);
          number = '';
        }

        result.add(char);
      } else {
        number += char;
      }
    }

    if (number.isNotEmpty) {
      result.add(number);
    }

    return result;
  }

  double? _evaluate(String expression) {
    if (expression.isEmpty) return null;

    final tokens = _tokens(expression);

    if (tokens.isEmpty) return null;

    if (_isOperator(tokens.last)) {
      tokens.removeLast();
    }

    if (tokens.isEmpty) return null;

    try {
      final numbers = <double>[];
      final operators = <String>[];

      for (final token in tokens) {
        if (_isOperator(token)) {
          operators.add(token);
        } else {
          numbers.add(double.parse(token));
        }
      }

      if (numbers.isEmpty) return null;

      for (int i = 0; i < operators.length;) {
        if (operators[i] == '×' || operators[i] == '÷') {
          final left = numbers[i];
          final right = numbers[i + 1];

          double value;

          if (operators[i] == '×') {
            value = left * right;
          } else {
            if (right == 0) return null;
            value = left / right;
          }

          numbers[i] = value;
          numbers.removeAt(i + 1);
          operators.removeAt(i);
        } else {
          i++;
        }
      }

      double result = numbers[0];

      for (int i = 0; i < operators.length; i++) {
        if (operators[i] == '+') {
          result += numbers[i + 1];
        } else if (operators[i] == '-') {
          result -= numbers[i + 1];
        }
      }

      return result;
    } catch (_) {
      return null;
    }
  }

  String _formatNumber(double value) {
    if (value.isNaN || value.isInfinite) {
      return 'Error';
    }

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    final text = value.toStringAsFixed(10);

    return text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  void _calculatePreview() {
    final value = _evaluate(_expression);

    if (value != null) {
      _result = _formatNumber(value);
    } else {
      _result = '0';
    }
  }

  void _calculateFinal() {
    final value = _evaluate(_expression);

    if (value == null) {
      return;
    }

    final formatted = _formatNumber(value);

    if (_expression.isNotEmpty) {
      _history.insert(
        0,
        '$_expression = $formatted',
      );

      if (_history.length > 30) {
        _history.removeLast();
      }
    }

    setState(() {
      _result = formatted;
    });
  }

  @override
  void dispose() {
    _expressionScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Normal Calculator'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              tooltip: 'History',
              onPressed: _showHistory,
              icon: const Icon(
                Icons.history_rounded,
                color: Color(0xFFC9A45C),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _display(),
            ),
            _keypad(),
          ],
        ),
      ),
    );
  }

  Widget _display() {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: dark
            ? const Color(0xFF10291F)
            : const Color(0xFFFFFCF5),
        border: Border.all(
          color: const Color(0x44C9A45C),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            controller: _expressionScrollController,
            scrollDirection: Axis.horizontal,
            reverse: false,
            child: Text(
              _expression.isEmpty ? '0' : _expression,
              maxLines: 1,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.65),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              _result,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Color(0xFFC9A45C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _keypad() {
    final buttons = [
      ['C', '⌫', '÷', '×'],
      ['7', '8', '9', '-'],
      ['4', '5', '6', '+'],
      ['1', '2', '3', '='],
      ['0', '.', '', ''],
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: buttons.map((row) {
          return Row(
            children: row.map((value) {
              if (value.isEmpty) {
                return const Expanded(
                  child: SizedBox(height: 64),
                );
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: _button(value),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _button(String value) {
    final operator = _isOperator(value);
    final action = value == 'C' ||
        value == '⌫' ||
        value == '=';

    return SizedBox(
      height: 62,
      child: ElevatedButton(
        onPressed: () => _add(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: value == '='
              ? const Color(0xFFC9A45C)
              : operator
                  ? const Color(0xFF176B45)
                  : action
                      ? const Color(0xFF294D3E)
                      : Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF10291F)
                          : const Color(0xFFFFFCF5),
          foregroundColor: value == '='
              ? const Color(0xFF18352A)
              : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
            side: BorderSide(
              color: const Color(0x33C9A45C),
            ),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: value == '⌫' ? 23 : 21,
            fontWeight: FontWeight.w800,
            color: value == '='
                ? const Color(0xFF18352A)
                : (!operator && !action)
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Colors.white,
          ),
        ),
      ),
    );
  }

  void _showHistory() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Calculation History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _history.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.history_rounded,
                          color: Color(0xFFC9A45C),
                        ),
                        title: Text(_history[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// TIME CALCULATOR
// ============================================================

class TimeCalculatorPage extends StatefulWidget {
  const TimeCalculatorPage({super.key});

  @override
  State<TimeCalculatorPage> createState() =>
      _TimeCalculatorPageState();
}

class _TimeCalculatorPageState extends State<TimeCalculatorPage> {
  String _expression = '';
  int _resultMinutes = 0;

  final ScrollController _expressionScrollController =
      ScrollController();

  final List<String> _history = [];

  void _add(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _resultMinutes = 0;
        return;
      }

      if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression =
              _expression.substring(0, _expression.length - 1);
        }
        _calculatePreview();
        return;
      }

      if (value == '=') {
        _calculateFinal();
        return;
      }

      if (_isOperator(value)) {
        if (_expression.isEmpty) {
          if (value == '-') {
            _expression = '-';
          }
        } else {
          final last = _expression[_expression.length - 1];

          if (_isOperator(last)) {
            _expression =
                _expression.substring(0, _expression.length - 1) +
                    value;
          } else {
            _expression += value;
          }
        }
      } else if (value == '.') {
        final currentNumber = _currentNumber();

        if (!currentNumber.contains('.')) {
          if (_expression.isEmpty ||
              _isOperator(_expression[_expression.length - 1])) {
            _expression += '0.';
          } else {
            _expression += '.';
          }
        }
      } else {
        _expression += value;
      }

      _calculatePreview();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_expressionScrollController.hasClients) {
          _expressionScrollController.jumpTo(
            _expressionScrollController.position.maxScrollExtent,
          );
        }
      });
    });
  }

  String _currentNumber() {
    if (_expression.isEmpty) return '';

    int index = _expression.length - 1;

    while (index >= 0 && !_isOperator(_expression[index])) {
      index--;
    }

    return _expression.substring(index + 1);
  }

  bool _isOperator(String value) {
    return value == '+' ||
        value == '-' ||
        value == '×' ||
        value == '÷';
  }

  List<String> _tokens(String expression) {
    final result = <String>[];
    String number = '';

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];

      if (_isOperator(char)) {
        if (number.isNotEmpty) {
          result.add(number);
          number = '';
        }

        result.add(char);
      } else {
        number += char;
      }
    }

    if (number.isNotEmpty) {
      result.add(number);
    }

    return result;
  }

  int? _parseTime(String value) {
    if (value.isEmpty || value == '-') {
      return null;
    }

    final negative = value.startsWith('-');
    final clean = negative ? value.substring(1) : value;

    try {
      if (clean.contains('.')) {
        final parts = clean.split('.');

        final hours = int.parse(
          parts[0].isEmpty ? '0' : parts[0],
        );

        String minuteText = parts.length > 1 ? parts[1] : '0';

        if (minuteText.isEmpty) {
          minuteText = '0';
        }

        if (minuteText.length == 1) {
          minuteText = '${minuteText}0';
        }

        final minutes = int.parse(minuteText);

        if (minutes >= 60) {
          return null;
        }

        final total = hours * 60 + minutes;

        return negative ? -total : total;
      }

      return int.parse(clean) * 60 * (negative ? -1 : 1);
    } catch (_) {
      return null;
    }
  }

  int? _evaluateMinutes(String expression) {
    if (expression.isEmpty) return null;

    final tokens = _tokens(expression);

    if (tokens.isEmpty) return null;

    if (_isOperator(tokens.last)) {
      tokens.removeLast();
    }

    if (tokens.isEmpty) return null;

    try {
      final numbers = <int>[];
      final operators = <String>[];

      for (final token in tokens) {
        if (_isOperator(token)) {
          operators.add(token);
        } else {
          final value = _parseTime(token);

          if (value == null) return null;

          numbers.add(value);
        }
      }

      if (numbers.isEmpty) return null;

      for (int i = 0; i < operators.length;) {
        if (operators[i] == '×' || operators[i] == '÷') {
          final left = numbers[i];
          final right = numbers[i + 1];

          int value;

          if (operators[i] == '×') {
            value = left * right;
          } else {
            if (right == 0) return null;
            value = left ~/ right;
          }

          numbers[i] = value;
          numbers.removeAt(i + 1);
          operators.removeAt(i);
        } else {
          i++;
        }
      }

      int result = numbers[0];

      for (int i = 0; i < operators.length; i++) {
        if (operators[i] == '+') {
          result += numbers[i + 1];
        } else if (operators[i] == '-') {
          result -= numbers[i + 1];
        }
      }

      return result;
    } catch (_) {
      return null;
    }
  }

  void _calculatePreview() {
    final value = _evaluateMinutes(_expression);

    if (value != null) {
      _resultMinutes = value;
    } else {
      _resultMinutes = 0;
    }
  }

  void _calculateFinal() {
    final value = _evaluateMinutes(_expression);

    if (value == null) {
      return;
    }

    if (_expression.isNotEmpty) {
      _history.insert(
        0,
        '$_expression = ${_formatTime(value)}',
      );

      if (_history.length > 30) {
        _history.removeLast();
      }
    }

    setState(() {
      _resultMinutes = value;
    });
  }

  String _formatTime(int totalMinutes) {
    final negative = totalMinutes < 0;
    final absolute = totalMinutes.abs();

    final hours = absolute ~/ 60;
    final minutes = absolute % 60;

    final result =
        '$hours ঘণ্টা $minutes মিনিট';

    return negative ? '-$result' : result;
  }

  String _formatShortTime(int totalMinutes) {
    final negative = totalMinutes < 0;
    final absolute = totalMinutes.abs();

    final hours = absolute ~/ 60;
    final minutes = absolute % 60;

    final result =
        '${hours.toString()}.${minutes.toString().padLeft(2, '0')}';

    return negative ? '-$result' : result;
  }

  @override
  void dispose() {
    _expressionScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Calculator'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              tooltip: 'History',
              onPressed: _showHistory,
              icon: const Icon(
                Icons.history_rounded,
                color: Color(0xFFC9A45C),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _display(),
            ),
            _quickTools(),
            _keypad(),
          ],
        ),
      ),
    );
  }

  Widget _display() {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: dark
            ? const Color(0xFF10291F)
            : const Color(0xFFFFFCF5),
        border: Border.all(
          color: const Color(0x44C9A45C),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            controller: _expressionScrollController,
            scrollDirection: Axis.horizontal,
            child: Text(
              _expression.isEmpty ? '0.00' : _expression,
              maxLines: 1,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.65),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _formatTime(_resultMinutes),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: Color(0xFFC9A45C),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _formatShortTime(_resultMinutes),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickTools() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 5),
      child: Row(
        children: [
          Expanded(
            child: _toolButton(
              icon: Icons.today_rounded,
              title: 'Daily Average',
              onTap: _showDailyAverage,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _toolButton(
              icon: Icons.calendar_month_rounded,
              title: 'Monthly Average',
              onTap: _showMonthlyAverage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 18,
      ),
      label: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        side: const BorderSide(
          color: Color(0x55C9A45C),
        ),
        foregroundColor: const Color(0xFFC9A45C),
      ),
    );
  }

  Widget _keypad() {
    final buttons = [
      ['C', '⌫', '÷', '×'],
      ['7', '8', '9', '-'],
      ['4', '5', '6', '+'],
      ['1', '2', '3', '='],
      ['0', '.', '', ''],
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: buttons.map((row) {
          return Row(
            children: row.map((value) {
              if (value.isEmpty) {
                return const Expanded(
                  child: SizedBox(height: 58),
                );
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: _button(value),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _button(String value) {
    final operator = _isOperator(value);
    final action = value == 'C' ||
        value == '⌫' ||
        value == '=';

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () => _add(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: value == '='
              ? const Color(0xFFC9A45C)
              : operator
                  ? const Color(0xFF176B45)
                  : action
                      ? const Color(0xFF294D3E)
                      : Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF10291F)
                          : const Color(0xFFFFFCF5),
          foregroundColor: value == '='
              ? const Color(0xFF18352A)
              : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
            side: const BorderSide(
              color: Color(0x33C9A45C),
            ),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: value == '⌫' ? 22 : 20,
            fontWeight: FontWeight.w800,
            color: value == '='
                ? const Color(0xFF18352A)
                : (!operator && !action)
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Colors.white,
          ),
        ),
      ),
    );
  }

  void _showDailyAverage() {
    _showAverageDialog(
      title: 'Daily Average',
      hint: 'মোট সময় লিখুন',
      days: 1,
    );
  }

  void _showMonthlyAverage() {
    _showAverageDialog(
      title: 'Monthly Average',
      hint: 'মোট সময় লিখুন',
      days: 30,
    );
  }

  void _showAverageDialog({
    required String title,
    required String hint,
    required int days,
  }) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              hintText: hint,
              helperText: 'উদাহরণ: 10.30',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                final minutes = _parseTime(controller.text.trim());

                if (minutes == null || minutes < 0) {
                  return;
                }

                final average = minutes ~/ days;

                Navigator.pop(dialogContext);

                _showResultDialog(
                  title: title,
                  result: _formatTime(average),
                );
              },
              child: const Text('হিসাব'),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog({
    required String title,
    required String result,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            result,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFFC9A45C),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ঠিক আছে'),
            ),
          ],
        );
      },
    );
  }

  void _showHistory() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Time Calculation History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _history.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.history_rounded,
                          color: Color(0xFFC9A45C),
                        ),
                        title: Text(_history[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

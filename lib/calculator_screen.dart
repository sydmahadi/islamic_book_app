import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool _isTimeCalculator = true;

  // ============================================================
  // TIME CALCULATOR STATE
  // ============================================================

  String _timeExpression = '';
  int _timeResultMinutes = 0;

  final ScrollController _timeExpressionScrollController =
      ScrollController();

  final List<String> _timeHistory = [];

  // ============================================================
  // NORMAL CALCULATOR STATE
  // ============================================================

  String _normalExpression = '';
  String _normalResult = '0';

  final ScrollController _normalExpressionScrollController =
      ScrollController();

  final List<String> _normalHistory = [];

  // ============================================================
  // MAIN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ক্যালকুলেটর'),
        actions: [
          if (_isTimeCalculator && _timeHistory.isNotEmpty)
            IconButton(
              tooltip: 'History',
              onPressed: _showTimeHistory,
              icon: const Icon(
                Icons.history_rounded,
                color: Color(0xFFC9A45C),
              ),
            ),
          if (!_isTimeCalculator && _normalHistory.isNotEmpty)
            IconButton(
              tooltip: 'History',
              onPressed: _showNormalHistory,
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
            const SizedBox(height: 10),

            // ==================================================
            // CALCULATOR TOGGLE
            // ==================================================

            _calculatorToggle(),

            const SizedBox(height: 10),

            // ==================================================
            // CALCULATOR BODY
            // ==================================================

            Expanded(
              child: _isTimeCalculator
                  ? _buildTimeCalculator()
                  : _buildNormalCalculator(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOGGLE
  // ============================================================

  Widget _calculatorToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF10291F)
              : const Color(0xFFFFFCF5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0x55C9A45C),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _toggleItem(
                title: 'Time Calculator',
                icon: Icons.access_time_rounded,
                selected: _isTimeCalculator,
                onTap: () {
                  if (!_isTimeCalculator) {
                    setState(() {
                      _isTimeCalculator = true;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: _toggleItem(
                title: 'Normal Calculator',
                icon: Icons.calculate_rounded,
                selected: !_isTimeCalculator,
                onTap: () {
                  if (_isTimeCalculator) {
                    setState(() {
                      _isTimeCalculator = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF176B45)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? const Color(0xFFC9A45C)
                  : Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.65),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight:
                      selected ? FontWeight.w900 : FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TIME CALCULATOR
  // ============================================================

  Widget _buildTimeCalculator() {
    return Column(
      children: [
        Expanded(
          child: _timeDisplay(),
        ),
        _timeQuickTools(),
        _timeKeypad(),
      ],
    );
  }

  Widget _timeDisplay() {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 8),
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
            controller: _timeExpressionScrollController,
            scrollDirection: Axis.horizontal,
            child: Text(
              _timeExpression.isEmpty
                  ? '0.00'
                  : _timeExpression,
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
            _formatTime(_timeResultMinutes),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: Color(0xFFC9A45C),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _formatShortTime(_timeResultMinutes),
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

  Widget _timeQuickTools() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 5),
      child: Row(
        children: [
          Expanded(
            child: _toolButton(
              icon: Icons.today_rounded,
              title: 'দৈনিক গড়',
              onTap: _showTimeDailyAverage,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _toolButton(
              icon: Icons.calendar_month_rounded,
              title: 'মাসিক গড়',
              onTap: _showTimeMonthlyAverage,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NORMAL CALCULATOR
  // ============================================================

  Widget _buildNormalCalculator() {
    return Column(
      children: [
        Expanded(
          child: _normalDisplay(),
        ),
        _normalQuickTools(),
        _normalKeypad(),
      ],
    );
  }

  Widget _normalDisplay() {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 8),
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
            controller: _normalExpressionScrollController,
            scrollDirection: Axis.horizontal,
            child: Text(
              _normalExpression.isEmpty
                  ? '0'
                  : _normalExpression,
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
              _normalResult,
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

  Widget _normalQuickTools() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 5),
      child: Row(
        children: [
          Expanded(
            child: _toolButton(
              icon: Icons.today_rounded,
              title: 'দৈনিক গড়',
              onTap: _showNormalDailyAverage,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _toolButton(
              icon: Icons.calendar_month_rounded,
              title: 'মাসিক গড়',
              onTap: _showNormalMonthlyAverage,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMON TOOL BUTTON
  // ============================================================

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ============================================================
  // NORMAL CALCULATOR LOGIC
  // ============================================================

  void _addNormal(String value) {
    setState(() {
      if (value == 'C') {
        _normalExpression = '';
        _normalResult = '0';
        return;
      }

      if (value == '⌫') {
        if (_normalExpression.isNotEmpty) {
          _normalExpression = _normalExpression.substring(
            0,
            _normalExpression.length - 1,
          );
        }

        _calculateNormalPreview();
        return;
      }

      if (value == '=') {
        _calculateNormalFinal();
        return;
      }

      if (_isOperator(value)) {
        if (_normalExpression.isEmpty) {
          if (value == '-') {
            _normalExpression = '-';
          }
        } else {
          final last =
              _normalExpression[_normalExpression.length - 1];

          if (_isOperator(last)) {
            _normalExpression =
                _normalExpression.substring(
                      0,
                      _normalExpression.length - 1,
                    ) +
                    value;
          } else {
            _normalExpression += value;
          }
        }
      } else if (value == '.') {
        final currentNumber = _normalCurrentNumber();

        if (!currentNumber.contains('.')) {
          if (_normalExpression.isEmpty ||
              _isOperator(
                _normalExpression[
                    _normalExpression.length - 1],
              )) {
            _normalExpression += '0.';
          } else {
            _normalExpression += '.';
          }
        }
      } else {
        _normalExpression += value;
      }

      _calculateNormalPreview();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_normalExpressionScrollController.hasClients) {
          _normalExpressionScrollController.jumpTo(
            _normalExpressionScrollController
                .position
                .maxScrollExtent,
          );
        }
      });
    });
  }

  String _normalCurrentNumber() {
    if (_normalExpression.isEmpty) return '';

    int index = _normalExpression.length - 1;

    while (
        index >= 0 &&
        !_isOperator(_normalExpression[index])) {
      index--;
    }

    return _normalExpression.substring(index + 1);
  }

  List<String> _normalTokens(String expression) {
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

  double? _evaluateNormal(String expression) {
    if (expression.isEmpty) return null;

    final tokens = _normalTokens(expression);

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
        if (operators[i] == '×' ||
            operators[i] == '÷') {
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

  void _calculateNormalPreview() {
    final value = _evaluateNormal(_normalExpression);

    if (value != null) {
      _normalResult = _formatNumber(value);
    } else {
      _normalResult = '0';
    }
  }

  void _calculateNormalFinal() {
    final value = _evaluateNormal(_normalExpression);

    if (value == null) {
      return;
    }

    final formatted = _formatNumber(value);

    if (_normalExpression.isNotEmpty) {
      _normalHistory.insert(
        0,
        '$_normalExpression = $formatted',
      );

      if (_normalHistory.length > 30) {
        _normalHistory.removeLast();
      }
    }

    setState(() {
      _normalResult = formatted;
    });
  }

  // ============================================================
  // NORMAL KEYPAD
  // ============================================================

  Widget _normalKeypad() {
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
                  child: _normalButton(value),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _normalButton(String value) {
    final operator = _isOperator(value);
    final action =
        value == 'C' || value == '⌫' || value == '=';

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () => _addNormal(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: value == '='
              ? const Color(0xFFC9A45C)
              : operator
                  ? const Color(0xFF176B45)
                  : action
                      ? const Color(0xFF294D3E)
                      : Theme.of(context).brightness ==
                              Brightness.dark
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
                    ? Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                    : Colors.white,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TIME CALCULATOR LOGIC
  // ============================================================

  void _addTime(String value) {
    setState(() {
      if (value == 'C') {
        _timeExpression = '';
        _timeResultMinutes = 0;
        return;
      }

      if (value == '⌫') {
        if (_timeExpression.isNotEmpty) {
          _timeExpression = _timeExpression.substring(
            0,
            _timeExpression.length - 1,
          );
        }

        _calculateTimePreview();
        return;
      }

      if (value == '=') {
        _calculateTimeFinal();
        return;
      }

      if (_isOperator(value)) {
        if (_timeExpression.isEmpty) {
          if (value == '-') {
            _timeExpression = '-';
          }
        } else {
          final last =
              _timeExpression[_timeExpression.length - 1];

          if (_isOperator(last)) {
            _timeExpression =
                _timeExpression.substring(
                      0,
                      _timeExpression.length - 1,
                    ) +
                    value;
          } else {
            _timeExpression += value;
          }
        }
      } else if (value == '.') {
        final currentNumber = _timeCurrentNumber();

        if (!currentNumber.contains('.')) {
          if (_timeExpression.isEmpty ||
              _isOperator(
                _timeExpression[
                    _timeExpression.length - 1],
              )) {
            _timeExpression += '0.';
          } else {
            _timeExpression += '.';
          }
        }
      } else {
        _timeExpression += value;
      }

      _calculateTimePreview();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_timeExpressionScrollController.hasClients) {
          _timeExpressionScrollController.jumpTo(
            _timeExpressionScrollController
                .position
                .maxScrollExtent,
          );
        }
      });
    });
  }

  String _timeCurrentNumber() {
    if (_timeExpression.isEmpty) return '';

    int index = _timeExpression.length - 1;

    while (
        index >= 0 &&
        !_isOperator(_timeExpression[index])) {
      index--;
    }

    return _timeExpression.substring(index + 1);
  }

  int? _parseTime(String value) {
    if (value.isEmpty || value == '-') {
      return null;
    }

    final negative = value.startsWith('-');
    final clean = negative
        ? value.substring(1)
        : value;

    try {
      if (clean.contains('.')) {
        final parts = clean.split('.');

        final hours = int.parse(
          parts[0].isEmpty ? '0' : parts[0],
        );

        String minuteText =
            parts.length > 1 ? parts[1] : '0';

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

      return int.parse(clean) *
          60 *
          (negative ? -1 : 1);
    } catch (_) {
      return null;
    }
  }

  int? _evaluateTime(String expression) {
    if (expression.isEmpty) return null;

    final tokens = _normalTokens(expression);

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

          if (value == null) {
            return null;
          }

          numbers.add(value);
        }
      }

      if (numbers.isEmpty) return null;

      for (int i = 0; i < operators.length;) {
        if (operators[i] == '×' ||
            operators[i] == '÷') {
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

  void _calculateTimePreview() {
    final value = _evaluateTime(_timeExpression);

    if (value != null) {
      _timeResultMinutes = value;
    } else {
      _timeResultMinutes = 0;
    }
  }

  void _calculateTimeFinal() {
    final value = _evaluateTime(_timeExpression);

    if (value == null) {
      return;
    }

    if (_timeExpression.isNotEmpty) {
      _timeHistory.insert(
        0,
        '$_timeExpression = ${_formatTime(value)}',
      );

      if (_timeHistory.length > 30) {
        _timeHistory.removeLast();
      }
    }

    setState(() {
      _timeResultMinutes = value;
    });
  }

  // ============================================================
  // TIME KEYPAD
  // ============================================================

  Widget _timeKeypad() {
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
                  child: _timeButton(value),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _timeButton(String value) {
    final operator = _isOperator(value);
    final action =
        value == 'C' || value == '⌫' || value == '=';

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () => _addTime(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: value == '='
              ? const Color(0xFFC9A45C)
              : operator
                  ? const Color(0xFF176B45)
                  : action
                      ? const Color(0xFF294D3E)
                      : Theme.of(context).brightness ==
                              Brightness.dark
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
                    ? Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                    : Colors.white,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OPERATOR
  // ============================================================

  bool _isOperator(String value) {
    return value == '+' ||
        value == '-' ||
        value == '×' ||
        value == '÷';
  }

  // ============================================================
  // TIME FORMATTING
  // ============================================================

  String _formatTime(int totalMinutes) {
    final negative = totalMinutes < 0;
    final absolute = totalMinutes.abs();

    final hours = absolute ~/ 60;
    final minutes = absolute % 60;

    final result = '$hours ঘণ্টা $minutes মিনিট';

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

  // ============================================================
  // TIME AVERAGE
  // ============================================================

  void _showTimeDailyAverage() {
    if (_timeExpression.isEmpty) {
      _showMessage(
        'আগে Time Calculator-এ একটি হিসাব করুন।',
      );
      return;
    }

    final value = _evaluateTime(_timeExpression);

    if (value == null) {
      _showMessage(
        'আগে একটি সঠিক Time Calculation করুন।',
      );
      return;
    }

    _showDaysDialog(
      title: 'দৈনিক গড়',
      totalMinutes: value,
      defaultDays: 1,
    );
  }

  void _showTimeMonthlyAverage() {
    if (_timeExpression.isEmpty) {
      _showMessage(
        'আগে Time Calculator-এ একটি হিসাব করুন।',
      );
      return;
    }

    final value = _evaluateTime(_timeExpression);

    if (value == null) {
      _showMessage(
        'আগে একটি সঠিক Time Calculation করুন।',
      );
      return;
    }

    _showDaysDialog(
      title: 'মাসিক গড়',
      totalMinutes: value,
      defaultDays: 30,
    );
  }

  // ============================================================
  // NORMAL AVERAGE
  // ============================================================

  void _showNormalDailyAverage() {
    if (_normalExpression.isEmpty) {
      _showMessage(
        'আগে Normal Calculator-এ একটি হিসাব করুন।',
      );
      return;
    }

    final value = _evaluateNormal(_normalExpression);

    if (value == null) {
      _showMessage(
        'আগে একটি সঠিক Normal Calculation করুন।',
      );
      return;
    }

    _showNumberDaysDialog(
      title: 'দৈনিক গড়',
      totalValue: value,
      defaultDays: 1,
    );
  }

  void _showNormalMonthlyAverage() {
    if (_normalExpression.isEmpty) {
      _showMessage(
        'আগে Normal Calculator-এ একটি হিসাব করুন।',
      );
      return;
    }

    final value = _evaluateNormal(_normalExpression);

    if (value == null) {
      _showMessage(
        'আগে একটি সঠিক Normal Calculation করুন।',
      );
      return;
    }

    _showNumberDaysDialog(
      title: 'মাসিক গড়',
      totalValue: value,
      defaultDays: 30,
    );
  }

  // ============================================================
  // TIME DAYS DIALOG
  // ============================================================

  void _showDaysDialog({
    required String title,
    required int totalMinutes,
    required int defaultDays,
  }) {
    final controller = TextEditingController(
      text: defaultDays.toString(),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'কত দিনের হিসাব?',
              hintText: 'উদাহরণ: 5',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                final days =
                    int.tryParse(controller.text.trim());

                if (days == null || days <= 0) {
                  return;
                }

                final average = totalMinutes ~/ days;

                Navigator.pop(dialogContext);

                _showResultDialog(
                  title: title,
                  result: _formatTime(average),
                  extra:
                      'মোট সময়: ${_formatTime(totalMinutes)}\n'
                      'দিন: $days',
                );
              },
              child: const Text('হিসাব'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // NORMAL DAYS DIALOG
  // ============================================================

  void _showNumberDaysDialog({
    required String title,
    required double totalValue,
    required int defaultDays,
  }) {
    final controller = TextEditingController(
      text: defaultDays.toString(),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'কত দিনের হিসাব?',
              hintText: 'উদাহরণ: 5',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                final days =
                    int.tryParse(controller.text.trim());

                if (days == null || days <= 0) {
                  return;
                }

                final average = totalValue / days;

                Navigator.pop(dialogContext);

                _showResultDialog(
                  title: title,
                  result: _formatNumber(average),
                  extra:
                      'মোট: ${_formatNumber(totalValue)}\n'
                      'দিন: $days',
                );
              },
              child: const Text('হিসাব'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // RESULT DIALOG
  // ============================================================

  void _showResultDialog({
    required String title,
    required String result,
    required String extra,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFC9A45C),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                extra,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ঠিক আছে'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // NORMAL HISTORY
  // ============================================================

  void _showNormalHistory() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              20,
            ),
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
                    itemCount: _normalHistory.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.history_rounded,
                          color: Color(0xFFC9A45C),
                        ),
                        title: Text(
                          _normalHistory[index],
                        ),
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

  // ============================================================
  // TIME HISTORY
  // ============================================================

  void _showTimeHistory() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              20,
            ),
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
                    itemCount: _timeHistory.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.history_rounded,
                          color: Color(0xFFC9A45C),
                        ),
                        title: Text(
                          _timeHistory[index],
                        ),
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

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _timeExpressionScrollController.dispose();
    _normalExpressionScrollController.dispose();
    super.dispose();
  }
}

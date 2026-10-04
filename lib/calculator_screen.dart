import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // ============================================================
  // THEME
  // ============================================================

  static const Color darkGreen = Color(0xFF0F5132);
  static const Color green = Color(0xFF176B45);
  static const Color gold = Color(0xFFC9A45C);
  static const Color darkBackground = Color(0xFF10291F);
  static const Color lightBackground = Color(0xFFFFFCF5);

  bool _isDarkMode = true;

  // ============================================================
  // CALCULATOR TYPE
  // ============================================================

  bool _isTimeCalculator = true;

  // ============================================================
  // TIME CALCULATOR
  // ============================================================

  String _timeExpression = '';
  String _timeDisplayResult = '0';

  // সর্বশেষ সম্পন্ন Time calculation-এর result
  int? _lastTimeResultMinutes;

  List<String> _timeHistory = [];

  // ============================================================
  // NORMAL CALCULATOR
  // ============================================================

  String _normalExpression = '';
  String _normalDisplayResult = '0';

  // সর্বশেষ সম্পন্ন Normal calculation-এর result
  double? _lastNormalResult;

  List<String> _normalHistory = [];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadTheme();
  }

  // ============================================================
  // THEME LOAD / SAVE
  // ============================================================

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _isDarkMode = prefs.getBool('calculator_dark_mode') ?? true;
    });
  }

  Future<void> _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('calculator_dark_mode', _isDarkMode);
  }

  // ============================================================
  // HISTORY LOAD
  // ============================================================

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final timeHistory =
        prefs.getStringList('calculator_time_history') ?? [];

    final normalHistory =
        prefs.getStringList('calculator_normal_history') ?? [];

    if (!mounted) return;

    setState(() {
      _timeHistory = List<String>.from(timeHistory);
      _normalHistory = List<String>.from(normalHistory);
    });
  }

  Future<void> _saveTimeHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'calculator_time_history',
      _timeHistory,
    );
  }

  Future<void> _saveNormalHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'calculator_normal_history',
      _normalHistory,
    );
  }

  // ============================================================
  // COLORS
  // ============================================================

  Color get _background =>
      _isDarkMode ? darkBackground : lightBackground;

  Color get _cardColor =>
      _isDarkMode
          ? const Color(0xFF183A2D)
          : const Color(0xFFFFFFFF);

  Color get _displayColor =>
      _isDarkMode
          ? const Color(0xFF0C2118)
          : const Color(0xFFF3EFE4);

  Color get _textColor =>
      _isDarkMode
          ? Colors.white
          : const Color(0xFF1A1A1A);

  Color get _secondaryTextColor =>
      _isDarkMode
          ? Colors.white70
          : const Color(0xFF666666);

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ক্যালকুলেটর',
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
            onPressed: _toggleTheme,
            icon: Icon(
              _isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: gold,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCalculatorToggle(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isTimeCalculator
                    ? _buildTimeCalculator()
                    : _buildNormalCalculator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP TOGGLE
  // ============================================================

  Widget _buildCalculatorToggle() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: gold.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleButton(
              title: 'Time Calculator',
              icon: Icons.access_time_rounded,
              selected: _isTimeCalculator,
              onTap: () {
                setState(() {
                  _isTimeCalculator = true;
                });
              },
            ),
          ),
          Expanded(
            child: _toggleButton(
              title: 'Normal Calculator',
              icon: Icons.calculate_rounded,
              selected: !_isTimeCalculator,
              onTap: () {
                setState(() {
                  _isTimeCalculator = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? green : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: selected ? Colors.white : gold,
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : _textColor,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TIME CALCULATOR UI
  // ============================================================

  Widget _buildTimeCalculator() {
    return Column(
      key: const ValueKey('time_calculator'),
      children: [
        _buildTimeDisplay(),
        _buildTimeTools(),
        Expanded(
          child: _buildKeypad(
            isTime: true,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeDisplay() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _displayColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                _timeExpression.isEmpty
                    ? '0'
                    : _timeExpression,
                maxLines: 1,
                style: TextStyle(
                  color: _secondaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                _timeDisplayResult,
                maxLines: 1,
                style: TextStyle(
                  color: gold,
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TIME TOOLS
  // ============================================================

  Widget _buildTimeTools() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
          const SizedBox(width: 8),
          Expanded(
            child: _toolButton(
              icon: Icons.history_rounded,
              title: 'History',
              onTap: () => _showHistory(isTime: true),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NORMAL CALCULATOR UI
  // ============================================================

  Widget _buildNormalCalculator() {
    return Column(
      key: const ValueKey('normal_calculator'),
      children: [
        _buildNormalDisplay(),
        _buildNormalTools(),
        Expanded(
          child: _buildKeypad(
            isTime: false,
          ),
        ),
      ],
    );
  }

  Widget _buildNormalDisplay() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _displayColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                _normalExpression.isEmpty
                    ? '0'
                    : _normalExpression,
                maxLines: 1,
                style: TextStyle(
                  color: _secondaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                _normalDisplayResult,
                maxLines: 1,
                style: TextStyle(
                  color: gold,
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NORMAL TOOLS
  // ============================================================

  Widget _buildNormalTools() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
          const SizedBox(width: 8),
          Expanded(
            child: _toolButton(
              icon: Icons.history_rounded,
              title: 'History',
              onTap: () => _showHistory(isTime: false),
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
    return Material(
      color: _cardColor,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 9,
            horizontal: 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: gold.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 19,
                color: gold,
              ),
              const SizedBox(height: 3),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COMMON KEYPAD
  // ============================================================

  Widget _buildKeypad({
    required bool isTime,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _key(
                  'C',
                  type: _KeyType.clear,
                  onTap: () {
                    if (isTime) {
                      _clearTime();
                    } else {
                      _clearNormal();
                    }
                  },
                ),
                _key(
                  '⌫',
                  type: _KeyType.delete,
                  onTap: () {
                    if (isTime) {
                      _deleteTime();
                    } else {
                      _deleteNormal();
                    }
                  },
                ),
                _key(
                  '÷',
                  type: _KeyType.operator,
                  onTap: () {
                    if (isTime) {
                      _addTimeOperator('÷');
                    } else {
                      _addNormalOperator('÷');
                    }
                  },
                ),
                _key(
                  '×',
                  type: _KeyType.operator,
                  onTap: () {
                    if (isTime) {
                      _addTimeOperator('×');
                    } else {
                      _addNormalOperator('×');
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _key(
                  '7',
                  onTap: () => isTime
                      ? _addTimeNumber('7')
                      : _addNormalNumber('7'),
                ),
                _key(
                  '8',
                  onTap: () => isTime
                      ? _addTimeNumber('8')
                      : _addNormalNumber('8'),
                ),
                _key(
                  '9',
                  onTap: () => isTime
                      ? _addTimeNumber('9')
                      : _addNormalNumber('9'),
                ),
                _key(
                  '-',
                  type: _KeyType.operator,
                  onTap: () {
                    if (isTime) {
                      _addTimeOperator('-');
                    } else {
                      _addNormalOperator('-');
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _key(
                  '4',
                  onTap: () => isTime
                      ? _addTimeNumber('4')
                      : _addNormalNumber('4'),
                ),
                _key(
                  '5',
                  onTap: () => isTime
                      ? _addTimeNumber('5')
                      : _addNormalNumber('5'),
                ),
                _key(
                  '6',
                  onTap: () => isTime
                      ? _addTimeNumber('6')
                      : _addNormalNumber('6'),
                ),
                _key(
                  '+',
                  type: _KeyType.operator,
                  onTap: () {
                    if (isTime) {
                      _addTimeOperator('+');
                    } else {
                      _addNormalOperator('+');
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _key(
                  '1',
                  onTap: () => isTime
                      ? _addTimeNumber('1')
                      : _addNormalNumber('1'),
                ),
                _key(
                  '2',
                  onTap: () => isTime
                      ? _addTimeNumber('2')
                      : _addNormalNumber('2'),
                ),
                _key(
                  '3',
                  onTap: () => isTime
                      ? _addTimeNumber('3')
                      : _addNormalNumber('3'),
                ),
                _key(
                  '=',
                  type: _KeyType.equals,
                  onTap: isTime
                      ? _calculateTime
                      : _calculateNormal,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _key(
                  '0',
                  flex: 2,
                  onTap: () => isTime
                      ? _addTimeNumber('0')
                      : _addNormalNumber('0'),
                ),
                _key(
                  '.',
                  onTap: () => isTime
                      ? _addTimeNumber('.')
                      : _addNormalNumber('.'),
                ),
                _key(
                  '=',
                  type: _KeyType.equals,
                  onTap: isTime
                      ? _calculateTime
                      : _calculateNormal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _key(
    String text, {
    required VoidCallback onTap,
    _KeyType type = _KeyType.number,
    int flex = 1,
  }) {
    Color textColor = _textColor;

    if (type == _KeyType.operator) {
      textColor = gold;
    } else if (type == _KeyType.equals) {
      textColor = Colors.white;
    } else if (type == _KeyType.clear) {
      textColor = Colors.redAccent;
    } else if (type == _KeyType.delete) {
      textColor = gold;
    }

    Color background;

    if (type == _KeyType.equals) {
      background = green;
    } else if (type == _KeyType.operator) {
      background = _isDarkMode
          ? const Color(0xFF1C4636)
          : const Color(0xFFEDE7D9);
    } else if (type == _KeyType.clear ||
        type == _KeyType.delete) {
      background = _isDarkMode
          ? const Color(0xFF1A3B2E)
          : const Color(0xFFF0EBDF);
    } else {
      background = _cardColor;
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: text == '⌫' ? 23 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TIME INPUT
  // ============================================================

  void _addTimeNumber(String value) {
    setState(() {
      _timeExpression += value;
      _updateTimePreview();
    });
  }

  void _addTimeOperator(String operator) {
    if (_timeExpression.isEmpty) {
      if (operator == '-') {
        setState(() {
          _timeExpression = '-';
        });
      }
      return;
    }

    final last = _timeExpression[_timeExpression.length - 1];

    if ('+-×÷'.contains(last)) {
      setState(() {
        _timeExpression =
            '${_timeExpression.substring(0, _timeExpression.length - 1)}$operator';
      });
    } else {
      setState(() {
        _timeExpression += operator;
      });
    }
  }

  void _deleteTime() {
    if (_timeExpression.isEmpty) return;

    setState(() {
      _timeExpression =
          _timeExpression.substring(0, _timeExpression.length - 1);

      if (_timeExpression.isEmpty) {
        _timeDisplayResult = '0';
      } else {
        _updateTimePreview();
      }
    });
  }

  void _clearTime() {
    setState(() {
      _timeExpression = '';
      _timeDisplayResult = '0';
      _lastTimeResultMinutes = null;
    });
  }

  // ============================================================
  // TIME PARSER
  // ============================================================

  /// Time format:
  ///
  /// 1.20  = 1 hour 20 minutes
  /// 2.30  = 2 hours 30 minutes
  /// 200.20 = 200 hours 20 minutes
  ///
  /// Minute অংশ 60-এর বেশি হলেও invalid হবে না।
  ///
  /// 1.60 = 2 hours
  /// 1.75 = 2 hours 15 minutes
  /// 2.90 = 3 hours 30 minutes
  ///
  /// Extra minutes automatically hour-এ carry হবে।
  int? _parseTime(String value) {
    if (value.isEmpty || value == '-') {
      return null;
    }

    final negative = value.startsWith('-');
    final clean =
        negative ? value.substring(1) : value;

    if (clean.isEmpty) {
      return null;
    }

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

        // HH.MM format:
        // decimal-এর প্রথম দুই digit minute হিসেবে ধরা হবে।
        if (minuteText.length > 2) {
          minuteText = minuteText.substring(0, 2);
        }

        // আগের behavior বজায়:
        // 1.6 = 1.60 = 2 ঘণ্টা
        if (minuteText.length == 1) {
          minuteText = '${minuteText}0';
        }

        final minutes = int.parse(minuteText);

        // গুরুত্বপূর্ণ:
        // minutes >= 60 হলে আর null করা হচ্ছে না।
        // Total minutes থেকে automatic carry হবে।
        final totalMinutes =
            (hours * 60) + minutes;

        return negative
            ? -totalMinutes
            : totalMinutes;
      }

      final hours = int.parse(clean);
      final totalMinutes = hours * 60;

      return negative
          ? -totalMinutes
          : totalMinutes;
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // TIME TOKENIZE
  // ============================================================

  List<String> _timeTokens(String expression) {
    final normalized =
        expression.replaceAll(' ', '');

    final tokens = <String>[];
    String number = '';

    for (int i = 0; i < normalized.length; i++) {
      final char = normalized[i];

      if ('0123456789.'.contains(char)) {
        number += char;
      } else if ('+-×÷'.contains(char)) {
        if (number.isNotEmpty) {
          tokens.add(number);
          number = '';
        }

        if (char == '-' &&
            (tokens.isEmpty ||
                '+-×÷'.contains(tokens.last))) {
          number = '-';
        } else {
          tokens.add(char);
        }
      }
    }

    if (number.isNotEmpty) {
      tokens.add(number);
    }

    return tokens;
  }

  // ============================================================
  // TIME EVALUATION
  // ============================================================

  int? _evaluateTime(String expression) {
    final tokens = _timeTokens(expression);

    if (tokens.isEmpty) {
      return null;
    }

    final values = <int>[];
    final operators = <String>[];

    for (final token in tokens) {
      if ('+-×÷'.contains(token)) {
        operators.add(token);
      } else {
        final value = _parseTime(token);

        if (value == null) {
          return null;
        }

        values.add(value);
      }
    }

    if (values.isEmpty ||
        values.length != operators.length + 1) {
      return null;
    }

    // × এবং ÷ আগে
    final newValues = <int>[];
    final newOperators = <String>[];

    int current = values[0];

    for (int i = 0; i < operators.length; i++) {
      final operator = operators[i];
      final next = values[i + 1];

      if (operator == '×') {
        current = current * next;
      } else if (operator == '÷') {
        if (next == 0) {
          return null;
        }

        current = current ~/ next;
      } else {
        newValues.add(current);
        newOperators.add(operator);
        current = next;
      }
    }

    newValues.add(current);

    // তারপর + এবং -
    int result = newValues[0];

    for (int i = 0; i < newOperators.length; i++) {
      if (newOperators[i] == '+') {
        result += newValues[i + 1];
      } else if (newOperators[i] == '-') {
        result -= newValues[i + 1];
      }
    }

    return result;
  }

  // ============================================================
  // TIME PREVIEW
  // ============================================================

  void _updateTimePreview() {
    final result = _evaluateTime(_timeExpression);

    if (result == null) {
      _timeDisplayResult = '0';
    } else {
      _timeDisplayResult = _formatTime(result);
    }
  }

  // ============================================================
  // TIME CALCULATE
  // ============================================================

  Future<void> _calculateTime() async {
    if (_timeExpression.isEmpty) return;

    final result =
        _evaluateTime(_timeExpression);

    if (result == null) {
      setState(() {
        _timeDisplayResult = '0';
      });

      _showMessage('সঠিক সময়ের হিসাব দিন।');
      return;
    }

    final formatted =
        _formatTime(result);

    setState(() {
      _timeDisplayResult = formatted;

      // সর্বশেষ completed result সংরক্ষণ
      _lastTimeResultMinutes = result;
    });

    final historyText =
        '$_timeExpression = $formatted';

    _timeHistory.insert(
      0,
      historyText,
    );

    if (_timeHistory.length > 30) {
      _timeHistory =
          _timeHistory.take(30).toList();
    }

    await _saveTimeHistory();
  }

  // ============================================================
  // TIME FORMAT
  // ============================================================

  String _formatTime(int totalMinutes) {
    final negative =
        totalMinutes < 0;

    final absolute =
        totalMinutes.abs();

    final hours =
        absolute ~/ 60;

    final minutes =
        absolute % 60;

    String result;

    if (hours == 0) {
      result = '$minutes মিনিট';
    } else if (minutes == 0) {
      result = '$hours ঘণ্টা';
    } else {
      result =
          '$hours ঘণ্টা $minutes মিনিট';
    }

    return negative
        ? '-$result'
        : result;
  }

  // ============================================================
  // TIME DAILY AVERAGE
  // ============================================================

  void _showTimeDailyAverage() {
    if (_lastTimeResultMinutes == null) {
      _showMessage(
        'আগে একটি Time calculation করুন।',
      );
      return;
    }

    _showDaysDialog(
      title: 'দৈনিক গড়',
      totalMinutes:
          _lastTimeResultMinutes!,
    );
  }

  // ============================================================
  // TIME MONTHLY AVERAGE
  // ============================================================

  void _showTimeMonthlyAverage() {
    if (_lastTimeResultMinutes == null) {
      _showMessage(
        'আগে একটি Time calculation করুন।',
      );
      return;
    }

    _showDaysDialog(
      title: 'মাসিক গড়',
      totalMinutes:
          _lastTimeResultMinutes!,
    );
  }

  // ============================================================
  // TIME AVERAGE DAYS DIALOG
  // ============================================================

  void _showDaysDialog({
    required String title,
    required int totalMinutes,
  }) {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _cardColor,
          title: Text(
            title,
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'সর্বশেষ হিসাব: ${_formatTime(totalMinutes)}',
                style: TextStyle(
                  color: gold,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'কত দিনের হিসাব?',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                keyboardType:
                    TextInputType.number,
                autofocus: true,
                style: TextStyle(
                  color: _textColor,
                ),
                decoration:
                    InputDecoration(
                  hintText: 'যেমন: 5',
                  hintStyle: TextStyle(
                    color:
                        _secondaryTextColor,
                  ),
                  suffixText: 'দিন',
                  suffixStyle:
                      TextStyle(
                    color: gold,
                  ),
                  filled: true,
                  fillColor:
                      _displayColor,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'বাতিল',
                style: TextStyle(
                  color:
                      _secondaryTextColor,
                ),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () {
                final days =
                    int.tryParse(
                  controller.text.trim(),
                );

                if (days == null ||
                    days <= 0) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                );

                final average =
                    totalMinutes /
                        days;

                _showTimeAverageResult(
                  title: title,
                  averageMinutes:
                      average,
                  days: days,
                );
              },
              child:
                  const Text('হিসাব করুন'),
            ),
          ],
        );
      },
    );
  }

  void _showTimeAverageResult({
    required String title,
    required double averageMinutes,
    required int days,
  }) {
    final roundedMinutes =
        averageMinutes.round();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _cardColor,
          title: Text(
            title,
            style: TextStyle(
              color: _textColor,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Text(
                'প্রতি দিন',
                style: TextStyle(
                  color:
                      _secondaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatTime(
                  roundedMinutes,
                ),
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color: gold,
                  fontSize: 26,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$days দিনের গড়',
                style: TextStyle(
                  color:
                      _secondaryTextColor,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'ঠিক আছে',
                style: TextStyle(
                  color: gold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // NORMAL INPUT
  // ============================================================

  void _addNormalNumber(String value) {
    setState(() {
      _normalExpression += value;
      _updateNormalPreview();
    });
  }

  void _addNormalOperator(
    String operator,
  ) {
    if (_normalExpression.isEmpty) {
      if (operator == '-') {
        setState(() {
          _normalExpression = '-';
        });
      }
      return;
    }

    final last =
        _normalExpression[
            _normalExpression.length - 1];

    if ('+-×÷'.contains(last)) {
      setState(() {
        _normalExpression =
            '${_normalExpression.substring(0, _normalExpression.length - 1)}$operator';
      });
    } else {
      setState(() {
        _normalExpression +=
            operator;
      });
    }
  }

  void _deleteNormal() {
    if (_normalExpression.isEmpty) {
      return;
    }

    setState(() {
      _normalExpression =
          _normalExpression.substring(
        0,
        _normalExpression.length - 1,
      );

      if (_normalExpression.isEmpty) {
        _normalDisplayResult =
            '0';
      } else {
        _updateNormalPreview();
      }
    });
  }

  void _clearNormal() {
    setState(() {
      _normalExpression = '';
      _normalDisplayResult = '0';
      _lastNormalResult = null;
    });
  }

  // ============================================================
  // NORMAL TOKENIZE
  // ============================================================

  List<String> _normalTokens(
    String expression,
  ) {
    final normalized =
        expression.replaceAll(' ', '');

    final tokens = <String>[];
    String number = '';

    for (int i = 0;
        i < normalized.length;
        i++) {
      final char =
          normalized[i];

      if ('0123456789.'.contains(
        char,
      )) {
        number += char;
      } else if ('+-×÷'.contains(
        char,
      )) {
        if (number.isNotEmpty) {
          tokens.add(number);
          number = '';
        }

        if (char == '-' &&
            (tokens.isEmpty ||
                '+-×÷'.contains(
                  tokens.last,
                ))) {
          number = '-';
        } else {
          tokens.add(char);
        }
      }
    }

    if (number.isNotEmpty) {
      tokens.add(number);
    }

    return tokens;
  }

  // ============================================================
  // NORMAL EVALUATION
  // ============================================================

  double? _evaluateNormal(
    String expression,
  ) {
    final tokens =
        _normalTokens(expression);

    if (tokens.isEmpty) {
      return null;
    }

    final values = <double>[];
    final operators = <String>[];

    for (final token in tokens) {
      if ('+-×÷'.contains(
        token,
      )) {
        operators.add(token);
      } else {
        final value =
            double.tryParse(token);

        if (value == null) {
          return null;
        }

        values.add(value);
      }
    }

    if (values.isEmpty ||
        values.length !=
            operators.length + 1) {
      return null;
    }

    // × এবং ÷ আগে
    final newValues =
        <double>[];

    final newOperators =
        <String>[];

    double current =
        values[0];

    for (int i = 0;
        i < operators.length;
        i++) {
      final operator =
          operators[i];

      final next =
          values[i + 1];

      if (operator == '×') {
        current *= next;
      } else if (operator == '÷') {
        if (next == 0) {
          return null;
        }

        current /= next;
      } else {
        newValues.add(current);
        newOperators.add(operator);
        current = next;
      }
    }

    newValues.add(current);

    // + এবং -
    double result =
        newValues[0];

    for (int i = 0;
        i < newOperators.length;
        i++) {
      if (newOperators[i] == '+') {
        result +=
            newValues[i + 1];
      } else if (
          newOperators[i] == '-') {
        result -=
            newValues[i + 1];
      }
    }

    return result;
  }

  // ============================================================
  // NORMAL PREVIEW
  // ============================================================

  void _updateNormalPreview() {
    final result =
        _evaluateNormal(
      _normalExpression,
    );

    if (result == null) {
      _normalDisplayResult =
          '0';
    } else {
      _normalDisplayResult =
          _formatNumber(result);
    }
  }

  // ============================================================
  // NORMAL CALCULATE
  // ============================================================

  Future<void> _calculateNormal() async {
    if (_normalExpression.isEmpty) {
      return;
    }

    final result =
        _evaluateNormal(
      _normalExpression,
    );

    if (result == null) {
      setState(() {
        _normalDisplayResult =
            '0';
      });

      _showMessage(
        'সঠিক হিসাব দিন।',
      );
      return;
    }

    final formatted =
        _formatNumber(result);

    setState(() {
      _normalDisplayResult =
          formatted;

      // সর্বশেষ completed result
      _lastNormalResult =
          result;
    });

    final historyText =
        '$_normalExpression = $formatted';

    _normalHistory.insert(
      0,
      historyText,
    );

    if (_normalHistory.length >
        30) {
      _normalHistory =
          _normalHistory
              .take(30)
              .toList();
    }

    await _saveNormalHistory();
  }

  // ============================================================
  // NUMBER FORMAT
  // ============================================================

  String _formatNumber(
    double number,
  ) {
    if (number.isNaN ||
        number.isInfinite) {
      return '0';
    }

    if (number ==
        number.roundToDouble()) {
      return number.toInt().toString();
    }

    return number
        .toStringAsFixed(10)
        .replaceFirst(
          RegExp(r'0+$'),
          '',
        )
        .replaceFirst(
          RegExp(r'\.$'),
          '',
        );
  }

  // ============================================================
  // NORMAL DAILY AVERAGE
  // ============================================================

  void _showNormalDailyAverage() {
    if (_lastNormalResult ==
        null) {
      _showMessage(
        'আগে একটি Normal calculation করুন।',
      );
      return;
    }

    _showNormalDaysDialog(
      title: 'দৈনিক গড়',
      totalValue:
          _lastNormalResult!,
    );
  }

  // ============================================================
  // NORMAL MONTHLY AVERAGE
  // ============================================================

  void _showNormalMonthlyAverage() {
    if (_lastNormalResult ==
        null) {
      _showMessage(
        'আগে একটি Normal calculation করুন।',
      );
      return;
    }

    _showNormalDaysDialog(
      title: 'মাসিক গড়',
      totalValue:
          _lastNormalResult!,
    );
  }

  // ============================================================
  // NORMAL AVERAGE DAYS DIALOG
  // ============================================================

  void _showNormalDaysDialog({
    required String title,
    required double totalValue,
  }) {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              _cardColor,
          title: Text(
            title,
            style: TextStyle(
              color: _textColor,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'সর্বশেষ হিসাব: ${_formatNumber(totalValue)}',
                style: TextStyle(
                  color: gold,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'কত দিনের হিসাব?',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller:
                    controller,
                keyboardType:
                    TextInputType.number,
                autofocus: true,
                style: TextStyle(
                  color: _textColor,
                ),
                decoration:
                    InputDecoration(
                  hintText: 'যেমন: 5',
                  hintStyle: TextStyle(
                    color:
                        _secondaryTextColor,
                  ),
                  suffixText: 'দিন',
                  suffixStyle:
                      TextStyle(
                    color: gold,
                  ),
                  filled: true,
                  fillColor:
                      _displayColor,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'বাতিল',
                style: TextStyle(
                  color:
                      _secondaryTextColor,
                ),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    green,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () {
                final days =
                    int.tryParse(
                  controller.text
                      .trim(),
                );

                if (days == null ||
                    days <= 0) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                );

                final average =
                    totalValue /
                        days;

                _showNormalAverageResult(
                  title: title,
                  average: average,
                  days: days,
                );
              },
              child:
                  const Text(
                'হিসাব করুন',
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNormalAverageResult({
    required String title,
    required double average,
    required int days,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              _cardColor,
          title: Text(
            title,
            style: TextStyle(
              color: _textColor,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Text(
                'প্রতি দিন',
                style: TextStyle(
                  color:
                      _secondaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatNumber(
                  average,
                ),
                style: TextStyle(
                  color: gold,
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$days দিনের গড়',
                style: TextStyle(
                  color:
                      _secondaryTextColor,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'ঠিক আছে',
                style: TextStyle(
                  color: gold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // HISTORY
  // ============================================================

  void _showHistory({
    required bool isTime,
  }) {
    final history =
        isTime
            ? _timeHistory
            : _normalHistory;

    showModalBottomSheet(
      context: context,
      backgroundColor:
          _background,
      isScrollControlled: true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height:
                MediaQuery.of(context)
                        .size
                        .height *
                    0.72,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 42,
                  height: 4,
                  decoration:
                      BoxDecoration(
                    color:
                        _secondaryTextColor
                            .withValues(
                      alpha: 0.4,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(10),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 18,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .history_rounded,
                        color: gold,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          isTime
                              ? 'Time Calculator History'
                              : 'Normal Calculator History',
                          style:
                              TextStyle(
                            color:
                                _textColor,
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                      if (history
                          .isNotEmpty)
                        IconButton(
                          onPressed:
                              () async {
                            if (isTime) {
                              setState(
                                () {
                                  _timeHistory
                                      .clear();
                                },
                              );

                              await _saveTimeHistory();
                            } else {
                              setState(
                                () {
                                  _normalHistory
                                      .clear();
                                },
                              );

                              await _saveNormalHistory();
                            }

                            if (sheetContext
                                .mounted) {
                              Navigator.pop(
                                sheetContext,
                              );
                            }
                          },
                          icon:
                              const Icon(
                            Icons
                                .delete_outline_rounded,
                            color:
                                Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: history
                          .isEmpty
                      ? Center(
                          child: Text(
                            'কোনো history নেই',
                            style:
                                TextStyle(
                              color:
                                  _secondaryTextColor,
                            ),
                          ),
                        )
                      : ListView
                          .separated(
                          padding:
                              const EdgeInsets
                                  .all(12),
                          itemCount:
                              history.length,
                          separatorBuilder:
                              (_, __) =>
                                  const SizedBox(
                            height: 8,
                          ),
                          itemBuilder:
                              (
                            itemContext,
                            index,
                          ) {
                            return Container(
                              padding:
                                  const EdgeInsets
                                      .all(14),
                              decoration:
                                  BoxDecoration(
                                color:
                                    _cardColor,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  14,
                                ),
                                border:
                                    Border.all(
                                  color:
                                      gold.withValues(
                                    alpha:
                                        0.18,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          green.withValues(
                                        alpha:
                                            0.2,
                                      ),
                                      shape:
                                          BoxShape
                                              .circle,
                                    ),
                                    child:
                                        Center(
                                      child:
                                          Text(
                                        '${index + 1}',
                                        style:
                                            TextStyle(
                                          color:
                                              gold,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child:
                                        Text(
                                      history[
                                          index],
                                      style:
                                          TextStyle(
                                        color:
                                            _textColor,
                                        fontSize:
                                            15,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),
                                  ),
                                ],
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
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content:
              Text(message),
          backgroundColor:
              darkGreen,
          behavior:
              SnackBarBehavior
                  .floating,
        ),
      );
  }
}

// ================================================================
// KEY TYPE
// ================================================================

enum _KeyType {
  number,
  operator,
  equals,
  clear,
  delete,
}

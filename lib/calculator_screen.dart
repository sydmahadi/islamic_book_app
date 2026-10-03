import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ক্যালকুলেটর'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _button(
              context,
              icon: Icons.calculate,
              title: 'Normal Calculator',
              subtitle: 'সাধারণ হিসাব',
              page: const NormalCalculatorPage(),
            ),

            const SizedBox(height: 16),

            _button(
              context,
              icon: Icons.access_time,
              title: 'Time Calculator',
              subtitle: 'ঘণ্টা ও মিনিটের হিসাব',
              page: const TimeCalculatorPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
      ),
    );
  }
}

class NormalCalculatorPage extends StatefulWidget {
  const NormalCalculatorPage({super.key});

  @override
  State<NormalCalculatorPage> createState() =>
      _NormalCalculatorPageState();
}

class _NormalCalculatorPageState
    extends State<NormalCalculatorPage> {
  String display = '0';
  double? firstNumber;
  String? operation;
  bool clearNext = false;

  void press(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        firstNumber = null;
        operation = null;
        clearNext = false;
        return;
      }

      if (value == '+' ||
          value == '-' ||
          value == '×' ||
          value == '÷') {
        firstNumber = double.tryParse(display);
        operation = value;
        clearNext = true;
        return;
      }

      if (value == '=') {
        if (firstNumber == null || operation == null) {
          return;
        }

        final second = double.tryParse(display) ?? 0;

        double result = 0;

        switch (operation) {
          case '+':
            result = firstNumber! + second;
            break;
          case '-':
            result = firstNumber! - second;
            break;
          case '×':
            result = firstNumber! * second;
            break;
          case '÷':
            if (second == 0) {
              display = 'Error';
              return;
            }
            result = firstNumber! / second;
            break;
        }

        display = result
            .toStringAsFixed(10)
            .replaceFirst(RegExp(r'\.?0+$'), '');

        firstNumber = null;
        operation = null;
        clearNext = true;

        return;
      }

      if (clearNext) {
        display = value;
        clearNext = false;
      } else {
        if (display == '0') {
          display = value;
        } else {
          display += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Normal Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _calculatorButtons(),
        ],
      ),
    );
  }

  Widget _calculatorButtons() {
    const buttons = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
      ['C'],
    ];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: buttons.map((row) {
          return Row(
            children: row.map((button) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    onPressed: () => press(button),
                    child: Text(
                      button,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

class TimeCalculatorPage extends StatefulWidget {
  const TimeCalculatorPage({super.key});

  @override
  State<TimeCalculatorPage> createState() =>
      _TimeCalculatorPageState();
}

class _TimeCalculatorPageState
    extends State<TimeCalculatorPage> {
  String display = '0.00';
  int? firstMinutes;
  String? operation;
  bool clearNext = false;

  int parseTime(String value) {
    if (!value.contains('.')) {
      return int.tryParse(value) ?? 0;
    }

    final parts = value.split('.');

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    return hours * 60 + minutes;
  }

  String formatTime(int totalMinutes) {
    final negative = totalMinutes < 0;

    final absolute = totalMinutes.abs();

    final hours = absolute ~/ 60;
    final minutes = absolute % 60;

    return '${negative ? '-' : ''}$hours.${minutes.toString().padLeft(2, '0')}';
  }

  void press(String value) {
    setState(() {
      if (value == 'C') {
        display = '0.00';
        firstMinutes = null;
        operation = null;
        clearNext = false;
        return;
      }

      if (value == '+' ||
          value == '-' ||
          value == '×' ||
          value == '÷') {
        firstMinutes = parseTime(display);
        operation = value;
        clearNext = true;
        return;
      }

      if (value == '=') {
        if (firstMinutes == null || operation == null) {
          return;
        }

        final second = parseTime(display);

        int result = 0;

        switch (operation) {
          case '+':
            result = firstMinutes! + second;
            break;

          case '-':
            result = firstMinutes! - second;
            break;

          case '×':
            result = firstMinutes! * second;
            break;

          case '÷':
            if (second == 0) {
              display = 'Error';
              return;
            }

            result = firstMinutes! ~/ second;
            break;
        }

        display = formatTime(result);

        firstMinutes = null;
        operation = null;
        clearNext = true;

        return;
      }

      if (value == '.') {
        if (!display.contains('.')) {
          display += '.';
        }

        return;
      }

      if (clearNext) {
        display = value;
        clearNext = false;
      } else {
        if (display == '0.00' || display == '0') {
          display = value;
        } else {
          display += value;
        }
      }
    });
  }

  void calculateDailyAverage() {
    final total = parseTime(display);

    showDialog(
      context: context,
      builder: (_) {
        final controller = TextEditingController();

        return AlertDialog(
          title: const Text('দৈনিক গড়'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'কত দিনের হিসাব?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                final days = int.tryParse(controller.text);

                if (days == null || days <= 0) return;

                final average = total ~/ days;

                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('দৈনিক গড়'),
                    content: Text(
                      formatTime(average),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ঠিক আছে'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('হিসাব'),
            ),
          ],
        );
      },
    );
  }

  void calculateMonthlyAverage() {
    final total = parseTime(display);

    showDialog(
      context: context,
      builder: (_) {
        final controller = TextEditingController();

        return AlertDialog(
          title: const Text('মাসিক গড়'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'কত দিনের মাসিক হিসাব?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                final days = int.tryParse(controller.text);

                if (days == null || days <= 0) return;

                final average = total ~/ days;

                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('মাসিক গড়'),
                    content: Text(
                      formatTime(average),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ঠিক আছে'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('হিসাব'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: calculateDailyAverage,
                    icon: const Icon(Icons.today),
                    label: const Text('দৈনিক গড়'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: calculateMonthlyAverage,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('মাসিক গড়'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          _timeButtons(),
        ],
      ),
    );
  }

  Widget _timeButtons() {
    const buttons = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
      ['C'],
    ];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: buttons.map((row) {
          return Row(
            children: row.map((button) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    onPressed: () => press(button),
                    child: Text(
                      button,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

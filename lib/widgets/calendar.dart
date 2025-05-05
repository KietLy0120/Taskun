import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final Function(DateTime?) onDaySelected;

  const Calendar({Key? key, required this.onDaySelected}) : super(key: key);


  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool isMonthlyView = false; // Default to weekly view
  DateTime? selectedDay; // Variable to track the selected day
  bool isSameDay(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getDayLabel(DateTime? selected, DateTime today) {
    if (selected == null) return 'Today';

    final diff = selected.difference(DateTime(today.year, today.month, today.day)).inDays;

    if (diff == 0) return 'Today';
    if (diff == -1) return 'Yesterday';
    if (diff == 1) return 'Tomorrow';

    return DateFormat('EEEE').format(selected); // e.g., Monday, Tuesday, etc.
  }




  void toggleView() {
    setState(() {
      isMonthlyView = !isMonthlyView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (widget, animation) {
            return FadeTransition(opacity: animation, child: widget);
          },
          child: isMonthlyView ? _buildMonthlyView() : _buildWeeklyView(),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.1,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.pink.shade50.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 5) {
                setState(() => isMonthlyView = true);
              } else if (details.primaryDelta! < -5) {
                setState(() => isMonthlyView = false);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isMonthlyView ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isMonthlyView
                      ? "Swipe up for weekly view"
                      : "Swipe down for monthly view",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 8),
                Icon(
                  isMonthlyView ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),

          ),
        ),
      ],
    );
  }


  Widget _buildWeeklyView() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    List<DateTime> weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    List<String> weekdayAbbreviations = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    String currentMonth = DateFormat('MMMM').format(now);

    return Container(
      key: const ValueKey('weekly'),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(height: 4), // Push everything down slightly
              Text(
                currentMonth,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black.withOpacity(0.7),
                ),
                textHeightBehavior: TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
              Text(
                _getDayLabel(selectedDay, DateTime.now()),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
                textHeightBehavior: TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),

            ],
          ),
          // Weekday row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              String dayLetter = weekdayAbbreviations[index];
              int dayNumber = weekDates[index].day;
              bool isCurrentDay = weekDates[index].day == now.day;
              bool isSelected = isSameDay(weekDates[index], selectedDay);

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayLetter,
                      style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = weekDates[index];
                          widget.onDaySelected(selectedDay);
                        });

                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isCurrentDay
                              ? Colors.indigo
                              : (isSelected ? Colors.indigo.withOpacity(0.4) : Colors.transparent),
                          shape: BoxShape.circle,
                        ),

                        child: Center(
                          child: Text(
                            '$dayNumber',
                            style: TextStyle(
                              color: isCurrentDay || isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


  Widget _buildMonthlyView() {
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    List<DateTime> monthDates = List.generate(daysInMonth, (index) => DateTime(now.year, now.month, index + 1));
    String currentMonth = DateFormat('MMMM').format(now);

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) => true, // Prevents GridView from consuming gestures
      child: Container(
        key: const ValueKey('monthly'),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 320,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                currentMonth,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: daysInMonth,
                itemBuilder: (context, index) {
                  DateTime day = monthDates[index];
                  bool isCurrentDay = isSameDay(day, DateTime.now());
                  bool isSelected = isSameDay(day, selectedDay);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = monthDates[index];
                        widget.onDaySelected(selectedDay);
                      });

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.indigo.withOpacity(0.4)
                            : (isCurrentDay ? Colors.indigo : Colors.transparent),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isCurrentDay || isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}

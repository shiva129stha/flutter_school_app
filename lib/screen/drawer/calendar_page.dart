import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_event.dart';

class NepaliCalendarPage extends StatefulWidget {
  @override
  _NepaliCalendarPageState createState() => _NepaliCalendarPageState();
}

class _NepaliCalendarPageState extends State<NepaliCalendarPage> {
  late picker.NepaliDateTime _selectedDate;
  late PageController _pageController;
  late List<picker.NepaliDateTime> _daysInMonth;
  late List<picker.NepaliDateTime> _previousMonthDays;
  late List<picker.NepaliDateTime> _nextMonthDays;
  final List<String> _nepaliMonths = [
    "बैशाख", "जेठ", "असार", "साउन", "भदौ", "आश्विन", "कार्तिक", "मंसिर", "पुष", "माघ", "फागुन", "चैत"
  ];
  final List<String> _nepaliDaysOfWeek = [
    "आइत", "सोम", "मंगल", "बुध", "बिहि", "शुक्र", "शनि"
  ];
  Map<String, List<Map<String, dynamic>>> _events = {};
  List<Map<String, dynamic>> _selectedDayEvents = [];
  bool _hasEventForSelectedDate = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = picker.NepaliDateTime.now();
    _pageController = PageController(
      initialPage: _nepaliMonths.indexOf(_nepaliMonths[_selectedDate.month - 1])
    );
    _updateCalendar(_selectedDate);
    _fetchEventsForMonth();
  }

  void _updateCalendar(picker.NepaliDateTime date) {
    picker.NepaliDateTime firstDayOfMonth =
        picker.NepaliDateTime(date.year, date.month, 1);
    picker.NepaliDateTime lastDayOfMonth =
        picker.NepaliDateTime(date.year, date.month + 1, 1)
            .subtract(Duration(days: 1));

    _daysInMonth = List.generate(
      lastDayOfMonth.day,
      (index) => picker.NepaliDateTime(
          date.year, date.month, index + 1),
    );

    _previousMonthDays = [];
    if (firstDayOfMonth.weekday > 1) {
      final previousMonth = date.month - 1 <= 0
          ? picker.NepaliDateTime(date.year - 1, 12, 1)
          : picker.NepaliDateTime(date.year, date.month - 1, 1);
      final lastDayOfPreviousMonth =
          picker.NepaliDateTime(previousMonth.year, previousMonth.month + 1, 1)
              .subtract(Duration(days: 1));
      _previousMonthDays = List.generate(
        firstDayOfMonth.weekday - 1,
        (index) => picker.NepaliDateTime(previousMonth.year,
            previousMonth.month, lastDayOfPreviousMonth.day - index),
      ).reversed.toList();
    }

    _nextMonthDays = [];
    final totalDays = _previousMonthDays.length + _daysInMonth.length;
    final daysInWeek = 7;
    if (totalDays % daysInWeek != 0) {
      final daysToAdd = daysInWeek - (totalDays % daysInWeek);
      final nextMonth = date.month + 1 > 12
          ? picker.NepaliDateTime(date.year + 1, 1, 1)
          : picker.NepaliDateTime(date.year, date.month + 1, 1);
      _nextMonthDays = List.generate(
        daysToAdd,
        (index) =>
            picker.NepaliDateTime(nextMonth.year, nextMonth.month, index + 1),
      );
    }
  }

  Future<void> _fetchEventsForMonth() async {
    final firstDayOfMonth = picker.NepaliDateTime(
        _selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = picker.NepaliDateTime(
        _selectedDate.year, _selectedDate.month + 1, 1)
        .subtract(Duration(days: 1));

    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth.toDateTime())
        .where('date', isLessThanOrEqualTo: lastDayOfMonth.toDateTime())
        .get();

    final eventsMap = <String, List<Map<String, dynamic>>>{};
    for (var doc in querySnapshot.docs) {
      final eventData = doc.data() as Map<String, dynamic>;
      final eventDate = (eventData['date'] as Timestamp).toDate();
      final eventDateKey = picker.NepaliDateTime.fromDateTime(eventDate).toString();
      if (!eventsMap.containsKey(eventDateKey)) {
        eventsMap[eventDateKey] = [];
      }
      eventsMap[eventDateKey]!.add({...eventData, 'id': doc.id});
    }

    setState(() {
      _events = eventsMap;
      _selectedDayEvents = _events[_selectedDate.toString()] ?? [];
      _hasEventForSelectedDate = _selectedDayEvents.isNotEmpty;
    });
  }

  Future<void> _deleteEvent(String eventId) async {
    await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
    _fetchEventsForMonth(); // Refresh events list
  }

  Future<List<Map<String, dynamic>>> _fetchEvents(picker.NepaliDateTime date) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: date.toDateTime())
        .where('date', isLessThan: date.toDateTime().add(Duration(days: 1)))
        .get();

    return querySnapshot.docs.map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id}).toList();
  }

  void _onDateSelected(picker.NepaliDateTime date) async {
    final events = await _fetchEvents(date);
    setState(() {
      _selectedDate = date;
      _selectedDayEvents = events;
      _hasEventForSelectedDate = events.isNotEmpty;
    });
  }

  bool _isSameDay(picker.NepaliDateTime date1, picker.NepaliDateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    picker.NepaliDateTime nepaliToday = picker.NepaliDateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Nepali Calendar (Bikram Sambat)'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height*0.52,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _nepaliMonths.length,
                  itemBuilder: (context, index) {
                    final date = picker.NepaliDateTime(
                      _selectedDate.year,
                      index + 1,
                      _selectedDate.day,
                    );
                    _updateCalendar(date);
                    return Column(
                      children: [
                        _buildMonthHeader(date),
                        SizedBox(height: 12.0),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueAccent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              itemCount: _previousMonthDays.length +
                                  _daysInMonth.length +
                                  _nextMonthDays.length,
                              itemBuilder: (context, index) {
                                final day = index < _previousMonthDays.length
                                    ? _previousMonthDays[index]
                                    : index < _previousMonthDays.length + _daysInMonth.length
                                        ? _daysInMonth[index - _previousMonthDays.length]
                                        : _nextMonthDays[index - _previousMonthDays.length - _daysInMonth.length];
        
                                return _buildDateTile(day, nepaliToday,
                                    isCurrentMonth: index >= _previousMonthDays.length &&
                                                    index < _previousMonthDays.length + _daysInMonth.length);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _selectedDate = picker.NepaliDateTime(
                        _selectedDate.year,
                        index + 1,
                        _selectedDate.day,
                      );
                      _updateCalendar(_selectedDate);
                      _fetchEventsForMonth();
                    });
                  },
                ),
              ),
            ),
            _buildEventList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEvent(date: _selectedDate),
            ),
          );
          _fetchEventsForMonth();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMonthHeader(picker.NepaliDateTime date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '${_nepaliMonths[date.month - 1]} ${date.year}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDateTile(picker.NepaliDateTime date, picker.NepaliDateTime today, {bool isCurrentMonth = true}) {
    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isSameDay(date, today);

    return GestureDetector(
      onTap: () {
        _onDateSelected(date);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue
              : isToday
                  ? Colors.green
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? Colors.white
                        : isCurrentMonth
                            ? Colors.black
                            : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return _selectedDayEvents.isEmpty
        ? Center(child: Text('No events for selected date'))
        : Expanded(
            child: ListView.builder(
              itemCount: _selectedDayEvents.length,
              itemBuilder: (context, index) {
                final event = _selectedDayEvents[index];
                return ListTile(
                  title: Text(event['title'] ?? 'No title'),
                  subtitle: Text(event['description'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteEvent(event['id']);
                    },
                  ),
                );
              },
            ),
          );
  }
}

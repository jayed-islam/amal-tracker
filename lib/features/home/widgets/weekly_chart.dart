import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF3E0);
  static const goldBorder = Color(0xFFFFCC80);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);
  static const textPri = Color(0xFF0A1A0F);
  static const textSec = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const rankGold = Color(0xFFD4A843);
  static const rankSilver = Color(0xFF94A3B8);
  static const rankBronze = Color(0xFFCD7F32);
}

class WeekChart extends StatefulWidget {
  final ProgressSummary? summary;

  const WeekChart({super.key, this.summary});

  @override
  State<WeekChart> createState() => WeekChartState();
}

class WeekChartState extends State<WeekChart> {
  int touchedIndex = -1; // ইউজার কোন বারে টাচ করেছে তার ডাইনামিক ইনডেক্স

  @override
  void initState() {
    super.initState();
    // চার্ট লোড হওয়ার পর ডিফল্টভাবে আজকের দিনটি সিলেক্টেড থাকবে
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.summary != null && widget.summary!.currentWeek.isNotEmpty) {
        // ডাইনামিকালি সপ্তাহের কারেন্ট ডে ইনডেক্স বের করা (যেমন: আজ রবিবার হলে ০, সোমবার হলে ১)
        final todayDay = DateTime.now().weekday % 7;
        setState(() {
          touchedIndex = todayDay;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekData = widget.summary?.currentWeek ?? [];
    if (weekData.isEmpty) return const SizedBox.shrink();

    // গ্রাফের Y-Axis (উচ্চতা) ডাইনামিকালি সেট করার জন্য সর্বোচ্চ পয়েন্ট খুঁজে বের করা
    double maxPoints = 20;
    for (var data in weekData) {
      if (data.points > maxPoints) maxPoints = data.points.toDouble();
    }

    // বর্তমানে সিলেক্টেড বা টাচ করা দিনের ডেটা ফিল্টার
    final selectedData = touchedIndex >= 0 && touchedIndex < weekData.length
        ? weekData[touchedIndex]
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── টপ হেডার সামারি ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'সাপ্তাহিক ট্র্যাকিং অ্যানালিটিক্স',
                    style: TextStyle(
                        color: _C.textPri,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'বারে ট্যাপ করে বিস্তারিত দেখুন',
                    style: TextStyle(color: _C.textSec, fontSize: 11),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _C.greenLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'মোট: ${widget.summary?.weeklyPoints ?? 0} pts',
                  style: const TextStyle(
                      color: _C.midGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // ── প্যাকেজ থেকে আসা ১০০% ডাইনামিক বার চার্ট ──
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxPoints + (maxPoints * 0.15), // টপ স্পেস ডাইনামিক রাখা

                // ১. ডাইনামিক টাচ ইন্টারেকশন ও প্যাকেজ বিল্ট-ইন টুলটিপ
                barTouchData: BarTouchData(
                  handleBuiltInTouches: true,
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      return;
                    }
                    setState(() {
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => _C.darkGreen,
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} Pts',
                        const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
                      );
                    },
                  ),
                ),

                // ২. ডাইনামিক এক্সিস লেবেল (X ও Y Axis)
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= weekData.length) {
                          return const SizedBox.shrink();
                        }
                        final isSelected = index == touchedIndex;

                        // 💡 FIX: axisSide প্যারামিটার যুক্ত করা হয়েছে meta.axisSide থেকে
                        return SideTitleWidget(
                          // meta: meta,
                          axisSide: meta.axisSide,
                          space: 8,
                          child: Text(
                            weekData[index].day,
                            style: TextStyle(
                              color: isSelected ? _C.midGreen : _C.textSec,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),

                // ৩. চার্ট ডিজাইন ও গ্রিড কনফিগারেশন
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),

                // ৪. ডাটা সোর্স থেকে ডাইনামিক বার জেনারেশন
                barGroups: weekData.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final data = entry.value;
                  final isSelected = idx == touchedIndex;

                  // জেন্ডার ও ট্র্যাকিং স্ট্যাটাস অনুযায়ী ডাইনামিক কালার নির্ধারণ
                  Color rodColor = _C.midGreen;
                  if (data.isExemptDay) {
                    rodColor = _C.amber;
                  } else if (data.points == 0) {
                    rodColor = _C.border;
                  }

                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: data.points.toDouble(),
                        color:
                            isSelected ? rodColor.withOpacity(0.75) : rodColor,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                        // 💡 FIX: backDrawRodsData লেটেস্ট স্ট্রাকচার অনুযায়ী পরিবর্তন করা হয়েছে
                        // backDrawRodsData: BackgroundBarChartRodData(
                        //   show: true,
                        //   toY: maxPoints,
                        //   color: _C.pageBg.withOpacity(0.6),
                        // ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: _C.border, height: 1),
          const SizedBox(height: 16),

          // ── ডাইনামিক ইনফরমেশন প্যানেল (জেন্ডার এবং সিলেক্টেড ডে অনুযায়ী চেঞ্জ হবে) ──
          if (selectedData != null) ...[
            Row(
              children: [
                Text(
                  '📊 ${selectedData.day}-বারের আপডেট:',
                  style: const TextStyle(
                      color: _C.textPri,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
                const Spacer(),
                if (selectedData.isExemptDay)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: _C.goldLight,
                        borderRadius: BorderRadius.circular(4)),
                    child: const Text('Exempted Day 🌸',
                        style: TextStyle(
                            color: _C.gold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // কেল্লী ১: ফরজ আমল কাউন্টার (সবার জন্য)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: _C.pageBg,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ফরজ আমল',
                            style: TextStyle(
                                color: _C.textSec,
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(
                          selectedData.hasData
                              ? '${selectedData.fardDone} / ${selectedData.totalFard}'
                              : '--',
                          style: const TextStyle(
                              color: _C.textPri,
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // কেল্লী ২: জেন্ডার অনুযায়ী পরিবর্তনশীল কার্ড (পুরুষদের জামাত / নারীদের সুন্নাত)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: _C.pageBg,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.summary?.userGender == 'female'
                              ? '১২ রাকাত সুন্নাত'
                              : 'জামাতে সালাত',
                          style: const TextStyle(
                              color: _C.textSec,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedData.hasData
                              ? (widget.summary?.userGender == 'female'
                                  ? '${selectedData.sunnahCount} রাকাত'
                                  : '${selectedData.jamatCount} ওয়াক্ত')
                              : '--',
                          style: const TextStyle(
                              color: _C.darkGreen,
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}

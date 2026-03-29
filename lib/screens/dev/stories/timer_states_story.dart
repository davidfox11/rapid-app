import 'package:flutter/material.dart';

import '../../../widgets/data_label.dart';
import '../../../widgets/timer_ring.dart';

/// Timer ring at various states
class TimerStatesStory extends StatelessWidget {
  const TimerStatesStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataLabel('Full time (15s)'),
          SizedBox(height: 12),
          Center(
            child: TimerRing(totalSeconds: 15, remainingSeconds: 15),
          ),
          SizedBox(height: 24),
          DataLabel('Mid game (8s) — amber'),
          SizedBox(height: 12),
          Center(
            child: TimerRing(totalSeconds: 15, remainingSeconds: 8),
          ),
          SizedBox(height: 24),
          DataLabel('Urgent (4s) — red'),
          SizedBox(height: 12),
          Center(
            child: TimerRing(totalSeconds: 15, remainingSeconds: 4),
          ),
          SizedBox(height: 24),
          DataLabel('Critical (1s) — red'),
          SizedBox(height: 12),
          Center(
            child: TimerRing(totalSeconds: 15, remainingSeconds: 1),
          ),
          SizedBox(height: 24),
          DataLabel('Expired (0s)'),
          SizedBox(height: 12),
          Center(
            child: TimerRing(totalSeconds: 15, remainingSeconds: 0),
          ),
          SizedBox(height: 24),
          DataLabel('Different sizes'),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TimerRing(totalSeconds: 15, remainingSeconds: 10, size: 48),
              TimerRing(totalSeconds: 15, remainingSeconds: 7, size: 72),
              TimerRing(totalSeconds: 15, remainingSeconds: 3, size: 96),
            ],
          ),
        ],
      ),
    );
  }
}

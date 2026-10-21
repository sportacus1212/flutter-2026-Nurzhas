// R9: Sealed class for countdown state management
sealed class Countdown {
  const Countdown();
}

class UpcomingCountdown extends Countdown {
  final Duration remaining;
  const UpcomingCountdown(this.remaining);
}

class StartedCountdown extends Countdown {
  final Duration elapsed;
  const StartedCountdown(this.elapsed);
}

class EndedCountdown extends Countdown {
  const EndedCountdown();
}

Countdown calculateCountdown(DateTime scheduledTime) {
  final now = DateTime.now();
  final diff = scheduledTime.difference(now);

  if (diff.isNegative) {
    final pastDuration = diff.abs();
    if (pastDuration.inMinutes <= 60) {
      return StartedCountdown(pastDuration);
    }
    return const EndedCountdown();
  } else {
    return UpcomingCountdown(diff);
  }
}

class Event {
  final int timestamp;
  final String type;
  final int sourceId;
  final int? targetId;
  final int abilityGameId;
  final int? hitType;
  final int? amount;
  final int? unmitigatedAmount;
  final int? multiplier;
  final int? extraAbilityGameId;
  final int? duration;

  Event.fromJson(Map<String, dynamic> json)
    : timestamp = json['timestamp'],
      type = json['type'],
      sourceId = json['sourceID'],
      targetId = json['targetID'],
      abilityGameId = json['abilityGameID'],
      hitType = json['hitType'],
      amount = json['amount'],
      unmitigatedAmount = json['unmitigatedAmount'],
      multiplier = json['multiplier'],
      extraAbilityGameId = json['extraAbilityGameID'],
      duration = json['duration'];
}
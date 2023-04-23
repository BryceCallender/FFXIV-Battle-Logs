class Rankings {
  Map<String, int>? characterRankings;

  Rankings.fromJson(List<dynamic>? json) {
    characterRankings = Map();

    if (json == null || json.length == 0)
      return;

    final roles = json[0]['roles'];

    if (roles != null) {
      final tanks = roles['tanks']['characters'];
      final healers = roles['healers']['characters'];
      final dps = roles['dps']['characters'];

      final characters = []..addAll(tanks)..addAll(healers)..addAll(dps);
      for (var character in characters) {
        if (character['name_2'] != null)
          continue;

        characterRankings![character['name']] = character['rankPercent'];
      }
    }
  }
}
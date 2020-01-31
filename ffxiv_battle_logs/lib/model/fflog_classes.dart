class FFLogReport {
  final int _id;
  final String _title;
  final String _owner;
  final int _start;
  final int _end;
  final int _zone;

  FFLogReport(this._id, this._title, this._owner, this._start, this._end, this._zone);
}

class FFLogZone {

}

class FFLogAccount {

}

class FFLogFight {

}

class FFLogEvents {

}

enum TableView {
  damage_done,
  damage_taken,
  healing,
  casts,
  summons,
  buffs,
  debuffs,
  deaths
}

class FFLogTableView {
  final TableView _tableView;

  FFLogTableView(this._tableView);
}
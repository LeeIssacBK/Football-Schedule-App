


String getKoreanRound(String round) {
  return '${round.replaceAll(RegExp(r'[^0-9]'), '')} 라운드';
}

String getKoreanWeekDay(DateTime date) {
  switch (date.weekday) {
    case 1 :
      return '월';
    case 2 :
      return '화';
    case 3 :
      return '수';
    case 4 :
      return '목';
    case 5 :
      return '금';
    case 6 :
      return '토';
    case 7 :
      return '일';
  }
  throw Exception('not found weekday : ${date.weekday}');
}

String getKoreanStanding(String eng) {
  return eng.replaceAll('W', '승 ').replaceAll('L', '패 ').replaceAll('D', '무 ');
}
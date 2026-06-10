String getChatId(String user1Id, String user2Id) {
    final sorted = [user1Id, user2Id]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

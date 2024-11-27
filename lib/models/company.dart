// models/company.dart

class Company {
  final String stockName;
  final String isin;
  final String status;
  final int askOrd;
  final int askQty;
  final double ask;
  final double bid;
  final int bidQty;
  final int bidOrd; 
  final double close;
  final double last;
  final double change;
  final int trVolume;
  final int volume;
  final double caps;
  final double high;
  final double low;
  final String time;

  Company({
    required this.stockName,
    required this.isin,
    required this.status,
    required this.askOrd,
    required this.askQty,
    required this.ask,
    required this.bid,
    required this.bidQty,
    required this.bidOrd,
    required this.close,
    required this.last,
    required this.change,
    required this.trVolume,
    required this.volume,
    required this.caps,
    required this.high,
    required this.low,
    required this.time,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      stockName: json['referentiel']['stockName'] ?? 'N/A',
      isin: json['referentiel'].get('isin', 'N/A'),
      status: json['status'] ?? 'N/A',
      askOrd: json['limit']?.get('askOrd', 0),
      askQty: json['limit']?.get('askQty', 0),
      ask: (json['limit']?.get('ask') ?? 0).toDouble(),
      bid: (json['limit']?.get('bid') ?? 0).toDouble(),
      bidQty: json['limit']?.get('bidQty', 0),
      bidOrd: json['limit']?.get('bidOrd', 0),
      close: (json['close'] ?? 0).toDouble(),
      last: (json['last'] ?? 0).toDouble(),
      change: (json['change'] ?? 0).toDouble(),
      trVolume: json['trVolume'] ?? 0,
      volume: json['volume'] ?? 0,
      caps: (json['caps'] ?? 0).toDouble(),
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
      time: json['limit']?.get('time', 'N/A'),
    );
  }
}

import 'package:flutter/material.dart';
import 'explore_page.dart';
import 'news_page.dart'; // Assume you have a NewsPage for detailed news
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'candlestick_chart.dart'; // Remove if not needed elsewhere

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ExplorePage(),
    const PortfolioScreen(),
    const NewsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: _currentIndex == 0
          ? AppBar(
              title: const Text(
                'BoursaSmart',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF1E1E1E),
            )
          : null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF00FF80),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'News'),
        ],
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> companies = [];
  bool isLoading = true;
  String errorMessage = '';

  // Market Overview Data
  double totalMarketCap = 0.0;
  double totalVolume = 0.0;
  int totalCompanies = 0;

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    final url = Uri.parse(
        'https://cors-anywhere.herokuapp.com/http://www.bvmt.com.tn/rest_api/rest/market/groups/11,12,52,95,99');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> fetchedCompanies = data['markets'];

        // Calculate Market Overview
        double marketCap = 0.0;
        double volume = 0.0;
        for (var company in fetchedCompanies) {
          marketCap += (company['marketCap'] ?? 0.0).toDouble();
          volume += (company['volume'] ?? 0.0).toDouble();
        }

        setState(() {
          companies = fetchedCompanies;
          totalMarketCap = marketCap;
          totalVolume = volume;
          totalCompanies = fetchedCompanies.length;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data from server';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });
    }
  }

  List<dynamic> get _winners {
    List<dynamic> sorted = List.from(companies);
    sorted.sort((a, b) => (b['change'] ?? 0.0).compareTo(a['change'] ?? 0.0));
    return sorted.take(5).toList(); // Top 5 winners
  }

  List<dynamic> get _losers {
    List<dynamic> sorted = List.from(companies);
    sorted.sort((a, b) => (a['change'] ?? 0.0).compareTo(b['change'] ?? 0.0));
    return sorted.take(5).toList(); // Top 5 losers
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : errorMessage.isNotEmpty
            ? Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : RefreshIndicator(
                onRefresh: fetchCompanies,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Market Overview Section
                      const Text(
                        'Market Overview',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildOverviewCard('Market Cap', 'TND ${_formatNumber(totalMarketCap)}'),
                          _buildOverviewCard('Volume', 'TND ${_formatNumber(totalVolume)}'),
                          _buildOverviewCard('Companies', '$totalCompanies'),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Biggest Winners Section
                      const Text(
                        'Biggest Winners',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: _winners.map((company) => _buildCompanyRow(company)).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Biggest Losers Section
                      const Text(
                        'Biggest Losers',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: _losers.map((company) => _buildCompanyRow(company)).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Latest News Section (Placeholder)
                      const Text(
                        'Latest News',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Here you can integrate a news carousel or list
                      // For demonstration, we'll use a placeholder
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'News Carousel/Feed Here',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  // Helper method to format numbers with commas
  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  // Widget for Market Overview Cards
  Widget _buildOverviewCard(String title, String value) {
    return Expanded(
      child: Card(
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Company Rows
  Widget _buildCompanyRow(dynamic company) {
    final referentiel = company['referentiel'] ?? {};
    final stockName = referentiel['stockName'] ?? 'N/A';
    final change = (company['change'] ?? 0.0).toDouble();
    final lastPrice = (company['last'] ?? 0.0).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Company Info
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/logos/${stockName.toLowerCase().replaceAll(' ', '_')}.png'),
                backgroundColor: Colors.transparent,
                radius: 20,
              ),
              const SizedBox(width: 10),
              Text(
                stockName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          // Change Indicator
          Row(
            children: [
              Icon(
                change >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: change >= 0 ? Colors.greenAccent : Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${change.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: change >= 0 ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Placeholder Screens for Navigation
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Explore Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Portfolio Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'News Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BoursaSmart',
      theme: ThemeData.dark(), // Use a dark theme
      home: const HomePage(),
    );
  }
}

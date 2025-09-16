import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/index.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchResults = [];
  final List<String> _allJobOffers = [
    'Développeur Flutter',
    'Ingénieur DevOps',
    'Designer UI/UX',
    'Chef de projet',
    'Analyste de données',
    'Architecte logiciel',
    'Testeur QA',
    'Product Manager',
    'Data Scientist',
    'Scrum Master',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _performSearch(_searchController.text);
  }

  void _performSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _searchResults.clear();
      } else {
        _searchResults.clear();
        for (String job in _allJobOffers) {
          if (job.toLowerCase().contains(query.toLowerCase())) {
            _searchResults.add(job);
          }
        }
      }
    });
  }

  void _onAudioSearchReceived(String text) {
    _searchController.text = text;
    _performSearch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche d\'emploi'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          children: [
            // Search with Audio
            AudioSearchWidget(
              onSearchTextReceived: _onAudioSearchReceived,
              hintText: 'Rechercher un emploi...',
              textController: _searchController,
              showTextField: true,
            ),

            const SizedBox(height: 20),

            // Search Results
            Expanded(
              child:
                  _searchResults.isEmpty && _searchController.text.isNotEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucun résultat trouvé',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : _searchController.text.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recherchez un emploi en tapant ou en parlant',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.work),
                              title: Text(_searchResults[index]),
                              subtitle: Text('Cliquez pour voir les détails'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Get.snackbar(
                                  'Emploi sélectionné',
                                  _searchResults[index],
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

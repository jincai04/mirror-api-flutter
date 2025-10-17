import 'package:flutter/material.dart';
import '../services/mirror_api_service.dart';

class LiveStatusPage extends StatefulWidget {
  const LiveStatusPage({super.key});

  @override
  State<LiveStatusPage> createState() => _LiveStatusPageState();
}

class _LiveStatusPageState extends State<LiveStatusPage> {
  late MirrorApiService _apiService;
  late Future<Map<String, dynamic>> _gensetData;

  // Replace with your Ngrok URL
  String ngrokUrl = 'https://your-ngrok-url.ngrok.io';
  String utoken = 'mock_utoken_123';
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _utokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _urlController.text = ngrokUrl;
    _utokenController.text = utoken;
    _apiService = MirrorApiService(baseUrl: ngrokUrl);
    _gensetData = _apiService.fetchGensetData(utoken);
  }

  void _updateUrl() {
    setState(() {
      ngrokUrl = _urlController.text;
      utoken = _utokenController.text;
      _apiService = MirrorApiService(baseUrl: ngrokUrl);
      _gensetData = _apiService.fetchGensetData(utoken);
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _gensetData = _apiService.fetchGensetData(utoken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Genset Status'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'Ngrok URL',
                    hintText: 'https://your-ngrok-url.ngrok.io',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _utokenController,
                  decoration: const InputDecoration(
                    labelText: 'User Token (utoken)',
                    hintText: 'mock_utoken_123',
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _updateUrl,
                  child: const Text('Update Configuration'),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<Map<String, dynamic>>(
              future: _gensetData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 64),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _gensetData = _apiService.fetchGensetData(utoken);
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Genset Information',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Genset ID: ${data['genset_id']}'),
                                const SizedBox(height: 8),
                                Text('Status: ${data['status']}'),
                                const SizedBox(height: 8),
                                Text('Power: ${data['power']}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _gensetData = _apiService.fetchGensetData(utoken);
                            });
                          },
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

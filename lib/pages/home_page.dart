import 'package:flutter/material.dart';
import '../main.dart';
import '../services/tvmaze_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _future = TvMazeService.fetchShows();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Skuy Nonton!'), centerTitle: false),
        body: FutureBuilder(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: kRed));
            }
            if (snap.hasError) {
              return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('${snap.error}'),
                TextButton(
                    onPressed: () => setState(() => _future = TvMazeService.fetchShows()),
                    child: const Text('Coba lagi')),
              ]));
            }
            final shows = snap.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16),
              itemCount: shows.length,
              itemBuilder: (_, i) {
                final s = shows[i];
                return _ShowCard(
                  id: s['id'],
                  name: s['name'],
                  image: s['image']?['medium'],
                  rating: s['rating']?['average'],
                );
              },
            );
          },
        ),
      );
}

class _ShowCard extends StatelessWidget {
  final int id;
  final String name;
  final String? image;
  final num? rating;
  const _ShowCard({required this.id, required this.name, this.image, this.rating});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(id: id))),
        child: Container(
          decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(18)),
          clipBehavior: Clip.antiAlias,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: image == null
                    ? const Icon(Icons.image_not_supported, size: 48)
                    : Image.network(image!, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(rating?.toString() ?? '-'),
                ]),
              ]),
            ),
          ]),
        ),
      );
}

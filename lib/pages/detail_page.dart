import 'package:flutter/material.dart';
import '../main.dart';
import '../services/favorite_service.dart';
import '../services/tvmaze_service.dart';

class DetailPage extends StatelessWidget {
  final int id;
  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: TvMazeService.fetchShow(id),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(title: const Text('Detail')),
                body: const Center(child: CircularProgressIndicator(color: kRed)));
          }
          if (snap.hasError) {
            return Scaffold(
                appBar: AppBar(title: const Text('Detail')),
                body: Center(child: Text('${snap.error}')));
          }
          final s = snap.data!;
          final image = s['image']?['original'] ?? s['image']?['medium'];
          final rating = s['rating']?['average'] as num?;
          final genres = (s['genres'] as List).join(', ');
          final summary = (s['summary'] ?? '').toString().replaceAll(RegExp(r'<[^>]*>'), '');
          return Scaffold(
            appBar: AppBar(title: const Text('Detail')),
            body: ListView(children: [
              if (image != null)
                Image.network(image, width: double.infinity, height: 440, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s['name'],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(rating?.toString() ?? '-', style: const TextStyle(fontSize: 16)),
                  ]),
                  const SizedBox(height: 8),
                  Text(genres.isEmpty ? '-' : genres,
                      style: const TextStyle(color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Memutar ${s['name']}...'))),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Nonton'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ValueListenableBuilder(
                      valueListenable: FavoriteService.listenable(),
                      builder: (_, _, _) {
                        final fav = FavoriteService.isFav(id);
                        return Material(
                          color: kCard,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => FavoriteService.toggle(
                                id, s['name'], s['image']?['medium'], rating),
                            child: SizedBox(
                              width: 52,
                              height: 52,
                              child: Icon(fav ? Icons.favorite : Icons.favorite_border,
                                  color: fav ? kRed : Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  const Text('Overview',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(summary, style: const TextStyle(fontSize: 16, height: 1.5)),
                ]),
              ),
            ]),
          );
        },
      );
}

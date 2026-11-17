import 'package:flutter/material.dart';
import '../main.dart';
import '../services/favorite_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Daftar Favorit'), centerTitle: false),
        body: ValueListenableBuilder(
          valueListenable: FavoriteService.listenable(),
          builder: (_, _, _) {
            final favs = FavoriteService.all();
            if (favs.isEmpty) return const Center(child: Text('Belum ada favorit'));
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final f = favs[i];
                return Material(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(14),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: f['image'] == null
                          ? const Icon(Icons.image_not_supported)
                          : Image.network(f['image'], width: 56, height: 64, fit: BoxFit.cover),
                    ),
                    title: Text(f['name'], style: const TextStyle(fontSize: 17)),
                    subtitle: Row(children: [
                      const Icon(Icons.star, size: 15, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${f['rating'] ?? '-'}'),
                    ]),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete, color: kRed),
                        onPressed: () => FavoriteService.remove(f['id'])),
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => DetailPage(id: f['id']))),
                  ),
                );
              },
            );
          },
        ),
      );
}

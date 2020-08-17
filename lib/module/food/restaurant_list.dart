import 'package:flutter/material.dart';

class ExpansionTileSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) =>
          EntryItem(data[index]),
      itemCount: data.length,
    );
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

final List<Entry> data = <Entry>[
  Entry(
    'Commander manuellement',
    <Entry>[
      Entry(
        'Sandwich',
        <Entry>[
          Entry(
            'La Pause Gourmande',
            <Entry>[
              Entry('Boulevard d\'avroy, 82 | 7:30 - 15:00'),
              Entry('Commande par téléphone: 04 222 07 22'),
            ],
          ),
          Entry(
            'Mmmhhh',
            <Entry>[
              Entry('Boulevard d\'avroy, 82 | 9:00 - 14:00'),
              Entry('Commande par téléphone: 08 546 02 06'),
              Entry('Commande par sms: 0499 83 90 73'),
            ],
          ),
          Entry(
            'Au Croc',
            <Entry>[
              Entry('Rue Saint-Gilles, 160 | 10:00 - 16:30'),
              Entry('Commande par téléphone: 04 221 05 33'),
            ],
          ),
          Entry(
            'Bi’Stronome',
            <Entry>[
              Entry('Rue des Clarisses, 58 | 11:00 - 14:30'),
              Entry('Commande par téléphone: 04 243 03 18'),
            ],
          ),
          Entry(
            'Point chaud',
            <Entry>[
              Entry('Rue Pont d\'Avroy 52 | 06:00 - 18:00'),
            ],
          ),
        ],
      ),
      Entry(
        'Sushi',
        <Entry>[
          Entry(
            'Sushi Fuji',
            <Entry>[
              Entry('Rue Saint-Gilles, 5/7 | 11:30 - 14:30'),
              Entry('Commande par téléphone: 04 379 45 76'),
            ],
          ),
          Entry(
            'Sushi King',
            <Entry>[
              Entry('Rue Pont d\'Avroy, 51 | 11:30 - 23:00'),
              Entry('Commande par téléphone: 04 278 22 68'),
            ],
          ),
          Entry(
            'Sushi Maison',
            <Entry>[
              Entry('Boulevard de la Sauvenière, 164 | 11:30 - 14:30 (Ma-Di)'),
              Entry('Commande en ligne: https://sushimaison.shop/menu/'),
              Entry('Commande par téléphone: 04 222 11 88'),
            ],
          ),
          Entry(
            'Sushi Délice',
            <Entry>[
              Entry('Rue du Vertbois, 5 | 11:30 - 14:30'),
              Entry('Commande en ligne: www.sushidelice4000.be'),
              Entry('Commande par téléphone: 04 223 23 23'),
            ],
          ),
          Entry(
            'Yukinii',
            <Entry>[
              Entry('Boulevard d\'Avroy, 3 | 12:00 - 14:30'),
              Entry('Commande en ligne: www.sushidelice4000.be'),
              Entry('Commande par téléphone: 04 250 26 52'),
            ],
          ),
        ],
      ),
      Entry(
        'Pizza',
        <Entry>[
          Entry(
            'Pizzico',
            <Entry>[
              Entry('Rue des Guillemins, 36 | 11:00 - 21:00'),
              Entry('Commande en ligne: www.pizzico-express.be'),
              Entry('Commande par téléphone: 04 360 78 75'),
            ],
          ),
        ],
      ),
      Entry(
        'Fast-food',
        <Entry>[
          Entry(
            'The Huggy\'s Bar',
            <Entry>[
              Entry('Boulevard d\'avroy, 82 | 12:00 - 22:00'),
              Entry('Commande en ligne: www.huggysbar.com'),
            ],
          ),
        ],
      ),
    ],
  ),
];

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
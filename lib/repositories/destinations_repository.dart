import 'package:voyage_jordan2/models/destination.dart';
import 'package:voyage_jordan2/models/destination_detail.dart';

class DestinationsRepository {
  List<Destination> getAll() {
    return const [
      Destination(
        id: 'aqaba',
        name: 'Aqaba',
        subtitle: 'Red Sea Escape',
        description: 'Diving, beach resorts, and waterfront dining.',
        rating: 4.8,
        priceLevel: 'Medium',
        imageUrl: 'assets/images/aqaba.jpg',
      ),
      Destination(
        id: 'wadi-rum',
        name: 'Wadi Rum',
        subtitle: 'Desert Adventure',
        description: 'Jeep tours, stargazing, and Bedouin camps.',
        rating: 4.9,
        priceLevel: 'Medium',
        imageUrl: 'assets/images/wadi_rum.jpg',
      ),
      Destination(
        id: 'petra',
        name: 'Petra',
        subtitle: 'Ancient Wonder',
        description: 'Explore The Treasury, Monastery, and canyons.',
        rating: 5.0,
        priceLevel: 'High',
        imageUrl: 'assets/images/petra.jpg',
      ),
      Destination(
        id: 'jerash',
        name: 'Jerash',
        subtitle: 'Roman Heritage',
        description: 'Archaeological city with remarkable ruins.',
        rating: 4.6,
        priceLevel: 'Low',
        imageUrl: 'assets/images/jerash.webp',
      ),
      Destination(
        id: 'dead-sea',
        name: 'Dead Sea',
        subtitle: 'Relaxation Retreat',
        description: 'Floating experience, mineral mud, and wellness.',
        rating: 4.7,
        priceLevel: 'High',
        imageUrl: 'assets/images/dead_sea.jpg',
      ),
    ];
  }

  DestinationDetail? getDetailById(String destinationId) {
    final data = {
      'petra': const DestinationDetail(
        destinationId: 'petra',
        title: 'Petra',
        heroImageUrl: 'assets/images/petra/petra_1.jpg',
        galleryImageUrls: [
          'assets/images/petra/petra_2.jpg',
          'assets/images/petra/petra_3.webp',
          'assets/images/petra/petra_4.jpg',
        ],
        description:
            "Petra is a historical and archaeological city in southern Jordan. Famous for its rock-cut architecture and water conduit system, Petra is also known as the 'Rose City' due to the color of the stone from which it is carved.",
        bestTimeToVisit: 'March to May, September to November',
        thingsToDo: [
          'Explore the Treasury',
          'Hike to the Monastery',
          'Visit the Royal Tombs',
          'Walk through the Siq',
          'Petra by Night show',
        ],
        whereToStay: [
          'Movenpick Resort Petra',
          'Petra Marriott Hotel',
          'Old Village Hotel & Resort',
        ],
        diningOptions: [
          'The Cave Bar',
          'Al Qantarah Restaurant',
        ],
      ),
      'wadi-rum': const DestinationDetail(
        destinationId: 'wadi-rum',
        title: 'Wadi Rum',
        heroImageUrl: 'assets/images/wadi_rum/wadi_1.jpg',
        galleryImageUrls: [
          'assets/images/wadi_rum/wadi_2.jpg',
          'assets/images/wadi_rum/wadi_3.jpg',
          'assets/images/wadi_rum/wadi_4.jpg',
        ],
        description:
            "Wadi Rum is Jordan's dramatic desert valley known for sandstone mountains, red dunes, and cinematic landscapes.",
        bestTimeToVisit: 'October to April',
        thingsToDo: [
          '4x4 desert jeep tour',
          'Sunset viewpoint stop',
          'Camel ride experience',
          'Stargazing camp night',
          'Bedouin tea session',
        ],
        whereToStay: [
          'Wadi Rum Night Luxury Camp',
          'Memories Aicha Camp',
          'Sun City Camp',
        ],
        diningOptions: [
          'Camp Bedouin buffet',
          'Wadi Rum Rest House',
        ],
      ),
      'dead-sea': const DestinationDetail(
        destinationId: 'dead-sea',
        title: 'Dead Sea',
        heroImageUrl: 'assets/images/dead_sea/dead_1.jpg',
        galleryImageUrls: [
          'assets/images/dead_sea/dead_2.jpg',
          'assets/images/dead_sea/dead_3.jpg',
          'assets/images/dead_sea/dead_4.jpg',
        ],
        description:
            'The Dead Sea is Earth\'s lowest point, famous for salt-rich water, mineral mud, and relaxing wellness resorts.',
        bestTimeToVisit: 'October to May',
        thingsToDo: [
          'Float in the Dead Sea',
          'Mud bath and spa treatment',
          'Sunset viewing',
          'Beach relaxation',
          'Wellness therapy session',
        ],
        whereToStay: [
          'Kempinski Hotel Ishtar Dead Sea',
          'Movenpick Resort & Spa Dead Sea',
          'Hilton Dead Sea Resort & Spa',
        ],
        diningOptions: [
          'Resort dining',
          'Poolside grill',
        ],
      ),
      'aqaba': const DestinationDetail(
        destinationId: 'aqaba',
        title: 'Aqaba',
        heroImageUrl: 'assets/images/aqaba/aqaba_1.jpg',
        galleryImageUrls: [
          'assets/images/aqaba/aqaba_2.jpg',
          'assets/images/aqaba/aqaba_3.jpg',
          'assets/images/aqaba/aqaba_4.jpg',
        ],
        description:
            'Aqaba is Jordan\'s Red Sea city known for beaches, diving, coral reefs, and vibrant waterfront experiences.',
        bestTimeToVisit: 'March to May, October to November',
        thingsToDo: [
          'Snorkeling and diving',
          'Aqaba fort visit',
          'Marina promenade walk',
          'Glass boat tour',
          'Evening seafood dinner',
        ],
        whereToStay: [
          'Hyatt Regency Aqaba',
          'InterContinental Aqaba',
          'Kempinski Aqaba',
        ],
        diningOptions: [
          'Ali Baba Restaurant',
          'Captain\'s Restaurant',
        ],
      ),
      'jerash': const DestinationDetail(
        destinationId: 'jerash',
        title: 'Jerash',
        heroImageUrl: 'assets/images/jerash/jerash_1.jpg',
        galleryImageUrls: [
          'assets/images/jerash/jerash_2.jpg',
          'assets/images/jerash/jerash_3.jpg',
          'assets/images/jerash/jerash_4.jpg',
        ],
        description:
            'Jerash is one of the world\'s best-preserved Roman provincial cities, filled with colonnaded streets and theaters.',
        bestTimeToVisit: 'April to June, September to November',
        thingsToDo: [
          'Oval Plaza exploration',
          'South Theater visit',
          'Hadrian\'s Arch walk',
          'Archaeological museum tour',
          'Jerash festival area',
        ],
        whereToStay: [
          'Olive Branch Hotel',
          'Lijam Hotel',
          'Haddad Tourism Village',
        ],
        diningOptions: [
          'Lebanese House',
          'Jerash Rest Restaurant',
        ],
      ),
    };
    return data[destinationId];
  }
}

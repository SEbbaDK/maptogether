import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

import 'package:client/quests/simple_tag_quest.dart';
import 'package:client/quests/quest.dart';
import 'package:client/quests/quest_finder.dart';

class BuildingTypeQuestFinder implements QuestFinder {
  @override
  Quest construct(osm.Element e) => BuildingTypeQuest(e);
    
  @override
  bool applicable(osm.Element e) =>
  	e.isWay &&
  	e.tags['building'] == "yes";
}

class BuildingTypeQuest extends SimpleTagQuest {
  BuildingTypeQuest(osm.Element element) : super(element);

  String tag() => 'building';

  @override
  String question() => "What type of building is this?";

  @override
  String changesetComment() => "Added buildingtype tag to a building";

  @override
  Widget icon() => Icon(Icons.house);

  @override
  Map<String, String> possibilitiesToTags() => {
        //Accomodation
        'Apartments': 'apartments',
        'Bungalow': 'bungalow',
        'Cabin': 'cabin',
        'Detached': 'detached',
        'Dormitory': 'dormitory',
        'Farm': 'farm',
        'Ger': 'ger',
        'Hotel': 'hotel',
        'House': 'house',
        'Houseboat': 'houseboat',
        'Residential': 'residential',
        'Semidetached house': 'semidetached_house',
        'Static caravan': 'static_caravan',
        'Terrace': 'terrace',
        // Commercial
        'Commercial': 'commercial',
        'Industrial': 'industrial',
        'Kiosk': 'kiosk',
        'Office': 'office',
        'Retail': 'retail',
        'Supermarket': 'supermarket',
        'Warehouse': 'warehouse',
        // Religious
        'Cathedral': 'cathedral',
        'Chapel': 'chapel',
        'Church': 'church',
        'Monastery': 'monastery',
        'Mosque': 'mosque',
        'Presbytery': 'presbytery',
        'Religious': 'religious',
        'Shine': 'shine',
        'Synagogue': 'synagogue',
        'Temple': 'temple',
        //Civic/Amenity
        'Bakehouse': 'bakehouse',
        'Civic': 'civic',
        'Fire station': 'fire_station',
        'Government': 'government',
        'Hospital': 'hospital',
        'Public': 'public',
        'Toilets': 'toilets',
        'Train station': 'train_station',
        'Transportation': 'transportation',
        'Kindergarten': 'kindergarten',
        'School': 'school',
        'University': 'university',
        'College': 'college',
        //Agriculture
        'Barn': 'barn',
        'Conservatory': 'conservatory',
        'Cowshed': 'cowshed',
        'Farm auxiliary': 'farm_auxiliary',
        'Greenhouse': 'greenhouse',
        'Slurry tank': 'slurry_tank',
        'Stable': 'stable',
        'Sty': 'sty',
        //spots
        'Grandstand': 'grandstand',
        'Pavilion': 'pavilion',
        'Riding hall': 'riding_hall',
        'Sports hall': 'sports_hall',
        'Stadium': 'stadium',
        //Storage
        'Hangar': 'hangar',
        'Hut': 'hut',
        'Shed': 'shed',
        //Cars
        'Carport': 'carport',
        'Garage': 'garage',
        'Garages': 'garages',
        'Parking': 'parking',
        //Power
        'Digester': 'digester',
        'Service': 'service',
        'Transformer tower': 'transformer_tower',
        'Water tower': 'water_tower',
        //Other
        'Military': 'military',
        'Bunker': 'bunker',
        'Bridge': 'bridge',
        'Construction': 'construction',
        'Container': 'container',
        'Gatehouse': 'gatehouse',
        'Roof': 'roof',
        'Ruins': 'ruins',
        'Tree house': 'tree_house',
      };
}

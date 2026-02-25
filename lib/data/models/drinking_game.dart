import 'package:json_annotation/json_annotation.dart';

part 'drinking_game.g.dart';

@JsonSerializable()
class DrinkingGame {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int minPlayers;
  final int maxPlayers;
  final String category;
  final List<String> rules;
  final List<GameCard> cards;

  const DrinkingGame({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.minPlayers,
    required this.maxPlayers,
    required this.category,
    required this.rules,
    required this.cards,
  });

  factory DrinkingGame.fromJson(Map<String, dynamic> json) =>
      _$DrinkingGameFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkingGameToJson(this);
}

@JsonSerializable()
class GameCard {
  final String text;
  final String? action;
  final int? sips;

  const GameCard({
    required this.text,
    this.action,
    this.sips,
  });

  factory GameCard.fromJson(Map<String, dynamic> json) =>
      _$GameCardFromJson(json);

  Map<String, dynamic> toJson() => _$GameCardToJson(this);
}

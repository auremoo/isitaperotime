import 'package:json_annotation/json_annotation.dart';

part 'cocktail.g.dart';

@JsonSerializable()
class Cocktail {
  final String name;
  final String description;
  @JsonKey(name: 'nb_person')
  final int nbPerson;
  final List<String> recipe;
  final Map<String, String> ingredients;

  const Cocktail({
    required this.name,
    required this.description,
    required this.nbPerson,
    required this.recipe,
    required this.ingredients,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) =>
      _$CocktailFromJson(json);

  Map<String, dynamic> toJson() => _$CocktailToJson(this);

  Set<String> get ingredientNames =>
      ingredients.keys.map((k) => k.toLowerCase()).toSet();
}

extends Item
class_name Jar

enum JarType {
  POT,
  HOLLOW,
  CRYSTALLIZER,
  SYNTHESIZER
}

@export var jar_type: JarType

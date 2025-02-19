extends Resource
class_name LambdaCardDataResource

enum expression_type {
	Variable,
	Abstraction,
	Application
}

@export var id : String = ""
@export var type : expression_type
@export var expression : String = ""
@export var icon : String = ""

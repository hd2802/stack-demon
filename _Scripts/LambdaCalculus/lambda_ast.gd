extends RefCounted
class_name LambdaAST

class LambdaTerm:
	func _to_string() -> String:
		return "LambdaTerm"

class Variable extends LambdaTerm:
	var name: String
	func _init(n: String):
		name = n

	func _to_string() -> String:
		return name

class Abstraction extends LambdaTerm:
	var param: String
	var body: LambdaTerm
	func _init(p: String, b: LambdaTerm):
		param = p
		body = b

	func _to_string() -> String:
		return "(λ%s. %s)" % [param, body._to_string()]

class Application extends LambdaTerm:
	var function: LambdaTerm
	var arg: LambdaTerm
	func _init(f: LambdaTerm, a: LambdaTerm):
		function = f
		arg = a

	func _to_string() -> String:
		return "(%s %s)" % [function._to_string(), arg._to_string()]

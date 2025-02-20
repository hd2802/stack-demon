extends RefCounted
class_name LambdaParser

var tokens: PackedStringArray
var index: int = 0

const LambdaAST = preload("res://_Scripts/LambdaCalculus/lambda_ast.gd")

func parse(input: String) -> LambdaAST.LambdaTerm:
	tokens = tokenize(input)
	index = 0
	return parse_expression()

func tokenize(input: String) -> PackedStringArray:
	var regex = RegEx.create_from_string(r"λ|\\|[a-zA-Z_][a-zA-Z0-9_]*|\.|\(|\)")
	var result = regex.search_all(input)
	var token_list = []
	for r in result:
		token_list.append(r.get_string())
	return token_list

func parse_expression() -> LambdaAST.LambdaTerm:
	var term = parse_term()
	while index < tokens.size() and tokens[index] != ")":
		var next_term = parse_term()
		term = LambdaAST.Application.new(term, next_term)
	return term

func parse_term() -> LambdaAST.LambdaTerm:
	if index >= tokens.size():
		return null

	var token = tokens[index]
	index += 1
	
	if token == "λ" or token == "\\":
		var param = tokens[index]
		index += 1
		assert(tokens[index] == ".", "Expected '.' after lambda parameter")
		index += 1
		var body = parse_expression()
		return LambdaAST.Abstraction.new(param, body)
	elif token == "(":
		var expr = parse_expression()
		assert(tokens[index] == ")", "Expected closing parenthesis")
		index += 1
		return expr
	else:
		return LambdaAST.Variable.new(token)

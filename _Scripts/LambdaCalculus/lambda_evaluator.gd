extends RefCounted
class_name LambdaEvaluator

const LambdaAST = preload("res://_Scripts/LambdaCalculus/lambda_ast.gd")

func evaluate(term: LambdaAST.LambdaTerm) -> LambdaAST.LambdaTerm:
	var reduced = beta_reduce(term)
	while reduced != term:
		term = reduced
		reduced = beta_reduce(term)
	return reduced

func beta_reduce(term: LambdaAST.LambdaTerm) -> LambdaAST.LambdaTerm:
	if term is LambdaAST.Application:
		var function = beta_reduce(term.function)
		var arg = beta_reduce(term.arg)
		
		if function is LambdaAST.Abstraction:
			return substitute(function.body, function.param, arg)
		
		return LambdaAST.Application.new(function, arg) # Otherwise, keep as application
	
	elif term is LambdaAST.Abstraction:
		# Reduce body of abstraction
		var reduced_body = beta_reduce(term.body)
		return LambdaAST.Abstraction.new(term.param, reduced_body)

	return term 

func substitute(body: LambdaAST.LambdaTerm, param: String, replacement: LambdaAST.LambdaTerm) -> LambdaAST.LambdaTerm:
	if body is LambdaAST.Variable:
		return replacement if body.name == param else body
	
	elif body is LambdaAST.Abstraction:
		if body.param == param:
			return body 
		var new_body = substitute(body.body, param, replacement)
		return LambdaAST.Abstraction.new(body.param, new_body)

	elif body is LambdaAST.Application:
		var new_func = substitute(body.function, param, replacement)
		var new_arg = substitute(body.arg, param, replacement)
		return LambdaAST.Application.new(new_func, new_arg)

	return body

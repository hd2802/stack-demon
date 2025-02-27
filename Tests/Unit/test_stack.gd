extends GutTest

var stack : Stack

func before_each():
	stack = Stack.new()
	add_child(stack)

#----------------------------------------------------------------

func test_push():
	stack.push("5")
	assert_eq(stack.stack.size(), 1, "Stack should have one element")
	assert_eq(stack.stack_top, "5", "Top of the stack should be '5'")

	stack.push("3")
	assert_eq(stack.stack.size(), 2, "Stack should have two elements")
	assert_eq(stack.stack_top, "3", "Top of the stack should be '3'")
	assert_eq(stack.stack_second, "5", "Second of the stack should be '5'")

#----------------------------------------------------------------

func test_is_operation():
	assert_true(stack.is_operation("+"), "'+' should be an operation")
	assert_true(stack.is_operation("-"), "'-' should be an operation")
	assert_false(stack.is_operation("5"), "'5' should not be an operation")
	assert_false(stack.is_operation("hello"), "'hello' should not be an operation")

#----------------------------------------------------------------

func test_calculator_add():
	assert_eq(stack.calculator("+", "3", "7"), 10, "3 + 7 should equal 10")

func test_calculator_subtract():
	assert_eq(stack.calculator("-", "10", "4"), 6, "10 - 4 should equal 6")

func test_calculator_multiply():
	assert_eq(stack.calculator("*", "3", "3"), 9, "3 * 3 should equal 9")

func test_calculator_divide():
	assert_eq(stack.calculator("/", "10", "2"), 5, "10 / 2 should equal 5")

func test_calculator_divide_by_zero():
	assert_eq(stack.calculator("/", "0", "10"), 0, "Division by zero should return 0")

#----------------------------------------------------------------

func test_stack_calculation():
	stack.push("4")
	stack.push("5")
	stack.push("+")
	stack._on_stack_calculation_button_pressed()

	assert_eq(stack.stack.size(), 1, "Stack should have one element after calculation")
	assert_eq(stack.stack_top, "9", "Result should be 9")

#----------------------------------------------------------------

func test_clear():
	stack.push("4")
	stack.push("5")
	stack.clear_stack()

	assert_eq(stack.stack.size(), 0, "Stack should be empty after clear")
	assert_eq(stack.stack_top, "", "Top should be empty string")
	assert_eq(stack.stack_second, "", "Second should be empty string")

#----------------------------------------------------------------

func after_each():
	stack.queue_free()

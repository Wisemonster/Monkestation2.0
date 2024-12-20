/*
 * BlockDefinition
 * An object representing a set of actions to perform independently from the rest of the script. Blocks are basically just
 * lists of statements to execute which also contain some local variables and methods. Note that since functions are local to a block,
 * it is possible to have a function definition inside of any type of block (such as in an if statement or another function),
 * and not just in the global scope as in many languages.
 */
/datum/node/BlockDefinition
	var/list/statements = new
	var/list/functions = new
	var/list/initial_variables = new

/**
 * SetVar
 * Defines a permanent variable. The variable will not be deleted when it goes out of scope.
 *
 * Notes:
 * Since all pre-existing temporary variables are deleted,
 * it is not generally desirable to use this proc after the interpreter has been instantiated.
 * Instead, use <n_Interpreter.SetVar()>.
 *
 * See Also:
 * - <n_Interpreter.SetVar()>
 */
/datum/node/BlockDefinition/proc/SetVar(name, value)
	initial_variables[name] = value

/**
 * Globalblock
 * A block object representing the global scope
 */
/datum/node/BlockDefinition/GlobalBlock

/datum/node/BlockDefinition/GlobalBlock/New()
	initial_variables["null"] = null
	return ..()

/**
 * FunctionBlock
 * A block representing a function body.
 */
/datum/node/BlockDefinition/FunctionBlock

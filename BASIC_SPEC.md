# BASIC Specification

This document describes the specification for the BASIC interpreter. This project targets [Minimal BASIC, ECMA-55](https://ecma-international.org/publications-and-standards/standards/ecma-55/) standard. The following sections is a concise, short paraphrased summary of the official standard.


## Scope

This standard establishes:
- The syntax of a program written in Minimal BASIC.
- The semantic rules for interpreting the meaning of a program written in Minimal BASIC.
- The errors and exceptional circumstances which shall be detected and also the manner in which such errors and exceptional circumstances shall be handled.


## Definitions

For the purposes of this standard, the following terms have their meaning defined as follows:

### BASIC
Acronym for Beginner's All-purpose Symbolic Instruction Code. A family of programming languages which possess a simple, easy-to-learn syntax and semantics.

### End-of-line
The character(s) or indicator which identifies the end of a line. Three kinds of lines can be distinguished: program lines, print lines, and input reply lines.

### Error
A flaw in the syntax of a program which causes the program to be incorrect.

### Exception
A rare condition which occurs during the execution of a program which is not normally anticipated by the programmer. An exception may be a result of faulty data, computations, or exceeding resource constraints.

Exception can be categorized into two types: Nonfatal exception may be safely recovered from with specific procedures. Fatal exceptions are handled by terminating the program.

### Identifier
A character string used to name a variable or a function.

### Batch-mode
An execution environment that does not allow the user to interact with the program.

### Interactive mode
An interactive environment where the user can enter and execute BASIC programs.

### Keyword
A character string, which provides a distinctive identification of a statement or a component of a statement of a programming language.

The keywords in Minimal BASIC are: BASE, DATA, DEF, DIM, END, FOR, GO, GOSUB, GOTO, IF, INPUT, LET, NEXT, ON, OPTION, PRINT, RANDOMIZE, READ, REM, RESTORE, RETURN, STEP, STOP, SUB, THEN and TO.

### Line
A single sequence of characters which terminates with an end-of-line.

### Nesting
A set of statements is nested within another set of statements when:
- The nested set is physically contiguous.
- The nesting set is non-null.

In simple terms:
- Nested statements must appear together in sequence, with no unrelated statements between them. 
- The code block of the outer statement (e.g. `FOR ... NEXT`, or `IF ... THEN`) must not be empty.

### Significant digits
Significant digits are all the digits in a number that carry meaningful information about its precision, including all non-zero digits, any zeros between them, and trailing zeros after a decimal point.

Examples:
*   `123.45` has 5 significant digits.
*   `0.00678` has 3 significant digits (leading zeros are not significant).
*   `900.0` has 4 significant digits (trailing zeros after a decimal point are significant).

### Truncation
The process of rounding a higher precision number to a lower precision number by removing the least significant digits from the original number.

Example: 123.456 -> truncate decimal digits -> 123


## Characters and strings

### General description
The character set for Minimal BASIC is the ECMA 7-bit coded character set. Strings are sequences of characters of characters and are used in BASIC programs as comments, string constants, or data.

### Syntax
1. letter = A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P/Q/R/S/T/U/V/W/X/Y/Z
2. digit = 0/1/2/3/4/5/6/7/8/9
3. string-character = quotation-mark / quoted-string-character
4. quoted-string-character = exclamation-mark / number-sign / dollar-sign / percent-sign / ampersand / apostrophe / left-parenthesis / right-parenthesis / asterisk / comma / solidus / colon / semi-colon / less-than-sign / equals-sign / greater-than-sign / question-mark / circumflex-accent / underline / unquoted-string-character
5. unquoted-string-character = space / plain-string-character
6. plain-string-character = plus-sign / minus-sign / full-stop / digit / letter
7. remark-string = string-character*
8. quoted-string = quotation-mark quoted-string-character* quotation-mark
9. unquoted-string = plain-string-character / plain-string-character unquoted-string-character* plain-string-character

### Examples
Remark (comment)
```basic
ANY CHARACTERS AT ALL (?!*!!) CAN BE USED IN A "REMARK".
```

Quoted string
```basic
"SPACES AND COMMAS CAN OCCUR IN QUOTED STRINGS"
```

Unquoted string
```basic
COMMAS CANNOT OCCUR IN UNQUOTED STRINGS.
```

### Exceptions
None


## Programs

### General description
BASIC is a line-oriented programming language. A BASIC program is a sequence of line statements, where each statement includes a keyword, and ends in an end-of-line. 

### Syntax
1. program = block* end-line
2. block = (line/for-block)*
3. line = line-number statement end-of-line
4. line-number = digit digit? digit? digit?
5. end-of-line = \n
6. end-line = line-number end-statement end-of-line
7. end-statement = END
8. statement = data-statement / def-statement / dimension -statement / gosub-statement / goto-statement / if-then-statement / input-statement / let-statement / on-goto-statement / option-statement / print-statement / randomize-statement / read-statement / remark-statement / restore-statement / return-statement / stop-statement

### Examples
999 END

### Semantics
A BASIC program consists of a sequence of lines ordered by line-numbers, where the last line contains an end-statement. Lines are executed in sequential order, starting with the first line, until
- a control statement point to some other line, or
- a fatal exception occurs, resulting in the program termination, or
- a stop-statement or end-statement is executed.

Spaces may be used to improve the appearance and readability of the program. By default, a space does not affect the execution of the program. Spaces may not appear:
- at the beginning of a line
- within keywords
- within numeric constants
- within line numbers
- within function or variables names
- within two-character relation symbols

All keywords in a program must have at leasat one space before and after them. An exception is an end-of-line, where the space is not required.

Each line must begin with a line-number. The line-number must be a positive integer. Leading zeros have no effect. Statements are executed in ascending line-number order, unless control flow alters the execution order of the program.

Lines may contain up to 255 characters. The end-of-line character is not included in the line length.

The end-statement marks the end of a program, and also terminates the execution of the program when encountered.

### Exceptions
None


## Constants

### General description
Constants can denote both scalar numeric values and string values.

A numeric-constant is a decimal representation of a number. Numeric constants can be optionally signed. There are four general syntactic forms for numeric constants:
- implicit point unscaled representation    sd...d 
- explicit point unscaled representation    sd..drd..d 
- implicit point scaled representation      sd..dEsd..d 
- explicit point scaled representation      sd..drd..dEsd..d 

where:
- d is a decimal digit (0-9)
- r is a full stop (.)
- s is an optional sign (+ or -)
- E is the explicit character (E)

A string-constant is a character string enclosed in quotation marks.

### Syntax
1. numeric-constant = sign? numeric-rep
2. sign = plus-sign / minus-sign
3. numeric-rep = significand exponent?
4. significand = integer full-stop / integer? fraction
5. integer = digit digit*
6. fraction = full-stop digit digit*
7. exponent = E sign? integer
8. string-constant = quoted-string

### Examples
- implicit point unscaled representation    (123, +45, -9)
- explicit point unscaled representation    (3.141, +0.6, -100.0, .75, 3.)
- implicit point scaled representation      (123E4, +50E-1, -99E+0)
- explicit point scaled representation      (6.02E23, 1.23456E-6, -5E+10, .4E-1)
- string-constant                           ("Hello, World!", "X - 3B2", "1E10")

### Semantics
The value of a numeric-constant is the number represented by it. "E" stands for "times ten to the power of". If no sign follows the symbol "E", then a plus sign is interpreted as the sign. There must be no spaces in numeric-constants.

Numeric-constants can have an arbitrary number of digits in the exponent, though values outside the range of 1E-38 to 1E+38 are treated as exceptions. Constants whose magnitudes are less than machine infinitesimal are be replaced by zero, while constants whose magnidutes are larger than machine infinity cause an overflow.

The value of a string-constant consists of all the characters between the quotation-marks, spaces included. The length of a string-constant (the number of characters within quotation-marks) is limited only by the length of a line.

### Exceptions
The evaluation of a numeric-constant may result in a nonfatal overflow. The recommended recovery procedure is to supply machine infinity with the appropriate sign and continue the execution of the program.

## Variables

### General description

Variables can contain either numeric or string values. In the case of numeric values, the can be either a simple variable or a reference to 1/2-dimensional arrays. Such references are called *subscripted variables*.

Simple numeric variables are named by a a single letter, followed by an optional digit.

Subscripted numeric variables are named by a letter, followed by one or two numeric expressions within parentheses.

String variables are named by a letter followed by a dollar sign.

Explicit declarations of variables types are not required. The variable name itself is used to distinguish between the different variable types.

### Syntax
1. variable = numeric-variable / string-variable
2. numeric-variable = simple-numeric-variable / numeric-array-element
3. simple-numeric-variable = letter digit?
4. numeric-array-element = numeric-array-name subscript
5. numeric-array-name = letter
6. subscript = left-parenthesis numeric-expression (comma numeric-expression)? right-parenthesis
7. string-variable = letter dollar-sign

### Examples
- simple numeric variable   X
- simple numeric variable   A5
- numeric array element     A(1)
- numeric array element     A(1+2,2)
- string variable           B$

### Semantics
At a single point in time, a variable can refer to only a single numeric or string value. The value associated with a variable may be changed during the execution of the program.

The length of the string variable value is limited to maximum 18 characters.

Simple-numeric-variables and string-variables are implicitly declared by their respective naming conventions (see [Variables](#variables))

A subscripted variable refers to the element in the 1/2-dimensional array selected by the value(s) of the subscript(s). The value of each subscript is rounded to the nearest integer. Unless explicitly declared in a dimension statement, subscripted variables are implicitly declared by their first appearance in a program. The range of each subscript is 0-10 inclusive, unless an option-statement indicates a 1-10 inclusive range. Subscript expressions must have values with the required range.

The same letter must not be the name of both a simple variable and an array, nor the name of both a 1-dimensional and 2-dimensional array.

There is no collision between the names of a numeric-variable and a string-variable whose names differ only by the dollar-sign (A <> A$).

### Exceptions
- Calling an array with a subscript, that is not in the range of the explicit or implicit dimensions of the array (fatal)

### Remarks
It is recommended that all variables are initialized as undefined. By this means, an exception will result if the program attempts to access the value of a variable, before that variable has been explicitly assigned a value.

Example:
No exception
```basic
DIM A(10)
A(1) = 1
```

Exception should occur
```basic
A(1) = 1
DIM A(10)
```


## Expressions

### General description
Expression are either numeric-expressions or string-expressions.

Numeric-expressions may be constructed from variable, constants, and function references using the operations of addition, substraction, multiplication, division and exponentiation.

String-expressions are composed of either a string-variable or a string-constant.

### Syntax

1. **expression** = numeric-expression / string-expression
2. **numeric-expression**= sign? term (sign term)*
3. **term** = factor (multiplier factor)*
4. **factor** = primary (circumflex-accent primary)*
5. **multiplier** = asterisk / solidus
6. **primary** = numeric-variable / numeric-rep / numeric-function-ref / left-parenthesis numeric-expression right-parenthesis
7. **numeric-function-ref** = numeric-function-name argument-list?
8. **numeric-function-name** = numeric-defined-function / numeric-supplied-function
9. **argument-list** = left-parenthesis argument right-parenthesis
10. **argument** = numeric-expression
11. **string-expression** = string-variable / string-constant

### Examples
- numeric expression                    3*X - Y^2
- numeric expression with arrays        A(1) + A(2) + A(3)
- numeric expression with parentheses   2^(-X)
- function reference                    SQR(X^2 + Y^2)

### Semantics
The evaluation of numeric-expressions follows normal mathematical rules. The symbols circumflex-accent, asteriks, solidus, plus-sign, and minus-sign represent the operations of exponentiation, multiplication, division, addition, and subtraction, respectively. Unless parentheses dictate otherwise, exponentiations are performed first, then multiplication and divisions, and finally additions and subtractions. Operations of the same precendence are executed from left to right.

A-B-C is interpreted as (A-B)-C, A^B^C as (A^B)^C, A/B/C as (A/B)/C, and -A^B as -(A^B).

If an underflow occurs during the evaluation of a numeric-expression, then the value must be replaced by zero.

0^0 is defined to be 1, as in ordinary mathematical usage.

When parentheses are not present, and if the mathematical operators used are either [associative](https://en.wikipedia.org/wiki/Associative_property), [commutative](https://en.wikipedia.org/wiki/Commutative_property) or both, then evaluation of expressions may be reordered to optimize the performance of the code.

In a function reference, the number of arguments passed to the function must match the number of arguments declared in the function definition.

Functions are predefined algorithms, into which the optional argument(s) may be substituted for the parameter(s) used in the function definition. All function references must be either implementation-supplied or defined by the user in a def-statement. The evaluation of the function results in a scalar numeric values which replaces the function reference in the expression.

### Exceptions
- Evaluation of an expression results in division by zero (nonfatal, the recommended recovery procedure is to supply machine infinity with the sign of the numerator and continue).
- Evaluation of an expression results in an overflow (nonfatal, the recommended recovery procedure is to supply machine infinity with the algebraically correct sign and continue).
- Evaluation of the operation of exponentiation results in a negative number being raised to a non-integral power (fatal)
- Evaluation of the operation of exponentiation results in zero being raised to a negative value (nonfatal, the recommended recovery procedure is to supply positive machine infinity and continue)

### Remarks
The accuracy of expression evaluation is implementation-specific. Recommended practive is at least six significant decimal digits of precision.

The method of exponentiation evaluation depends on whether or not the exponent is an integer. If it is, then the indicated number of multiplications may be performed; if not, the the expressions may be evaluated using the LOG and EXP functions (see [Implementation supplied function](#implementation-supplied-functions)).

It is recommended that implementations report underflow as an exception, and continue.

## Implementation supplied functions

### General description
Predefined algorithms are supplied by the implementation for the evaluation of commonly used numeric functions.

### Syntax
1. numeric-supplied-function = ABS / ATN / COS / EXP / INT / LOG / RND / SGN / SIN / SQR / TAN

### Examples
None

### Semantics
The values of the functions, and their arguments, are described in a table below. In all cases, X stands for a numeric expression.

| Function | Function value |
|----------|-----------------|
| **ABS(X)**   | The absolute value of X. |
| **ATN(X)**   | The arctangent of X in radians, i.e. the angle whose tangent is X. The range of the function is −(pi/2) < ATN(X) < (pi/2), where pi is the ratio of the circumference of a circle to its diameter. |
| **COS(X)**   | The cosine of X, where X is in radians. |
| **EXP(X)**   | The exponential of X, i.e. the value of the base of natural logarithms (e = 2.71828...) raised to the power X; if EXP(X) is less than machine infinitesimal, then its value shall be replaced by zero. |
| **INT(X)**   | The largest integer not greater than X; e.g. INT(1.3) = 1 and INT(-1.3) = -2. |
| **LOG(X)**   | The natural logarithm of X; X must be greater than zero. |
| **RND(X)**   | The next pseudo-random number in an implementation-supplied sequence of pseudo-random numbers uniformly distributed in the range 0 <= RND < 1. |
| **SGN(X)**   | The sign of X: -1 if X < 0, 0 if X = 0, and +1 if X > 0. |
| **SIN(X)**   | The sine of X, where X is in radians. |
| **SQR(X)**   | The nonnegative square root of X; X must be nonnegative. |
| **TAN(X)**   | The tangent of X, where X is in radians. |

### Exceptions
- The value of the argument of the LOG function is zero or negative (fatal)
- The value of the argument of the SQR is negative (fatal)
- The magnitude of the value of the exponentiaöl or tangent function is larger than machine infinity (nonfatal, the recommended recovery procedure is to supply machine infinity with the appropriate sign and continue).

### Remarks
The RND function will generatethe same sequence of pseudo-random numbers each time the program is run, unless a randomize-statement is provided (see [RANDOMIZE statement](#randomize-statement)).

It is recommended that if the exponential function is less than machine infinitesimal, implementations report underflow as an exception, and continue.


## User defined functions

### General description
BASIC allows the programmer to define new functions to the program, in addition to the predefined functions.

The general form of statements for defining functions is 
```basic
DEF FNx = expression -- or
DEF FNx(parameter) = expression
```
where x is a single letter and a parameter is a simple numeric-variable.

### Syntax
1. def-statements = DEF numeric-defined-function parameter-list? equals-sign numeric-expression
2. numeric-defined-function = FN letter
3. parameter-list = left-parenthesis parameter (comma parameter)* right-parenthesis
4. parameter = simple-numeric-variable

### Examples
```basic
DEF FNF(X) = X^4 - 1
DEF FNP = 3.14159
DEF FNA(X) = A*X + B
```

### Semantics
A function definition the evaluations of itself, in terms of its parameters. When the function is references, i.e. an expression with a reference to the function is evaluated, the following steps are performed:
- Expression(s) within argument list are evaluated and their results are assigned to the parameters in the parameter-list.
- The expression in the function-definition is evaluated, and gets assigned as the value of the function.

A parameter in the parameter-list of a function definition is local, i.e. it is different from any other variable with the same name outside of the function definition. Variables not present in the parameter-list are variables with the same name, defined outside of that function.

FIXME: A function definition must occur in a lower numbered line than that of the first reference to that function. The expression in a def-statement is not evaluated until the function is referenced.

If ther execution of a program reaches a line with a def-statement, then it skips that line and continues from the following line with no other effect.

A function definition may refer to other defined functions, but not to itself. A function can be defined at most once in a program.

### Exceptions
None


## LET statement

### General description
A let-statement assigns a value to a variable. The general syntactic form of a let-statement is:
```basic
LET variable = expression
```

### Syntax
1. let-statement = numeric-let-statement / string-let-statement
2. numeric-let-statement = LET numeric-variable equals-sign numeric-expression
3. string-let-statement = LET string-variable equals-sign string-expression

### Examples
```basic
LET P = 3.14159
LET A(X,3) = SIN(X)*Y + 1

LET A$ = "Hello, World!"
LET B$ = C$
```

### Semantics
The expression is evaluated (see [Expressions](#expressions)) and the result is assigned to the variable to the left of the equals-sign.

### Exceptions
- A string literal contains too many characters (fatal)


## Control flow statements

### General description
Control statements allow for the interruption of the normal sequence of statement execution by jumping to a different line of the program.

The if-then-else-statement
    IF exp11 rel1 exp12 THEN statement1
    (ELSE IF exp21 rel2 exp22 THEN statement2)+
    (ELSE statement3)?

The stop-statement
    STOP
allows for program termination.

### Syntax
1. if-then-else-statement = if-then-statement else-if-block* else-block?
2. if-then-statement = IF relational-expression THEN statement
3. else-if-block = ELSE IF relational-expression THEN statement
4. else-block = ELSE statement
5. relational-expression = numeric-expression relation numeric-expression / string-expression equality-relation string-expression
6. relation = equality-relation / less-than-sign / greater-than-sign / less-than-or-equal-sign / greater-than-or-equal-sign
7. equality-relation = equals-sign / not-equals-sign
8. less-than-or-equal-sign = less-than-sign / equals-sign
9. greater-than-or-equal-sign = greater-than-sign / equals-sign
10. stop-statement = STOP

### Examples
```basic
IF X > 0 THEN PRINT "X is positive"

IF X > 0 THEN PRINT "X is positive" 
ELSE PRINT "X is not positive"

IF X > 0 THEN PRINT "X is positive"
ELSE IF X < 0 THEN PRINT "X is negative"
ELSE PRINT "X is zero"

STOP
```

### Semantics
If the value of the relational-expression in an if-then-else-statemnt is true, then the statement of the corresponding block is executed. Otherwise, the program continues with the next line.

The relation "less than or equal to" is denoted by the symbol `<=`. The relation "greater than or equal to" is denoted by the symbol `>=`. The relation "not equal" is denoted by the symbol `<>`.

Two strings are considered equal if they have the same length and the same characters in the same order.

The stop-statement causes termination of the program.

### Exceptions
None


## FOR and NEXT statement

### General description
The for-statement and next-statement provide a looping mechanism. The general syntactic form of the for-statement and next-statement is:
    FOR v = initial-value TO limit STEP increment
    NEXT v
where "v" is a simple numeric variable and the "initial-value", "limit" and "increment" are numeric expressions. The clause "STEP increment" is optional.

### Syntax
1. for-block = for-line for-body
2. for-body = block next-line
3. for-line = for-statement end-of-line
4. next-line = next-statement end-of-line
5. for-statement = FOR control-variable equals-sign initial-value TO limit (STEP increment)?
6. control-variable = simple-numeric-variable
7. initial-value = numeric-expression
8. limit = numeric-expression
9. increment = numeric-expression
10. next-statement = NEXT control-variable

### Examples
```basic
FOR I = 1 TO 10
NEXT I

FOR I = A TO B STEP -1
NEXT I
```

### Semantics
The for-statement and the next-statement are defined in conjunction with each other. The sequence of statements beginning with a for-statement up until the first next-statement with the same control variable is called a "for-block". For-blocks can be nested but not interleaved.

The following nesting is allowed:
```basic
FOR I = 1 TO 10
FOR J = 1 TO 10
PRINT I, J
NEXT J
NEXT I
```

Interleaving is not allowed:
```basic
FOR I = 1 TO 10
PRINT I
FOR J = 1 TO 10
NEXT I
NEXT J
```

Furthermore, nested for-blocks must not use the same control variable.

If a STEP clause is not provided, the increment is assumed to be +1.

The for-statement performs the checks for the termination of the for-block. If the control variable is greater than the limit and SGN(increment) is positive, then the for-statement terminates. If the control variable is less than the limit and SGN(increment) is negative, then the for-statement terminates. The next-statement is responsible for incrementing the control variable.

### Exceptions
None

### Remarks
The value of the control-variable after exiting the for-block via a next-statement is the first value that is over the limit.


## PRINT statement

### General description
The print-statement outputs values in a consistent format to the console.

The general syntactic form of the print-statement is
    PRINT item p item p ... p item
where each item is a n expression or null, and each punctuation mark p is a comma.

### Syntax
1. print-statement = PRINT print-list?
2. print-list = (expression? print-separator)* expression?
3. print-separator = comma / semicolon

### Examples
```basic
PRINT X
PRINT X, (Y+Z) / 2
PRINT
PRINT A$; "IS DONE."
PRINT "X EQUALS", 10
PRINT X, Y
PRINT ,,,X
PRINT X,
```

### Semantics
The execution of a print-statement causes the values of the expressions in the print-list to be output to the console sequentially.

Evaluated numeric-expressions are converted to string representations. If the number if negative, it is preceded by a minus-sign. Numbers are formatted using decimal notation by default. Large and small numbers are printed using scientific notation. If the number would require more than 7 characters to be printed before or after the decimal point, the output is truncated and printed using the scientific notation.

String-expression are evaluated to generate a string of characters. The are output as defined, without surrounding quotes.

The print-separator is a comma or a semicolon. When a comma is used, the output is separated by a tab character. When a semicolon is used, the next item printed immediately adjacent to the previous item, with no intervening whitespace.

If the print-list ends with a print-separator, the print cursor remains at its current position. Otherwise, a newline sequence is output.

### Exceptions
None

### Remarks
An empty print-list will generate an end-of-line, completing the current line of output. If this line contained no characters, then a blank line is output.


## INPUT statement

### General description
Input-statements allows the user to assign values to variables. The input-statement allows entering both string and numeric data, with each data item separated by a comma. The general syntactic form of the input-statement is:
    INPUT variable, ..., variable

### Syntax
1. input-statement = INPUT variable-list
2. variable-list = variable (comma variable)*
3. input-prompt = [implementation-defined]
4. input-reply = input-list end-of-line
5. input-list = padded-datum (comma padded-datum)*
6. padded-datum = space* datum space*
7. datum = quoted-string / unquoted-string

### Examples
```basic
INPUT X
INPUT X, A$, Y(2)
INPUT A, B, C
3.14159
2,SMITH,-3
25,0,-15
```

### Semantics
As input-statement assign values to variables in the variable-list in order from the input-reply. In the interactive mode, the user of the program is instructed to enter data by the input-prompt. In batch mode, the input-replyis requested from an external source, which is implementation-specific. Execution of the program is suspended until a vlid input-reply has been provided.

The type of each datum in the input-reply must correspond to the type of the variable in the variable-list it is assigned to. If the response to input for a string-variable is an unquoted-string, leading and trailing spaces are removed (see [Characters and strings](#characters-and-strings)).

If the evaluation of a numeric datum causes an underflow, then its value is replaced by a zero.

Subscript expressions in the variable-list are evaluated after values to the left of that expression have been assigned in the variable-list. In the following example, the value A is first assigned and then Ath index of the array B is updated with a value C.
```basic
DIM B(10)
INPUT A, B(A), C
```

The input-reply must first be validated before any of its values are assigned to the variables in the variable-list. The input-reply must be validated in the following way:
- The type of each datum must match the type of the matching variable in the variable-list.
- The number of items in the input-reply must match the number of variables in the variable-list.
- The allowable range for each datum must be checked.

### Exceptions
- The type of datum does not match the type of the variable to which it is  to be assigned (nonfatal, the recommeded recovery procedure is to reuest the user to enter a valid value).
- There is insufficient data in the input-list (nonfatal, the recommended recovery procedure is to request the user to enter more data).
- There is too much data in the input-list (nonfatal, the recommended recovery procedure is to request the user to enter less data).
- The evaluation of a numeric datum causes an overflow (nonfatal, the recommended recovery procedure is to request the user to enter a valid value).
- A string datum contains too many characters (nonfatal, the recommended recovery procedure is to request the user to a string with fewer characters).

### Remarks
It is recommended that the input-prompt ends in a question-mark followed by a single space.

This standard does not require an implementation to output the input-reply.

It is recommended that implementations report an underflow as an exception, and allow the input-reply to be resubmitted.


## READ and RESTORE statements

### General description
The read-statement allows assigning values to variables from a sequence of data created from data-statements (see [DATA statement](#data-statement)). The restore-statement allows the data in the program to be reread. The general syntactic forms of the read and restore statements are
    READ variable, ..., variable
    RESTORE

### Syntax
1. read-statement = READ variable-list
2. restore-statement = RESTORE

### Examples
READ X, Y, Z
READ X(1), A$, C

### Semantics
The read-statement assigns values to the variables in the variable-list, in order from the sequence of data (see [DATA statement](#data-statement)). A conceptual pointer is associated with the data sequence. When the program is first initialized, this pointer points to the first datum in data sequence. Whenever a read-statement is executed, each variable in the variable-list is assigned the value of the datum indicated by the pointer and the pointer is advanced to point to its following datum.

The restore-statement resets the pointer for the data sequence to its beginning. The following read-statement will read data from the beginning of the sequence.

The type of a datum in the data sequence must correspond to the type of the variable to which it is assigned to. Numeric-variables require unquoted-strings which are numeric-constants, while string-variables require quoted-string or unquoted-strings as data. An unquoted-string which is a valid numeric representation can be assigned to both a string-variable and a numeric-variable by a read-statement. This is determined by the data type of the variable.

If the evaluation of a numeric datum causes an underflow, then its value is replaced by a zero.

Subscript expressions in the variable-list are evaluated after values to the left of that expression have been assigned in the variable-list.

### Exceptions
- The variable-list in a read-statement requires more data than are present in the rest of the data-sequence (fatal)
- A string datum is assigned to a numeric-variable (fatal)
- The evaluation of a numeric datum causes an overflow (nonfatal, the recommended recovery procedure is to assing machine infinity with the appropriate sign and continue).
- A string datum contains too many characters (fatal)

### Remarks
It it recommended that implementations report an underflow as an exception, and continue.

## DATA statement

### General description

The data-statement creates a sequence of data which a read-statement can read. The general syntactic form of the data-statement is
    DATA datum, ..., datum
where each datum is either a numeric constants, a string-constant or an unquoted-string.

### Syntax
1. data-statement = DATA data-list
2. data-list = datum (comma datum)*

### Examples
DATA 3.14159, PI, 5E-10, ","

### Semantics
Data from all the data-statements are concatenated into a single data sequence. The order in which data appear textually across the data-statements is preserved.

If the execution of a program reaches a line containing a data-statement, then it shall proceed to then next line with no other effect.

### Exceptions
None

## Array declarations

### General description
The dimension-statement is used to reserve space for arrays. Unless the option-statement is declared, all array subscripts have a lower bound of 0 and an upper bound of 10. Thus the default space allocation reserves space for 11 elements in 1-dimensional arrays and 121-elements in 2-dimensional arrays. By using a dimension-statement, the size of the array may be declared to have a different size than 11. By using an option-statement, the subscript of all arrays may be changed to from a lower bound of 0 to 1.

The general syntactic form of the dimension-statement is 
    DIM declaration, ..., declaration
where each declaration has the form
    letter (integer)
or  letter (integer, integer)

The general syntactic form of the option-statement is
    OPTION BASE n
where n is either 0 or 1.

### Syntax
1. dimension-statement = DIM array-declaration, (comma array-declaration)*
2. array-declaration = numeric-array-name left-parenthesis bounds right-parenthesis
3. bounds = integer (comma integer)?
4. option-statement = OPTION BASE (0/1)

### Examples
DIM A(6), B(10,10)

### Semantics
Each array-declaration in a dimension-statement declares the array to be either 1-dimensional or 2-dimensional, depending on the number of provided bounds. The bounds specify the maximum values for each subscript of the array.

The declaration of an array, if present at all, must occur before any reference to that array in the program. Arrays that are not declared in any dimension-statement are declared implicitly to be 1- or 2-dimensional, according to their use in the program, and to have maximum subscripts of 10 (see [Variables](#variables)).

The option-statement declares the minimum value for all array subscripts. If no option-statement is present, the minimum value is set to 0. An option-statement, if present at all, must occur before any dimension-statement or any reference to an element of an array. A program may contain at most one option-statement.

If the execution of a program reaches a dimension-statement or an option-statement, then it proceeds to the next line with no other effect.

An array can be explicitly dimensioned only once in a program.

### Exceptions
None


## REMARK statement

### General description
The remark-statement allows the programmer to add comments to the program.

### Syntax
1. remark-statement = REM remark-string

### Examples
REM FINAL CHECK

### Semantics
If the execution of a program reaches a line containing a remark-statement, then it shall proceed to then next line with no other effect.

### Exceptions
None

## RANDOMIZE statement

### General description
The randomize-statement overrides the implementation-defined pseudo-random number generation with RND function, allowing different (and unpredictable) sequences each time a given program is run.

### Syntax
1. randomize-statement = RANDOMIZE

### Examples
RANDOMIZE

### Semantics
Executing the randomize-statement sets a new random number seed, and causes the RND function to behave differently each time the program is run.

### Exceptions
None

## Differences with original Minimal BASIC
- Lines do not require a line number. The order of execution is determined by the order of statements in the program / Duplicate line numbers are not allowed
  - GOTO and GOSUB statements are not thus supported
- Specific end-of-line character has been specified as `\n`.
- Maximum number of characters per line has been increased from 72 to 255.
- Functions support unlimited number of arguments.
- Comparison operators have been extended from just `=` to `<>`, `<=`, `>=`, `<` and `>`. FIXME: add these to syntax
- PRINT semantics have been modernized.


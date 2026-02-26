import "errors.dart";
import "data_structures.dart";
import "operators.dart";
import "typed_expressions.dart";
import "typed_statements.dart";
import "types.dart";
import "untyped_expressions.dart";
import "untyped_statements.dart";

/// Stores the type of each variable in the program.
class IdentifierTypeTable {
  /// Stores variables in different scopes.
  final Stack<Scope<BasicType>> _scopes = Stack();

  /// Default [IdentifierTypeTable] constructor, initializes the stack with global scope.
  IdentifierTypeTable() {
    _scopes.push(Scope());
  }

  /// Adds a new scope to the stack.
  void createNewScope() {
    _scopes.push(Scope());
  }

  /// Removes the top scope from the stack.
  Scope<BasicType> removeTopScope() {
    return _scopes.pop();
  }

  /// Declares a variable with the given [identifier] and [type].
  void declare(String identifier, BasicType type) {
    _scopes.peek.declare(identifier, type);
  }

  /// Returns the type of the variable with the given [identifier].
  BasicType? lookup(String identifier) {
    for (final scope in _scopes.topToBottom) {
      final type = scope.lookup(identifier);
      if (type != null) return type;
    }
    return null;
  }
}

/// Checks the types of the program statements.
///
/// This class walks the untyped statements and returns typed ones.
class TypeChecker {
  /// The symbol table for storing variable types.
  final IdentifierTypeTable _symbols = IdentifierTypeTable();

  /// Index of the next statement to be type checked.
  int _statementIndex = 0;

  /// Increments the current statement index by one.
  void _incrementStatementIndex() => _statementIndex++;

  /// Gets the current statement index.
  int _getStatementIndex() => _statementIndex;

  /// Entry point function that walks iterates over the untyped statements and returns typed ones.
  List<TypedStatement> check(List<Statement> statements) {
    final List<TypedStatement> result = [];
    for (final statement in statements) {
      final typed = checkStatement(statement);
      result.add(typed);
      _incrementStatementIndex();
    }
    return result;
  }

  /// Type checks a statement and returns a typed version of it.
  TypedStatement checkStatement(Statement statement) {
    return switch (statement) {
      LetStatement() => checkLetStatement(statement),
      PrintStatement() => checkPrintStatement(statement),
      IfStatement() => checkIfStatement(statement),
      ForStatement() => checkForStatement(statement),
      FunctionDeclarationStatement() => checkFunctionDeclarationStatement(
        statement,
      ),
      EndStatement() => TypedEndStatement(),
      RemarkStatement() => TypedRemarkStatement(),
    };
  }

  /// Type checks a LET statement and returns a typed version of it.
  TypedLetStatement checkLetStatement(LetStatement statement) {
    final (typedExpr, type) = inferExpression(statement.expression);
    _symbols.declare(statement.identifier, type);
    return TypedLetStatement(statement.identifier, typedExpr);
  }

  /// Type checks a PRINT statement and returns a typed version of it.
  TypedPrintStatement checkPrintStatement(PrintStatement statement) {
    final typedArgs = statement.arguments
        .map((e) => inferExpression(e).$1)
        .toList();
    return TypedPrintStatement(typedArgs);
  }

  /// Type checks an IF statement and returns a typed version of it.
  TypedIfStatement checkIfStatement(IfStatement statement) {
    final (typedCondition, condType) = inferExpression(statement.condition);
    if (condType != BasicType.boolean) {
      throw NonMatchingTypeError(
        _getStatementIndex(),
        BasicTypeOptionOne(BasicType.boolean),
        condType,
      );
    }
    final typedThen = checkStatement(statement.thenStatement);
    return TypedIfStatement(typedCondition as TypedExpression<bool>, typedThen);
  }

  /// Type checks a FOR statement and returns a typed version of it.
  TypedForStatement checkForStatement(ForStatement statement) {
    final (typedStartValue, startType) = inferExpression(statement.start);
    final (typedEndValue, endType) = inferExpression(statement.end);
    final (typedStepValue, stepType) = inferExpression(statement.step);

    if (startType != BasicType.integer) {
      throw NonMatchingTypeError(
        _getStatementIndex(),
        BasicTypeOptionOne(BasicType.integer),
        startType,
      );
    }

    if (endType != BasicType.integer) {
      throw NonMatchingTypeError(
        _getStatementIndex(),
        BasicTypeOptionOne(BasicType.integer),
        endType,
      );
    }

    if (stepType != BasicType.integer) {
      throw NonMatchingTypeError(
        _getStatementIndex(),
        BasicTypeOptionOne(BasicType.integer),
        stepType,
      );
    }

    _symbols.declare(statement.loopVariableName, BasicType.integer);
    final typedBody = checkStatement(statement.body);
    return TypedForStatement(
      statement.loopVariableName,
      typedStartValue as TypedExpression<int>,
      typedEndValue as TypedExpression<int>,
      typedStepValue as TypedExpression<int>,
      typedBody,
    );
  }

  /// Type checks a function declaration statement and returns a typed version of it.
  TypedFunctionDeclarationStatement checkFunctionDeclarationStatement(
    FunctionDeclarationStatement statement,
  ) {
    _symbols.createNewScope();
    for (final arg in statement.arguments) {
      _symbols.declare(arg, BasicType.integer); // Only integers are supported for now
    }
    final (typedBody, bodyType) = inferExpression(statement.body);
    _symbols.removeTopScope();
    _symbols.declare(statement.identifier, bodyType);
    return TypedFunctionDeclarationStatement(
      statement.identifier,
      statement.arguments,
      typedBody,
    );
  }

  /// Infers the type of an expression and returns a typed version of it.
  (TypedExpression, BasicType) inferExpression(Expression expression) {
    return switch (expression) {
      IntegerConstantExpression() => (
        TypedIntegerConstantExpression(expression.value),
        BasicType.integer,
      ),
      FloatingPointConstantExpression() => (
        TypedFloatingPointConstantExpression(expression.value),
        BasicType.double,
      ),
      StringConstantExpression() => (
        TypedStringConstantExpression(expression.value),
        BasicType.string,
      ),
      BooleanConstantExpression() => (
        TypedBooleanConstantExpression(expression.value),
        BasicType.boolean,
      ),
      IdentifierConstantExpression() => inferIdentifier(expression),
      FunctionCallExpression() => inferFunctionCall(expression),
      UnaryExpression() => inferUnary(expression),
      BinaryExpression() => inferBinary(expression),
    };
  }

  /// Infers the type of an identifier constant expression.
  (TypedIdentifierConstantExpression, BasicType) inferIdentifier(
    IdentifierConstantExpression expression,
  ) {
    final type = _symbols.lookup(expression.identifier);
    if (type == null) {
      throw MissingIdentifierError(_getStatementIndex(), expression.identifier);
    }
    return switch (type) {
      BasicType.integer => (
        TypedIdentifierConstantExpression<int>(expression.identifier),
        BasicType.integer,
      ),
      BasicType.double => (
        TypedIdentifierConstantExpression<double>(expression.identifier),
        BasicType.double,
      ),
      BasicType.string => (
        TypedIdentifierConstantExpression<String>(expression.identifier),
        BasicType.string,
      ),
      BasicType.boolean => (
        TypedIdentifierConstantExpression<bool>(expression.identifier),
        BasicType.boolean,
      ),
    };
  }

  /// Infers the type of a function call expression.
  ///
  /// Looks up the function's return type in the symbol table and type-checks the arguments.
  (TypedFunctionCallExpression, BasicType) inferFunctionCall(
    FunctionCallExpression expression,
  ) {
    final returnType = _symbols.lookup(expression.identifier);
    if (returnType == null) {
      throw MissingIdentifierError(_getStatementIndex(), expression.identifier);
    }
    final typedAttributes = expression.arguments
        .map((arg) => inferExpression(arg).$1)
        .toList();
    return switch (returnType) {
      BasicType.integer => (
        TypedFunctionCallExpression(
          expression.identifier,
          typedAttributes,
        ),
        BasicType.integer,
      ),
      BasicType.double => (
        TypedFunctionCallExpression(
          expression.identifier,
          typedAttributes,
        ),
        BasicType.double,
      ),
      BasicType.string => (
        TypedFunctionCallExpression(
          expression.identifier,
          typedAttributes,
        ),
        BasicType.string,
      ),
      BasicType.boolean => (
        TypedFunctionCallExpression(
          expression.identifier,
          typedAttributes,
        ),
        BasicType.boolean,
      ),
    };
  }

  /// Infers the type of an unary expression.
  (TypedUnaryExpression, BasicType) inferUnary(UnaryExpression expression) {
    final (typedOperand, type) = inferExpression(expression.operand);
    if (type == BasicType.integer) {
      return (
        TypedUnaryExpression(
          typedOperand as TypedExpression<int>,
          expression.operator,
        ),
        BasicType.integer,
      );
    } else if (type == BasicType.double) {
      return (
        TypedUnaryExpression(
          typedOperand as TypedExpression<double>,
          expression.operator,
        ),
        BasicType.double,
      );
    } else {
      throw NonMatchingTypeError(
        _getStatementIndex(),
        BasicTypeOptionMany([BasicType.integer, BasicType.double]),
        type,
      );
    }
  }

  /// Infers the type of a binary expression.
  (TypedExpression, BasicType) inferBinary(BinaryExpression expression) {
    final (typedLhs, lhsType) = inferExpression(expression.lhs);
    final (typedRhs, rhsType) = inferExpression(expression.rhs);

    return switch (expression.operator) {
      ArithmeticOperator() => inferArithmetic(
        typedLhs,
        typedRhs,
        lhsType,
        rhsType,
        expression.operator as ArithmeticOperator,
      ),
      ComparisonOperator() => inferComparison(
        typedLhs,
        typedRhs,
        lhsType,
        rhsType,
        expression.operator as ComparisonOperator,
      ),
    };
  }

  /// Infers the type of an arithmetic expression.
  (TypedArithmeticExpression, BasicType) inferArithmetic(
    TypedExpression lhs,
    TypedExpression rhs,
    BasicType lhsType,
    BasicType rhsType,
    ArithmeticOperator operator,
  ) {
    final returnType = switch ((lhsType, rhsType)) {
      (BasicType.integer, BasicType.integer) => BasicType.integer,
      (BasicType.integer, BasicType.double) => BasicType.double,
      (BasicType.double, BasicType.integer) => BasicType.double,
      (BasicType.double, BasicType.double) => BasicType.double,
      (BasicType.integer || BasicType.double, _) => throw NonMatchingTypeError(
        _getStatementIndex(),
        BasicTypeOptionMany([BasicType.integer, BasicType.double]),
        rhsType,
      ),
      _ => throw NonMatchingTypeError(
        _getStatementIndex(),
        BasicTypeOptionMany([BasicType.integer, BasicType.double]),
        lhsType,
      ),
    };
    return (
      TypedArithmeticExpression(
        lhs,
        rhs,
        operator,
      ),
      returnType,
    );
  }

  /// Infers the type of a comparison expression.
  (TypedComparisonExpression, BasicType) inferComparison(
    TypedExpression lhs,
    TypedExpression rhs,
    BasicType lhsType,
    BasicType rhsType,
    ComparisonOperator operator,
  ) {
    final returnType = switch ((lhsType, rhsType)) {
      (
        BasicType.integer || BasicType.double,
        BasicType.integer || BasicType.double,
      ) =>
        BasicType.boolean,
      (BasicType.integer || BasicType.double, _) => throw NonMatchingTypeError(
        _getStatementIndex(),
        BasicTypeOptionMany([BasicType.integer, BasicType.double]),
        rhsType,
      ),
      _ => throw NonMatchingTypeError(
        _getStatementIndex(),
        BasicTypeOptionMany([BasicType.integer, BasicType.double]),
        lhsType,
      ),
    };
    return (
      TypedComparisonExpression(
        lhs,
        rhs,
        operator,
      ),
      returnType,
    );
  }
}

// ---BEGIN EVERYTHING SPECIFIC TO LISTS---
indirect enum MyList<A> {
    case cons(A, MyList<A>)
    case empty
} // MyList

extension MyList: Equatable where A: Equatable {
    static func ==(leftList: MyList<A>, rightList: MyList<A>) -> Bool {
        switch (leftList, rightList) {
        case let (.cons(leftHead, leftTail), .cons(rightHead, rightTail)):
            return leftHead == rightHead && leftTail == rightTail
        case (.empty, .empty):
            return true
        case _:
            return false
        }
    } // ==
} // extension MyList

extension MyList: CustomStringConvertible where A: CustomStringConvertible {
    var description: String {
        var result = "["
        var list = self
        while case let .cons(head, .cons(restHead, restTail)) = list {
            result += "\(head), "
            list = MyList.cons(restHead, restTail)
        }
        if case let .cons(head, .empty) = list {
            result += head.description
        }
        result += "]"
        return result
    } // description
} // extension MyList

// ---END EVERYTHING SPECIFIC TO LISTS---

// ---BEGIN EVERYTHING SPECIFIC TO TOKENIZATION---
enum Token {
    // ---BEGIN TOKENS FOR ARITHMETIC EXPRESSIONS---
    case plus
    case minus
    case mult
    case div
    case leftParen
    case rightParen
    case num(Int)
    // ---END TOKENS FOR ARITHMETIC EXPRESSIONS---

    // ---BEGIN TOKENS FOR BOOLEAN EXPRESSIONS---
    case trueToken
    case falseToken
    case andToken
    case orToken
    case notToken
    // ---END TOKENS FOR BOOLEAN EXPRESSIONS---
} // Token

extension Token: Equatable {
    static func ==(leftToken: Token, rightToken: Token) -> Bool {
        switch (leftToken, rightToken) {
        case (.plus, .plus): return true
        case (.minus, .minus): return true
        case (.mult, .mult): return true
        case (.div, .div): return true
        case (.leftParen, .leftParen): return true
        case (.rightParen, .rightParen): return true
        case (.num(let leftNum), .num(let rightNum)): return leftNum == rightNum
        case (.trueToken, .trueToken): return true
        case (.falseToken, .falseToken): return true
        case (.andToken, .andToken): return true
        case (.orToken, .orToken): return true
        case (.notToken, .notToken): return true
        case _: return false
        }
    }
}

extension Token: CustomStringConvertible {
    var description: String {
        switch self {
        case .plus: return "+"
        case .minus: return "-"
        case .mult: return "*"
        case .div: return "/"
        case .leftParen: return "("
        case .rightParen: return ")"
        case .num(let value): return "\(value)"
        case .trueToken: return "true"
        case .falseToken: return "false"
        case .andToken: return "&&"
        case .orToken: return "||"
        case .notToken: return "!"
        }
    }
}

extension Substring {
    // skips past any starting whitespace
    func skipWhitespace() -> Substring {
        func isWhitespace(_ c: Character) -> Bool {
            return c == " " || c == "\t" || c == "\n"
        }
        var result = self
        while let start = result.first, isWhitespace(start) {
            result = self.dropFirst(1)
        }
        return result
    }
    
    // gets the number that the string starts with, along with the rest of the string
    // returns nil if the string doesn't start with a number
    func startNum() -> (Int, Substring)? {
        var numString = ""
        var numPositions = 0

        for char in self {
            if ("0"..."9").contains(char) {
                numString += char.description
                numPositions += 1
            } else {
                break
            }
        }

        if numPositions == 0 {
            return nil
        } else {
            return (Int(numString)!, self.dropFirst(numPositions))
        }
    } // startNum
    
    // if the string starts with `with`, it gives back the rest of the string
    func startSplit(with: String) -> Substring? {
        if self.starts(with: with) {
            return self.dropFirst(with.count)
        } else {
            return nil
        }
    } // startSplit
    
    func tokenizeSingle(with: MyList<(String, Token)>) -> (Token, Substring)? {
        switch with {
        case let .cons((tokenString, token), restTokens):
            if let restString = self.startSplit(with: tokenString) {
                return (token, restString)
            } else {
                return tokenizeSingle(with: restTokens)
            }
        case .empty:
            return nil
        }
    } // tokenizeSingle

    func tokenize(with: MyList<(String, Token)>) -> MyList<Token>? {
        let trimmed = self.skipWhitespace()
        var tokenAndRestString: (Token, Substring)? = nil

        if trimmed.count == 0 {
            return MyList.empty
        } else if let (num, remainder) = trimmed.startNum() {
            tokenAndRestString = (Token.num(num), remainder)
        } else {
            tokenAndRestString = trimmed.tokenizeSingle(with: with)
        }

        if let (token, rest) = tokenAndRestString {
            if let restTokens = rest.tokenize(with: with) {
                return MyList.cons(token, restTokens)
            } else {
                return nil
            }
        } else {
            return nil
        }
    } // tokenize

    func tokenize() -> MyList<Token>? {
        let tokens = MyList.cons(("+", Token.plus),
                     MyList.cons(("-", Token.minus),
                     MyList.cons(("*", Token.mult),
                     MyList.cons(("/", Token.div),
                     MyList.cons(("(", Token.leftParen),
                     MyList.cons((")", Token.rightParen),
                     MyList.cons(("true", Token.trueToken),
                     MyList.cons(("false", Token.falseToken),
                     MyList.cons(("&&", Token.andToken),
                     MyList.cons(("||", Token.orToken),
                     MyList.cons(("!", Token.notToken),
                                 MyList.empty)))))))))))
        return self.tokenize(with: tokens)
    } // tokenize
} // extension Substring

extension String {
    func tokenize() -> MyList<Token>? {
        return self.dropFirst(0).tokenize()
    }
}

// ---END EVERYTHING SPECIFIC TO TOKENIZATION---

// ---BEGIN EVERYTHING SPECIFIC TO SYNTAX---
enum Binop {
    case plus
    case minus
    case mult
    case div
    case andBinop
    case orBinop
} // Binop

extension Binop: CustomStringConvertible {
    var description: String {
        switch self {
        case .plus: return "+"
        case .minus: return "-"
        case .mult: return "*"
        case .div: return "/"
        case .andBinop: return "&&"
        case .orBinop: return "||"
        }
    } // description
} // extension Binop

indirect enum Exp {
    case intLiteral(Int)
    case binop(Binop, Exp, Exp)
    case negate(Exp)
    case trueExp
    case falseExp
    case not(Exp)
} // Exp

extension Exp: CustomStringConvertible {
    var description: String {
        switch self {
        case .intLiteral(let num):
            return num.description
        case let .binop(op, e1, e2):
            return "(\(op) \(e1) \(e2))"
        case .negate(let e):
            return "(- \(e))"
        case .trueExp: return "true"
        case .falseExp: return "false"
        case .not(let e):
            return "(! \(e))"
        }
    } // description
} // extension Exp

extension Exp: Equatable {
    static func ==(leftExp: Exp, rightExp: Exp) -> Bool {
        switch (leftExp, rightExp) {
        case let (.intLiteral(leftNum), .intLiteral(rightNum)):
            return leftNum == rightNum
        case let (.binop(leftOp, leftE1, leftE2), .binop(rightOp, rightE1, rightE2)):
            return leftOp == rightOp && leftE1 == rightE1 && leftE2 == rightE2
        case let (.negate(leftE), .negate(rightE)):
            return leftE == rightE
        case (.trueExp, .trueExp): return true
        case (.falseExp, .falseExp): return true
        case let (.not(leftE), .not(rightE)):
            return leftE == rightE
        case _:
            return false
        }
    } // ==
} // extension Exp

// ---END EVERYTHING SPECIFIC TO SYNTAX---

// ---BEGIN EVERYTHING SPECIFIC TO PARSING---
enum ParseResult<A> {
    case success(MyList<Token>, A)
    case failure(String)
} // ParseResult

extension ParseResult {
    func getValue() -> A? {
        switch self {
        case .success(_, let a):
            return a
        case .failure(_):
            return nil
        }
    } // getValue

    func isFailure() -> Bool {
        switch self {
        case .failure(_):
            return true
        case .success(_, _):
            return false
        }
    } // isFailure
} // ParseResult

typealias Parser<A> = (MyList<Token>) -> ParseResult<A>

struct Unit {}

// Attempts to parse expectedToken, returning Unit on
// success, or failure otherwise.
func tokenP(_ expectedToken: Token) -> Parser<Unit> {
    return { tokens in
        switch tokens {
        case .cons(let receivedToken, let rest):
            if expectedToken == receivedToken {
                return ParseResult.success(rest, Unit())
            } else {
                return ParseResult.failure(
                  "Expected: \(expectedToken); Received: \(receivedToken)")
            }
        case .empty:
            return ParseResult.failure("Out of tokens")
        }
    }
} // tokenP

// Attempts to parse tokenRep, returning expRep on success,
// or failure otherwise.
func oneToOneP(tokenRep: Token, expRep: Exp) -> Parser<Exp> {
    return mapP(parser: tokenP(tokenRep),
                operation: { _ in expRep })
} // oneToOneP

// Attempts to parse in a num token, returning the Int
// inside the num on success, or failure otherwise.
func numP() -> Parser<Int> {
    return { tokens in
        switch tokens {
        case .cons(.num(let value), let rest):
            return ParseResult.success(rest, value)
        case .cons(let received, _):
            return ParseResult.failure(
              "Expected number token; Received: \(received)")
        case .empty:
            return ParseResult.failure("Out of tokens")
        }
    }
} // numP

// Runs leftParser on the input tokens, followed by rightParser on whatever is left.
// Succeeds only if leftParser and rightParser both succeed.  Returns a pair of the
// elements returned from leftParser and rightParser, respectively.
// Note that leftParser and rightParser are not parsers directly, but instead functions
// that return parsers.  This avoids issues with infinite recursion when defining parsers;
// leftParser and rightParser are only called as needed.
// @escaping says that the input function is closed over by the returned function.
// @autoclosure says that the caller doesn't have to wrap its input in a function; the
// input will be automatically wrapped.
func andP<A, B>(_ leftParser: @escaping @autoclosure () -> Parser<A>,
                _ rightParser: @escaping @autoclosure () -> Parser<B>) -> Parser<(A, B)> {
    return { tokens in
        switch leftParser()(tokens) {
        case .success(let restLeft, let a):
            switch rightParser()(restLeft) {
            case .success(let restRight, let b):
                return ParseResult.success(restRight, (a, b))
            case .failure(let error):
                return ParseResult.failure(error)
            }
        case .failure(let error):
            return ParseResult.failure(error)
        }
    }
} // andP

// Runs leftParser on the input tokens, returning the result from leftParser
// on success.  If leftParser fails, we instead run rightParser on the input
// tokens.  Returns whatever rightParser returns.
// See andP for details on @escaping and @autoclosure.
func orP<A>(_ leftParser: @escaping @autoclosure () -> Parser<A>,
            _ rightParser: @escaping @autoclosure () -> Parser<A>) -> Parser<A> {
    return { tokens in
        switch leftParser()(tokens) {
        case .failure(_):
            return rightParser()(tokens)
        case let success: return success
        }
    }
} // orP

// Runs parser on the input tokens.  On success, it will run operation
// on the result, returning the result of operation.  If the parser
// fails, then mapP fails without calling operation.  See andP for
// details on @escaping and @autoclosure.
func mapP<A, B>(parser: @escaping @autoclosure () -> Parser<A>,
                operation: @escaping (A) -> B) -> Parser<B> {
    return { tokens in
        switch parser()(tokens) {
        case .success(let rest, let a):
            return ParseResult.success(rest, operation(a))
        case .failure(let error):
            return ParseResult.failure(error)
        }
    }
} // mapP

// Runs innerParser on the input tokens repeatedly, until the parser fails.
// Returns a list of all the results from successes.
// See andP for details on @escaping and @autoclosure.
func repeatP<A>(_ innerParser: @escaping @autoclosure () -> Parser<A>) -> Parser<MyList<A>> {
    func helper(_ innerParser: Parser<A>,
                _ tokens: MyList<Token>) -> (MyList<Token>, MyList<A>) {
        switch innerParser(tokens) {
        case .success(let rest, let a):
            let (finalRest, restA) = helper(innerParser, rest)
            return (finalRest, MyList.cons(a, restA))
        case .failure(_):
            return (tokens, MyList.empty)
        }
    } // helper

    return { tokens in
        let (rest, allAs) = helper(innerParser(), tokens)
        return ParseResult.success(rest, allAs)
    }
} // repeatP

// Used to state that whatever around parses should be surrounded by parentheses.
// Returns whatever around returns, and fails if around fails or if the value
// is not surrounded by parentheses.
// See andP for details on @escaping and @autoclosure.
func inParensP<A>(_ around: @escaping @autoclosure () -> Parser<A>) -> Parser<A> {
    return mapP(
      parser: andP(tokenP(Token.leftParen),
                   andP(around(),
                        tokenP(Token.rightParen))),
      operation: { input in
          let (_, (retval, _)) = input
          return retval
      })
} // inParensP

// Used to parse in binary operations like plus and or.
// tokenRep is the Token-based representation of the operator to parse
// (e.g, Token.plus), and binopRep is the Binop-based representation
// of the operator to parse (e.g., Binop.plus)
func binopP(tokenRep: Token, binopRep: Binop) -> Parser<Exp> {
    return mapP(
      parser: inParensP(
        andP(tokenP(tokenRep),
             andP(expressionP(),
                  expressionP()))),
      operation: { input in
          let (_, (e1, e2)) = input
          return Exp.binop(binopRep, e1, e2)
      })
} // binopP

// Used to parse in unary operations like negate and not.
// tokenRep is the Token-based representation of the operator to parse
// (e.g., Token.notToken), and makeOp is a function that takes the inner expression
// the operator is performed on and returns the final expression (e.g., Exp.not).
// See andP for details on @escaping.
func unopP(tokenRep: Token, makeOp: @escaping (Exp) -> Exp) -> Parser<Exp> {
    return mapP(
      parser: inParensP(
        andP(tokenP(tokenRep),
             expressionP())),
      operation: { input in
          let (_, e) = input
          return makeOp(e)
      })
} // unopP

// Parses in an expression, according to the following grammar:
//
// expr ::= INTEGER |
//          true |
//          false |
//          '(' '-' expr ')' |
//          '(' '!' expr ')' |
//          '(' '+' expr expr ')' |
//          '(' '-' expr expr ')' |
//          '(' '*' expr expr ')' |
//          '(' '/' expr expr ')' |
//          '(' '&&' expr expr ')' |
//          '(' '||' expr expr ')'
//
func expressionP() -> Parser<Exp> { // DO NOT MODIFY THIS LINE
    
    // 11 LINES ---> Boom
    return orP(mapP(parser: numP(), operation:{ input in Exp.intLiteral(input) }),
                        orP(oneToOneP(tokenRep:Token.trueToken, expRep: Exp.trueExp),
                              orP(oneToOneP(tokenRep: Token.falseToken, expRep: Exp.falseExp),
                                  orP(unopP(tokenRep: Token.minus, makeOp: { e in Exp.negate(e) }),
                                      orP(unopP(tokenRep: Token.notToken, makeOp: { e in Exp.not(e)}),
                                          orP(binopP(tokenRep: Token.plus, binopRep: Binop.plus),
                                              orP(binopP(tokenRep: Token.minus, binopRep: Binop.minus),
                                                  orP(binopP(tokenRep: Token.mult, binopRep: Binop.mult),
                                                      orP(binopP(tokenRep: Token.div, binopRep: Binop.div),
                                                          orP(binopP(tokenRep: Token.andToken, binopRep: Binop.andBinop)
                                                              , binopP(tokenRep: Token.orToken, binopRep: Binop.orBinop)))))))))))

    //return { _ in ParseResult.failure("Default stub for Exp") }
} // expressionP   // DO NOT MODIFY THIS LINE

extension MyList where A == Token {
    func parse() -> ParseResult<MyList<Exp>> {
        let result = repeatP(expressionP())(self)
        switch result {
        case .success(.empty, _):
            return result
        case .success(_, _):
            return ParseResult.failure("Extra tokens")
        case .failure(_):
            return result
        }
    } // parse

    func parseSingle() -> ParseResult<Exp> {
        switch self.parse() {
        case .success(let tokens, .cons(let head, _)):
            return ParseResult.success(tokens, head)
        case .success(_, .empty):
            return ParseResult.failure("No expressions")
        case .failure(let error):
            return ParseResult.failure(error)
        }
    } // parseSingle
} // extension MyList

// ---END EVERYTHING SPECIFIC TO PARSING---

// ---BEGIN EVERYTHING RELATED TO TESTING---
func assertEquals<A>(testName: String,
                     expected: A,
                     received: A)
  where A: Equatable, A: CustomStringConvertible {
    print("\(testName): ", terminator: "")
    if expected != received {
        print("FAIL")
        print("\tExpected: \(expected)")
        print("\tReceived: \(received)")
    } else {
        print("pass")
    }
} // assertEquals

enum TestResult<A> {
    case some(A)
    case nothing
} // TestResult

extension TestResult: Equatable, CustomStringConvertible
  where A: Equatable, A: CustomStringConvertible {
    static func ==(lhs: TestResult<A>, rhs: TestResult<A>) -> Bool {
        switch (lhs, rhs) {
        case let (.some(l), .some(r)): return l == r
        case (.nothing, .nothing): return true
        case _: return false
        }
    } // ==

    var description: String {
        switch self {
        case .some(let a): return a.description
        case .nothing: return "PARSE FAILURE"
        }
    } // description
} // extension TestResult
                       
func assertParses(testName: String,
                  expected: Exp,
                  received: String) {
    var actualReceived: TestResult<Exp>
    if let r = received.tokenize()!.parseSingle().getValue() {
        actualReceived = TestResult.some(r)
    } else {
        actualReceived = TestResult.nothing
    }
    assertEquals(testName: testName,
                 expected: TestResult.some(expected),
                 received: actualReceived)
} // assertParses

// ---BEGIN TOKENIZER TESTS---
func test_empty_string() {
    assertEquals(testName: "test_empty_string",
                 expected: MyList.empty,
                 received: "".tokenize()!)
} // test_empty_string

func test_space() {
    assertEquals(testName: "test_space",
                 expected: MyList.empty,
                 received: " ".tokenize()!)
} // test_space

func test_plus() {
    assertEquals(testName: "test_plus",
                 expected: MyList.cons(Token.plus, MyList.empty),
                 received: "+".tokenize()!)
} // test_plus

func test_minus() {
    assertEquals(testName: "test_minus",
                 expected: MyList.cons(Token.minus, MyList.empty),
                 received: "-".tokenize()!)
} // test_minus

func test_mult() {
    assertEquals(testName: "test_mult",
                 expected: MyList.cons(Token.mult, MyList.empty),
                 received: "*".tokenize()!)
} // test_mult

func test_div() {
    assertEquals(testName: "test_div",
                 expected: MyList.cons(Token.div, MyList.empty),
                 received: "/".tokenize()!)
} // test_div

func test_left_paren() {
    assertEquals(testName: "test_left_paren",
                 expected: MyList.cons(Token.leftParen, MyList.empty),
                 received: "(".tokenize()!)
} // test_left_paren

func test_right_paren() {
    assertEquals(testName: "test_right_paren",
                 expected: MyList.cons(Token.rightParen, MyList.empty),
                 received: ")".tokenize()!)
} // test_right_paren

func test_single_digit_num() {
    assertEquals(testName: "test_single_digit_num",
                 expected: MyList.cons(Token.num(1), MyList.empty),
                 received: "1".tokenize()!)
} // test_single_digit_num

func test_multi_digit_num() {
    assertEquals(testName: "test_multi_digit_num",
                 expected: MyList.cons(Token.num(123), MyList.empty),
                 received: "123".tokenize()!)
} // test_multi_digit_num


func test_op_and_num() {
    assertEquals(testName: "test_op_and_nums",
                 expected: MyList.cons(Token.num(123),
                                       MyList.cons(Token.plus,
                                                   MyList.cons(Token.num(456),
                                                               MyList.empty))),
                 received: " 123 + 456 ".tokenize()!)
} // test_op_and_num

func tokenizerTests() {
    test_empty_string()
    test_space()
    test_plus()
    test_minus()
    test_mult()
    test_div()
    test_left_paren()
    test_right_paren()
    test_single_digit_num()
    test_multi_digit_num()
    test_op_and_num()
} // tokenizerTests

// ---END TOKENIZER TESTS---

// ---BEGIN PARSER TESTS---
func test_num_expression() {
    assertParses(testName: "test_num_expression",
                 expected: Exp.intLiteral(123),
                 received: "123")
} // test_num_expression

func test_plus_expression() {
    assertParses(testName: "test_plus_expression",
                 expected: Exp.binop(Binop.plus,
                                     Exp.intLiteral(123),
                                     Exp.intLiteral(456)),
                 received: "(+ 123 456)")
} // test_plus_expression

func test_minus_expression() {
    assertParses(testName: "test_minus_expression",
                 expected: Exp.binop(Binop.minus,
                                     Exp.intLiteral(123),
                                     Exp.intLiteral(456)),
                 received: "(- 123 456)")
} // test_minus_expression

func test_mult_expression() {
    assertParses(testName: "test_mult_expression",
                 expected: Exp.binop(Binop.mult,
                                     Exp.intLiteral(123),
                                     Exp.intLiteral(456)),
                 received: "(* 123 456)")
} // test_mult_expression

func test_div_expression() {
    assertParses(testName: "test_div_expression",
                 expected: Exp.binop(Binop.div,
                                     Exp.intLiteral(123),
                                     Exp.intLiteral(456)),
                 received: "(/ 123 456)")
} // test_div_expression

func test_and_expression() {
    assertParses(testName: "test_and_expression",
                 expected: Exp.binop(Binop.andBinop,
                                     Exp.trueExp,
                                     Exp.falseExp),
                 received: "(&& true false)")
} // test_and_expression

func test_or_expression() {
    assertParses(testName: "test_or_expression",
                 expected: Exp.binop(Binop.orBinop,
                                     Exp.trueExp,
                                     Exp.falseExp),
                 received: "(|| true false)")
} // test_or_expression

func test_negate_expression() {
    assertParses(testName: "test_negate_expression",
                 expected: Exp.negate(Exp.intLiteral(123)),
                 received: "(- 123)")
} // test_negate_expression

func test_true_expression() {
    assertParses(testName: "test_true_expression",
                 expected: Exp.trueExp,
                 received: "true")
} // test_true_expression

func test_false_expression() {
    assertParses(testName: "test_false_expression",
                 expected: Exp.falseExp,
                 received: "false")
} // test_false_expression

func test_not_expression() {
    assertParses(testName: "test_not_expression",
                 expected: Exp.not(Exp.trueExp),
                 received: "(! true)")
} // test_not_expression

func test_nested_expression() {
    assertParses(testName: "test_nested_expression",
                 expected: Exp.binop(Binop.plus,
                                     Exp.binop(Binop.minus,
                                               Exp.intLiteral(1),
                                               Exp.intLiteral(2)),
                                     Exp.binop(Binop.mult,
                                               Exp.intLiteral(3),
                                               Exp.intLiteral(4))),
                 received: "(+ (- 1 2) (* 3 4))")
} // test_nested_expression

func test_nested_negate_expression() {
    assertParses(testName: "test_nested_negate_expression",
                 expected: Exp.negate(Exp.negate(Exp.intLiteral(1))),
                 received: "(- (- 1))")
} // test_nested_negate_expression

func test_nested_not_expression() {
    assertParses(testName: "test_nested_not_expression",
                 expected: Exp.not(Exp.not(Exp.falseExp)),
                 received: "(! (! false))")
} // test_nested_not_expression

func test_nested_negate_and_plus_expression() {
    assertParses(testName: "test_nested_negate_and_plus_expression",
                 expected: Exp.negate(Exp.binop(Binop.plus,
                                                Exp.intLiteral(1),
                                                Exp.intLiteral(2))),
                 received: "(- (+ 1 2))")
} // test_nested_negate_and_plus_expression

func test_nested_not_and_or_expression() {
    assertParses(testName: "test_nested_not_and_or_expression",
                 expected: Exp.not(Exp.binop(Binop.orBinop,
                                             Exp.trueExp,
                                             Exp.falseExp)),
                 received: "(! (|| true false))")
} // test_nested_not_and_or_expression

func parserTests() {
    test_num_expression()
    test_plus_expression()
    test_minus_expression()
    test_mult_expression()
    test_div_expression()
    test_and_expression()
    test_or_expression()
    test_negate_expression()
    test_true_expression()
    test_false_expression()
    test_not_expression()
    test_nested_expression()
    test_nested_negate_expression()
    test_nested_not_expression()
    test_nested_negate_and_plus_expression()
    test_nested_not_and_or_expression()
} // parseTests
// ---END PARSER TESTS---

// ---END EVERYTHING RELATED TO TESTING---

// ---BEGIN MAIN---
tokenizerTests()
parserTests()
// ---END MAIN---

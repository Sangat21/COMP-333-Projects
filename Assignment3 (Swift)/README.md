Assignment 3:
Parser Combinators in Swift

Background
For this assignment, you will be using parser combinators to convert input strings into abstract syntax trees. This conversion process is known as parsing. The input strings are intended to represent arithmetic and boolean expressions using S-expressions. With S-expressions, operators go before the operands, and parentheses surround operators and their operands. For example, consider the following expressions and their S-expression equivalents:

Expression	                S-Expression Equivalent
123	                        123
true	                      true
1 + 2	                      (+ 1 2)
true && false	              (&& true false)
1 + (2 + 3)	                (+ 1 (+ 2 3))
true && (true || false)	    (&& true (|| true false))
(1 + 2) || (true && false)	(|| (+ 1 2) (&& true false))

S-expressions are used as the basis of the syntactic representation of some languages, including Lisp and Scheme. In our case, we use S-expressions because they are easier to parse than typical expressions, particularly when using parser combinators. (Note that we could parse typical expressions with parser combinators by eliminating left recursion, but this is beyond the scope of this class.)

Step-by-Step Instructions:

Step 1: Read and Understand Code
Download main.swift and peruse the code. In particular, you should read and understand the following functions, which all deal with parser combinators:
    tokenP:
    oneToOneP
    numP
    andP
    orP
    mapP
    inParensP
In addition, you should look at the parsing-related tests (i.e., those calling assertParses), which give a sense of the expected inputs and outputs.

Step 2: Implement expressionP
All the code you need to write is in expressionP. Do not modify any other code in main.swift. The provided code compiles, but fails all the parsing-related tests. Your goal is to get all the tests passing.

Step 3: Turn in Your Code Using Canvas
Log into Canvas, and go to the COMP 333 class. Click “Assignments” on the left pane, then click “Assignment 3”. From here, you need to upload the following file:

main.swift
In addition, if you collaborated with anyone else, be sure to download collaborators.txt and write the names of the people you collaborated with in the file, one per line. Please submit this file along with the other file.

You can turn in the assignment multiple times, but only the last version you submitted will be graded.

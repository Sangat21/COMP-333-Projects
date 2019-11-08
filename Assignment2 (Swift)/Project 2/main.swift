// COMP 333 Assignment 2
//
// You will need to get this code running.  You have two options here:
// 1.) Install Swift locally.  Swift can be downloaded here: https://swift.org/download/#releases
//     Binaries are available for Ubuntu Linux and Mac OS X.
//     You can compile the code with `swiftc main.swift`, and then run it with `./main`.
// 2.) Run Swift online at http://online.swiftplayground.run/.
//
// Once you have a Swift setup working, you can start implementing the assignment.
// Recommended approach:
//
// 1.) Implement an enum representing lists.  This should be named MyList,
//     and it needs a generic type A.
// 2.) Write stubs for all the methods, which just return dummy values.
//     This is to get things compiling.  You'll need the stubs later.
// 3.) Implement isEmpty.  This will require pattern matching (switch) on the list
//     in a similar manner as contentsToString.  isEmpty is relatively easy to
//     implement, and it will get you in the habit of using pattern matching.
// 4.) Implement foldRight.  map depends on foldRight, so this will get the most
//     stuff working quickly.
// 5.) Implement foldLeft.  It will be similar to foldRight.
// 6.) Implement the rest of the methods, in any particular order.  These
//     can be implemented in any way.  Note that they can also be implemented
//     as calls to foldLeft and foldRight (as is mapFunction)
//
// Hints:
// 1.) The test suite is large (90 tests), and covers a lot of behavior this code needs.
//     At a minimum, the test suite provides enough detail to write stubs for each
//     of the methods you need to define.  The test suite also has a lot of examples
//     which call Swift code.
// 2.) While Swift has classes, you don't need classes for this assignment.
// 3.) Many different implementations are possible.  However, probably the most concise
//     implementations will use foldLeft and foldRight as appropriate.
// 4.) My implementation's components have the following sizes (in lines of code):
//     - enum definition: 4         // DONE
//     - isEmpty: 8                 // DONE
//     - append: 5                  // DONE
//     - length: 5                  // DONE
//     - foldLeft: 9                // DONE
//     - foldRight: 9               // DONE
//     - filter: 6                  // DONE
//     - contains: 5                // DONE
//     - sum: 5                     // DONE
//     If you start needing significantly more code than this for any of these parts, we
//     should talk to make sure you're still on track.
//

// My Code
// enum MyList
indirect enum MyList<A> {
    case empty
    case cons(A, MyList<A>)
}

extension MyList {
    
    func map<B>(mapper: (A) -> B) -> MyList<B> {
        return mapFunction(list: self, mapper: mapper)
    } // map

    private func contentsToString(_ innerToString: (A) -> String) -> String {
        switch self {
        case let .cons(head, .empty): // list containing one element
            return innerToString(head)
        case let .cons(head, tail): // list containing more than one element
            return innerToString(head) + ", " + tail.contentsToString(innerToString)
        case .empty: // empty list
            return ""
        }
    } // contentsToString
    
    func toString(innerToString: (A) -> String) -> String {
        return "[" + contentsToString(innerToString) + "]"
    } // toString

    func equals(otherList: MyList<A>, compareInner: (A, A) -> Bool) -> Bool {
        switch (self, otherList) {
        case let (.cons(head1, tail1), .cons(head2, tail2)):
            return compareInner(head1, head2) && tail1.equals(otherList: tail2, compareInner: compareInner)
        case (.empty, .empty):
            return true
        case _:
            return false
        }
    } // equals
    
    // My Code

    // My Methods
    func isEmpty() -> Bool {
        switch self {
        case .cons(_, _):
            return false
        case .empty:
            return true
        }
    }
    
    func append(other: MyList<A>) -> MyList<A> {
        switch self {
        case .cons(let h, let t):
            return MyList<A>.cons(h, t.append(other: other))
        case .empty:
            return other
        }
    }
    
    func length() -> Int {
        switch self {
        case .cons(_, let tail):
            return 1 + tail.length()
        case .empty:
            return 0
        }
    }
    
    func filter(predicate: (A) -> (Bool)) -> MyList<A> {
        
        switch self {
            case .cons(let h, let t):
                let result = t.filter(predicate: predicate)
                if(predicate(h)) {
                    return MyList.cons(h, result)
                }
                else {
                    return result
                }
            case .empty:
                return MyList.empty
        }
        
        /*
        var result = MyList<A>.empty
        switch self {
        case .empty:
            return result.append(other: MyList<A>.empty)
        case .cons(let h, let t):
            let head = MyList.cons(h, MyList.empty)
            if(predicate(h)) {
                result.append(other: head) //t.filter(predicate: predicate))
                
            }
            return t.filter(predicate: predicate)
            /*if(predicate(h)) {
                result = t.append(other: t.filter(predicate: predicate))
                return result
            } else {
                return t.filter(predicate: predicate)
            }*/ */
    }
    
    func contains(target: A, compare: (A, A) -> Bool) -> Bool {
        switch self {
        case .empty:
            return false
        case .cons(let head, let tail):
            if(compare(head, target)) {
                return true
            }
            else {
                return tail.contains(target: target, compare: compare)
            }
        }
    }
    
    func sum(zero: A, add: (A, A) -> A) -> A {
        switch self {
        case .cons(let h, let t):
            return t.sum(zero: add(zero, h), add: add)
        case .empty:
            return zero
        }
    }
    
    func foldRight<B>(accum: B, fold: (A, B) -> B) -> B {
        // fold takes accum and something else
        switch self {
        case .empty:
            return accum
        case .cons(let head, let tail):
            return fold(head, tail.foldRight(accum: accum, fold: fold))
            
            //foldRight(accum: fold(head, accum), fold: fold)
        }
    }
    
    func foldLeft<B>(accum: B, fold: (B, A) -> B) -> B {
        switch self {
        case .cons(let head, let tail):
            return tail.foldLeft(accum: fold(accum, head), fold: fold)
        case .empty:
            return accum
        }
    }
    
} // extension MyList









// This should be a method, but we can't do this because of a bug in
// Swift's typechecker
func mapFunction<A, B>(list: MyList<A>, mapper: (A) -> B) -> MyList<B> {
    return list.foldRight(accum: MyList.empty,
                          fold: { (a, accum) in
                              MyList.cons(mapper(a), accum) })
} // map

// ---BEGIN TEST SUITE---
func assertEqualsBase<A>(testName: String,
                         compare: (A, A) -> Bool,
                         toString: (A) -> String,
                         expected: A,
                         received: A) {
    print(testName + ": ", terminator: "")
    if !compare(expected, received) {
        print("FAIL")
        print("\tExpected: " + toString(expected))
        print("\tReceived: " + toString(received))
    } else {
        print("pass")
    }
} // assertEqualsBase

func assertEquals(testName: String,
                  expected: MyList<Int>,
                  received: MyList<Int>) {
    assertEqualsBase(testName: testName,
                     compare: { (list1, list2) in
                         list1.equals(otherList: list2, compareInner: ==) },
                     toString: { list in
                         list.toString(innerToString: { i in i.description }) },
                     expected: expected,
                     received: received)
} // assertEquals

func assertEquals(testName: String,
                  expected: MyList<String>,
                  received: MyList<String>) {
    assertEqualsBase(testName: testName,
                     compare: { (list1, list2) in
                         list1.equals(otherList: list2, compareInner: ==) },
                     toString: { list in
                         list.toString(innerToString: { s in s }) },
                     expected: expected,
                     received: received)
} // assertEquals

func assertEquals(testName: String,
                  expected: Bool,
                  received: Bool) {
    assertEqualsBase(testName: testName,
                     compare: ==,
                     toString: { b in b.description },
                     expected: expected,
                     received: received)
} // assertEquals

func assertEquals(testName: String,
                  expected: Int,
                  received: Int) {
    assertEqualsBase(testName: testName,
                     compare: ==,
                     toString: { i in i.description },
                     expected: expected,
                     received: received)
} // assertEquals

func assertEquals(testName: String,
                  expected: String,
                  received: String) {
    assertEqualsBase(testName: testName,
                     compare: ==,
                     toString: { s in s },
                     expected: expected,
                     received: received)
} // assertEquals

func test_isEmpty_empty() {
    let list: MyList<Int> = MyList.empty
    assertEquals(testName: "test_isEmpty_empty",
                 expected: true,
                 received: list.isEmpty())
} // test_isEmpty_empty

func test_isEmpty_cons() {
    let list = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_isEmpty_cons",
                 expected: false,
                 received: list.isEmpty())
} // test_isEmpty_cons

func test_append_empty_empty() {
    let list1: MyList<Int> = MyList.empty
    let list2: MyList<Int> = MyList.empty
    assertEquals(testName: "test_append_empty_empty",
                 expected: MyList.empty,
                 received: list1.append(other: list2))
} // test_append_empty_empty

func test_append_empty_cons_1() {
    let list1: MyList<Int> = MyList.empty
    let list2 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_append_empty_cons_1",
                 expected: MyList.cons(1, MyList.empty),
                 received: list1.append(other: list2))
} // test_append_empty_cons_1

func test_append_empty_cons_2() {
    let list1: MyList<Int> = MyList.empty
    let list2 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_append_empty_cons_2",
                 expected: MyList.cons(1, MyList.cons(2, MyList.empty)),
                 received: list1.append(other: list2))
} // test_append_empty_cons_2

func test_append_cons_1_empty() {
    let list1 = MyList.cons(1, MyList.empty)
    let list2: MyList<Int> = MyList.empty
    assertEquals(testName: "test_append_cons_1_empty",
                 expected: MyList.cons(1, MyList.empty),
                 received: list1.append(other: list2))
} // test_append_cons_1_empty

func test_append_cons_2_empty() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    let list2: MyList<Int> = MyList.empty
    assertEquals(testName: "test_append_cons_2_empty",
                 expected: MyList.cons(1, MyList.cons(2, MyList.empty)),
                 received: list1.append(other: list2))
} // test_append_cons_2_empty

func test_append_cons_1_cons_1() {
    let list1 = MyList.cons(1, MyList.empty)
    let list2 = MyList.cons(2, MyList.empty)
    assertEquals(testName: "test_append_cons_1_cons_1",
                 expected: MyList.cons(1, MyList.cons(2, MyList.empty)),
                 received: list1.append(other: list2))
} // test_append_cons_1_cons_1

func test_append_cons_1_cons_2() {
    let list1 = MyList.cons(1, MyList.empty)
    let list2 = MyList.cons(2, MyList.cons(3, MyList.empty))
    assertEquals(testName: "test_append_cons_1_cons_2",
                 expected: MyList.cons(1, MyList.cons(2, MyList.cons(3, MyList.empty))),
                 received: list1.append(other: list2))
} // test_append_cons_1_cons_2

func test_append_cons_2_cons_1() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    let list2 = MyList.cons(3, MyList.empty)
    assertEquals(testName: "test_append_cons_2_cons_1",
                 expected: MyList.cons(1, MyList.cons(2, MyList.cons(3, MyList.empty))),
                 received: list1.append(other: list2))
} // test_append_cons_2_cons_1

func test_append_cons_2_cons_2() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    let list2 = MyList.cons(3, MyList.cons(4, MyList.empty))
    assertEquals(testName: "test_append_cons_2_cons_2",
                 expected: MyList.cons(1, MyList.cons(2, MyList.cons(3, MyList.cons(4, MyList.empty)))),
                 received: list1.append(other: list2))
} // test_append_cons_2_cons_2

func test_length_empty() {
    let list1: MyList<Int> = MyList.empty
    assertEquals(testName: "test_length_empty",
                 expected: 0,
                 received: list1.length())
} // test_length_empty

func test_length_cons_1() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_length_cons_1",
                 expected: 1,
                 received: list1.length())
} // test_length_cons_1

func test_length_cons_2() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_length_cons_2",
                 expected: 2,
                 received: list1.length())
} // test_length_cons_2

func test_length_cons_3() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.cons(3, MyList.empty)))
    assertEquals(testName: "test_length_cons_2",
                 expected: 3,
                 received: list1.length())
} // test_length_cons_3

func test_foldLeft_empty_1() {
    let list1: MyList<Int> = MyList.empty
    assertEquals(testName: "test_foldLeft_empty_1",
                 expected: 0,
                 received: list1.foldLeft(accum: 0, fold: +))
} // test_foldLeft_empty_1

func test_foldLeft_empty_2() {
    let list1: MyList<Bool> = MyList.empty
    assertEquals(testName: "test_foldLeft_empty_2",
                 expected: false,
                 received: list1.foldLeft(accum: false,
                                          fold: { (b1, b2) in b1 || b2 }))
} // test_foldLeft_empty_2

func test_foldLeft_cons_1_sum() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_foldLeft_cons_1_sum",
                 expected: 1,
                 received: list1.foldLeft(accum: 0,
                                          fold: +))
} // test_foldLeft_cons_1_sum

func test_foldLeft_cons_2_sum() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_foldLeft_cons_2_sum",
                 expected: 3,
                 received: list1.foldLeft(accum: 0,
                                          fold: +))
} // test_foldLeft_cons_2_sum

func test_foldLeft_cons_1_or_1() {
    let list1 = MyList.cons(true, MyList.empty)
    assertEquals(testName: "test_foldLeft_cons_1_or_1",
                 expected: true,
                 received: list1.foldLeft(accum: false,
                                          fold: { (b1, b2) in b1 || b2 }))
} // test_foldLeft_cons_1_or_1

func test_foldLeft_cons_1_or_2() {
    let list1 = MyList.cons(false, MyList.empty)
    assertEquals(testName: "test_foldLeft_cons_1_or_2",
                 expected: false,
                 received: list1.foldLeft(accum: false,
                                          fold: { (b1, b2) in b1 || b2 }))
} // test_foldLeft_cons_1_or_2

func test_foldLeft_cons_2_or_1() {
    let list1 = MyList.cons(true, MyList.cons(true, MyList.empty))
    assertEquals(testName: "test_foldLeft_cons_2_or_1",
                 expected: true,
                 received: list1.foldLeft(accum: false,
                                          fold: { (b1, b2) in b1 || b2 }))
} // test_foldLeft_cons_2_or_1

func test_foldLeft_cons_2_or_2() {
    let list1 = MyList.cons(true, MyList.cons(false, MyList.empty))
    assertEquals(testName: "test_foldLeft_cons_2_or_2",
                 expected: true,
                 received: list1.foldLeft(accum: false,
                                          fold: { (b1, b2) in b1 || b2 }))
} // test_foldLeft_cons_2_or_2

func test_foldLeft_cons_2_or_3() {
    let list1 = MyList.cons(false, MyList.cons(true, MyList.empty))
    assertEquals(testName: "test_foldLeft_cons_2_or_3",
                 expected: true,
                 received: list1.foldLeft(accum: false,
                                          fold: { (b1, b2) in b1 || b2 }))
} // test_foldLeft_cons_2_or_3

func test_foldLeft_cons_2_or_4() {
    let list1 = MyList.cons(false, MyList.cons(false, MyList.empty))
    assertEquals(testName: "test_foldLeft_cons_2_or_4",
                 expected: false,
                 received: list1.foldLeft(accum: false,
                                          fold: { (b1, b2) in b1 || b2 }))
} // test_foldLeft_cons_2_or_4

func test_foldLeft_cons_1_concatenate() {
    let list1 = MyList.cons("foo", MyList.empty)
    assertEquals(testName: "test_foldLeft_cons_1_concatenate",
                 expected: "foo",
                 received: list1.foldLeft(accum: "", fold: +))
} // test_foldLeft_cons_1_concatenate

func test_foldLeft_cons_2_concatenate() {
    let list1 = MyList.cons("foo", MyList.cons("bar", MyList.empty))
    assertEquals(testName: "test_foldLeft_cons_2_concatenate",
                 expected: "foobar",
                 received: list1.foldLeft(accum: "", fold: +))
} // test_foldLeft_cons_2_concatenate

func test_foldLeft_cons_3_concatenate() {
    let list1 = MyList.cons("foo", MyList.cons("bar", MyList.cons("baz", MyList.empty)))
    assertEquals(testName: "test_foldLeft_cons_3_concatenate",
                 expected: "foobarbaz",
                 received: list1.foldLeft(accum: "", fold: +))
} // test_foldLeft_cons_3_concatenate

func test_foldLeft_cons_1_last() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_foldLeft_cons_1_last",
                 expected: 1,
                 received: list1.foldLeft(accum: 0,
                                          fold: { (_, current) in current }))
} // test_foldLeft_cons_1_last

func test_foldLeft_cons_2_last() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_foldLeft_cons_2_last",
                 expected: 2,
                 received: list1.foldLeft(accum: 0,
                                          fold: { (_, current) in current }))
} // test_foldLeft_cons_2_last

func test_foldLeft_cons_3_last() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.cons(3, MyList.empty)))
    assertEquals(testName: "test_foldLeft_cons_3_last",
                 expected: 3,
                 received: list1.foldLeft(accum: 0,
                                          fold: { (_, current) in current }))
} // test_foldLeft_cons_3_last

func test_foldRight_empty_1() {
    let list1: MyList<Int> = MyList.empty
    assertEquals(testName: "test_foldRight_empty_1",
                 expected: 0,
                 received: list1.foldRight(accum: 0, fold: +))
} // test_foldRight_empty_1

func test_foldRight_empty_2() {
    let list1: MyList<Bool> = MyList.empty
    assertEquals(testName: "test_foldRight_empty_2",
                 expected: false,
                 received: list1.foldRight(accum: false,
                                           fold: { (b1, b2) in b1 || b2 }))
} // test_foldRight_empty_2

func test_foldRight_cons_1_copy() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_foldRight_cons_1_copy",
                 expected: MyList.cons(1, MyList.empty),
                 received: list1.foldRight(accum: MyList.empty,
                                           fold: { (current, accum) in
                                               MyList.cons(current, accum) }))
} // test_foldRight_cons_1_copy

func test_foldRight_cons_2_copy() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_foldRight_cons_2_copy",
                 expected: MyList.cons(1, MyList.cons(2, MyList.empty)),
                 received: list1.foldRight(accum: MyList.empty,
                                           fold: { (current, accum) in
                                               MyList.cons(current, accum) }))
} // test_foldRight_cons_2_copy

func test_foldRight_cons_1_concatenate() {
    let list1 = MyList.cons("foo", MyList.empty)
    assertEquals(testName: "test_foldRight_cons_1_concatenate",
                 expected: "foo",
                 received: list1.foldRight(accum: "", fold: +))
} // test_foldRight_cons_1_concatenate

func test_foldRight_cons_2_concatenate() {
    let list1 = MyList.cons("foo", MyList.cons("bar", MyList.empty))
    assertEquals(testName: "test_foldRight_cons_2_concatenate",
                 expected: "foobar",
                 received: list1.foldRight(accum: "", fold: +))
} // test_foldRight_cons_2_concatenate

func test_foldRight_cons_3_concatenate() {
    let list1 = MyList.cons("foo", MyList.cons("bar", MyList.cons("baz", MyList.empty)))
    assertEquals(testName: "test_foldRight_cons_3_concatenate",
                 expected: "foobarbaz",
                 received: list1.foldRight(accum: "", fold: +))
} // test_foldRight_cons_3_concatenate

func test_foldRight_cons_1_last() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_foldRight_cons_1_last",
                 expected: 1,
                 received: list1.foldRight(accum: 0,
                                           fold: { (current, _) in current }))
} // test_foldRight_cons_1_last

func test_foldRight_cons_2_last() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_foldRight_cons_2_last",
                 expected: 1,
                 received: list1.foldRight(accum: 0,
                                           fold: { (current, _) in current }))
} // test_foldRight_cons_2_last

func test_foldRight_cons_3_last() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.cons(3, MyList.empty)))
    assertEquals(testName: "test_foldRight_cons_3_last",
                 expected: 1,
                 received: list1.foldRight(accum: 0,
                                           fold: { (current, _) in current }))
} // test_foldRight_cons_3_last

func test_map_empty_1() {
    let list1: MyList<Int> = MyList.empty
    let expected: MyList<Int> = MyList.empty
    assertEquals(testName: "test_map_empty_1",
                 expected: expected,
                 received: list1.map(mapper: { i in i + 1}))
} // test_map_empty_1

func test_map_empty_2() {
    let list1: MyList<Bool> = MyList.empty
    let expected: MyList<Int> = MyList.empty
    assertEquals(testName: "test_map_empty_2",
                 expected: expected,
                 received: list1.map(mapper: { _ in 5 }))
} // test_map_empty_2

func test_map_cons_1_lengths() {
    let list1 = MyList.cons("foo", MyList.empty)
    assertEquals(testName: "test_map_cons_1_lengths",
                 expected: MyList.cons(3, MyList.empty),
                 received: list1.map(mapper: { s in s.count }))
} // test_map_cons_1_lengths

func test_map_cons_2_lengths() {
    let list1 = MyList.cons("foo", MyList.cons("foobar", MyList.empty))
    assertEquals(testName: "test_map_cons_2_lengths",
                 expected: MyList.cons(3, MyList.cons(6, MyList.empty)),
                 received: list1.map(mapper: { s in s.count }))
} // test_map_cons_2_lengths

func test_map_cons_3_lengths() {
    let list1 = MyList.cons("foo", MyList.cons("foobar", MyList.cons("apple", MyList.empty)))
    assertEquals(testName: "test_map_cons_3_lengths",
                 expected: MyList.cons(3, MyList.cons(6, MyList.cons(5, MyList.empty))),
                 received: list1.map(mapper: { s in s.count }))
} // test_map_cons_3_lengths

func test_map_cons_1_strings() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_map_cons_1_strings",
                 expected: MyList.cons("1", MyList.empty),
                 received: list1.map(mapper: { i in i.description }))
} // test_map_cons_1_strings

func test_map_cons_2_strings() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_map_cons_2_strings",
                 expected: MyList.cons("1", MyList.cons("2", MyList.empty)),
                 received: list1.map(mapper: { i in i.description }))
} // test_map_cons_2_strings

func test_map_cons_3_strings() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.cons(3, MyList.empty)))
    assertEquals(testName: "test_map_cons_3_strings",
                 expected: MyList.cons("1", MyList.cons("2", MyList.cons("3", MyList.empty))),
                 received: list1.map(mapper: { i in i.description }))
} // test_map_cons_3_strings

func test_filter_empty_integers() {
    let list1: MyList<Int> = MyList.empty
    assertEquals(testName: "test_filter_empty_integers",
                 expected: MyList.empty,
                 received: list1.filter(predicate: { i in i > 5 }))
} // test_filter_empty_integers

func test_filter_empty_strings() {
    let list1: MyList<String> = MyList.empty
    assertEquals(testName: "test_filter_empty_strings",
                 expected: MyList.empty,
                 received: list1.filter(predicate: { s in s.count > 3 }))
} // test_filter_empty_strings

func test_filter_cons_1_integers() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_filter_cons_1_integers",
                 expected: MyList.empty,
                 received: list1.filter(predicate: { i in i > 5 }))
} // test_filter_cons_1_integers

func test_filter_cons_2_integers() {
    let list1 = MyList.cons(1, MyList.cons(6, MyList.empty))
    assertEquals(testName: "test_filter_cons_2_integers",
                 expected: MyList.cons(6, MyList.empty),
                 received: list1.filter(predicate: { i in i > 5 }))
} // test_filter_cons_2_integers

func test_filter_cons_3_integers() {
    let list1 = MyList.cons(1, MyList.cons(6, MyList.cons(7, MyList.empty)))
    assertEquals(testName: "test_filter_cons_3_integers",
                 expected: MyList.cons(6, MyList.cons(7, MyList.empty)),
                 received: list1.filter(predicate: { i in i > 5 }))
} // test_filter_cons_3_integers

func test_filter_cons_4_integers() {
    let list1 = MyList.cons(1, MyList.cons(6, MyList.cons(7, MyList.cons(3, MyList.empty))))
    assertEquals(testName: "test_filter_cons_4_integers",
                 expected: MyList.cons(6, MyList.cons(7, MyList.empty)),
                 received: list1.filter(predicate: { i in i > 5 }))
} // test_filter_cons_4_integers

func test_filter_cons_1_strings() {
    let list1 = MyList.cons("foo", MyList.empty)
    assertEquals(testName: "test_filter_cons_1_strings",
                 expected: MyList.empty,
                 received: list1.filter(predicate: { s in s.count > 3 }))
} // test_filter_cons_1_strings

func test_filter_cons_2_strings() {
    let list1 = MyList.cons("foo", MyList.cons("foobar", MyList.empty))
    assertEquals(testName: "test_filter_cons_2_strings",
                 expected: MyList.cons("foobar", MyList.empty),
                 received: list1.filter(predicate: { s in s.count > 3 }))
} // test_filter_cons_2_strings

func test_filter_cons_3_strings() {
    let list1 = MyList.cons("foo", MyList.cons("foobar", MyList.cons("a", MyList.empty)))
    assertEquals(testName: "test_filter_cons_3_strings",
                 expected: MyList.cons("foobar", MyList.empty),
                 received: list1.filter(predicate: { s in s.count > 3 }))
} // test_filter_cons_3_strings

func test_filter_cons_4_strings() {
    let list1 = MyList.cons("foo", MyList.cons("foobar", MyList.cons("a", MyList.cons("apple", MyList.empty))))
    assertEquals(testName: "test_filter_cons_4_strings",
                 expected: MyList.cons("foobar", MyList.cons("apple", MyList.empty)),
                 received: list1.filter(predicate: { s in s.count > 3 }))
} // test_filter_cons_4_strings 

func test_toString_empty_integers() {
    let list1: MyList<Int> = MyList.empty
    assertEquals(testName: "test_toString_empty_integers",
                 expected: "[]",
                 received: list1.toString(innerToString: { i in i.description }))
} // test_toString_empty_integers

func test_toString_cons_1_integers() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_toString_cons_1_integers",
                 expected: "[1]",
                 received: list1.toString(innerToString: { i in i.description }))
} // test_toString_cons_1_integers

func test_toString_cons_2_integers() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_toString_cons_2_integers",
                 expected: "[1, 2]",
                 received: list1.toString(innerToString: { i in i.description }))
} // test_toString_cons_2_integers

func test_toString_cons_3_integers() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.cons(3, MyList.empty)))
    assertEquals(testName: "test_toString_cons_3_integers",
                 expected: "[1, 2, 3]",
                 received: list1.toString(innerToString: { i in i.description }))
} // test_toString_cons_3_integers

func test_toString_empty_strings() {
    let list1: MyList<String> = MyList.empty
    assertEquals(testName: "test_toString_empty_strings",
                 expected: "[]",
                 received: list1.toString(innerToString: { s in s }))
} // test_toString_empty_strings

func test_toString_cons_1_strings() {
    let list1 = MyList.cons("foo", MyList.empty)
    assertEquals(testName: "test_toString_cons_1_strings",
                 expected: "[foo]",
                 received: list1.toString(innerToString: { s in s }))
} // test_toString_cons_1_strings

func test_toString_cons_2_strings() {
    let list1 = MyList.cons("foo", MyList.cons("bar", MyList.empty))
    assertEquals(testName: "test_toString_cons_2_strings",
                 expected: "[foo, bar]",
                 received: list1.toString(innerToString: { s in s }))
} // test_toString_cons_2_strings

func test_toString_cons_3_strings() {
    let list1 = MyList.cons("foo", MyList.cons("bar", MyList.cons("baz", MyList.empty)))
    assertEquals(testName: "test_toString_cons_3_strings",
                 expected: "[foo, bar, baz]",
                 received: list1.toString(innerToString: { s in s }))
} // test_toString_cons_3_strings

func test_contains_empty_integers() {
    let list1: MyList<Int> = MyList.empty
    assertEquals(testName: "test_contains_empty_integers",
                 expected: false,
                 received: list1.contains(target: 1, compare: ==))
} // test_contains_empty_integers

func test_contains_empty_strings() {
    let list1: MyList<String> = MyList.empty
    assertEquals(testName: "test_contains_empty_strings",
                 expected: false,
                 received: list1.contains(target: "foo", compare: ==))
} // test_contains_empty_strings

func test_contains_cons_1_integers_1() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_contains_cons_1_integers_1",
                 expected: false,
                 received: list1.contains(target: 0, compare: ==))
} // test_contains_cons_1_integers_1

func test_contains_cons_1_integers_2() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_contains_cons_1_integers_2",
                 expected: true,
                 received: list1.contains(target: 1, compare: ==))
} // test_contains_cons_1_integers_2

func test_contains_cons_2_integers_1() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_contains_cons_2_integers_1",
                 expected: false,
                 received: list1.contains(target: 0, compare: ==))
} // test_contains_cons_2_integers_1

func test_contains_cons_2_integers_2() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_contains_cons_2_integers_2",
                 expected: true,
                 received: list1.contains(target: 1, compare: ==))
} // test_contains_cons_2_integers_2

func test_contains_cons_2_integers_3() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_contains_cons_2_integers_3",
                 expected: true,
                 received: list1.contains(target: 2, compare: ==))
} // test_contains_cons_2_integers_3

func test_contains_cons_1_strings_1() {
    let list1 = MyList.cons("foo", MyList.empty)
    assertEquals(testName: "test_contains_cons_1_strings_1",
                 expected: false,
                 received: list1.contains(target: "blah", compare: ==))
} // test_contains_cons_1_strings_1

func test_contains_cons_1_strings_2() {
    let list1 = MyList.cons("foo", MyList.empty)
    assertEquals(testName: "test_contains_cons_1_strings_2",
                 expected: true,
                 received: list1.contains(target: "foo", compare: ==))
} // test_contains_cons_1_strings_2

func test_contains_cons_2_strings_1() {
    let list1 = MyList.cons("foo", MyList.cons("bar", MyList.empty))
    assertEquals(testName: "test_contains_cons_2_strings_1",
                 expected: false,
                 received: list1.contains(target: "blah", compare: ==))
} // test_contains_cons_2_strings_1

func test_contains_cons_2_strings_2() {
    let list1 = MyList.cons("foo", MyList.cons("bar", MyList.empty))
    assertEquals(testName: "test_contains_cons_2_strings_2",
                 expected: true,
                 received: list1.contains(target: "foo", compare: ==))
} // test_contains_cons_2_strings_2

func test_contains_cons_2_strings_3() {
    let list1 = MyList.cons("foo", MyList.cons("bar", MyList.empty))
    assertEquals(testName: "test_contains_cons_2_strings_3",
                 expected: true,
                 received: list1.contains(target: "bar", compare: ==))
} // test_contains_cons_2_strings_3

func test_sum_empty() {
    let list1: MyList<Int> = MyList.empty
    assertEquals(testName: "test_sum_empty",
                 expected: 0,
                 received: list1.sum(zero: 0, add: +))
} // test_sum_empty

func test_sum_cons_1() {
    let list1 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_sum_cons_1",
                 expected: 1,
                 received: list1.sum(zero: 0, add: +))
} // test_sum_cons_1

func test_sum_cons_2() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_sum_cons_2",
                 expected: 3,
                 received: list1.sum(zero: 0, add: +))
} // test_sum_cons_2

func test_sum_cons_3() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.cons(3, MyList.empty)))
    assertEquals(testName: "test_sum_cons_3",
                 expected: 6,
                 received: list1.sum(zero: 0, add: +))
} // test_sum_cons_3

func test_equals_empty_lists() {
    let list1: MyList<Int> = MyList.empty
    let list2: MyList<Int> = MyList.empty
    assertEquals(testName: "test_equals_empty_lists",
                 expected: true,
                 received: list1.equals(otherList: list2, compareInner: ==))
} // test_equals_empty_lists

func test_equals_cons_1_are_equal() {
    let list1 = MyList.cons(1, MyList.empty)
    let list2 = MyList.cons(1, MyList.empty)
    assertEquals(testName: "test_equals_cons_1_are_equal",
                 expected: true,
                 received: list1.equals(otherList: list2, compareInner: ==))
} // test_equals_cons_1_are_equal

func test_equals_cons_1_are_not_equal_different_contents() {
    let list1 = MyList.cons(1, MyList.empty)
    let list2 = MyList.cons(2, MyList.empty)
    assertEquals(testName: "test_equals_cons_1_are_not_equal_different_contents",
                 expected: false,
                 received: list1.equals(otherList: list2, compareInner: ==))
} // test_equals_cons_1_are_not_equal_different_contents

func test_equals_cons_1_are_not_equal_different_lengths() {
    let list1 = MyList.cons(1, MyList.empty)
    let list2 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_equals_cons_1_are_not_equal_different_lengths",
                 expected: false,
                 received: list1.equals(otherList: list2, compareInner: ==))
} // test_equals_cons_1_are_not_equal_different_lengths

func test_equals_cons_2_are_equal() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    let list2 = MyList.cons(1, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_equals_cons_2_are_equal",
                 expected: true,
                 received: list1.equals(otherList: list2, compareInner: ==))
} // test_equals_cons_2_are_equal

func test_equals_cons_2_are_not_equal_different_contents_1() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    let list2 = MyList.cons(2, MyList.cons(2, MyList.empty))
    assertEquals(testName: "test_equals_cons_2_are_not_equal_different_contents_1",
                 expected: false,
                 received: list1.equals(otherList: list2, compareInner: ==))
} // test_equals_cons_2_are_not_equal_different_contents_1

func test_equals_cons_2_are_not_equal_different_contents_2() {
    let list1 = MyList.cons(1, MyList.cons(2, MyList.empty))
    let list2 = MyList.cons(1, MyList.cons(3, MyList.empty))
    assertEquals(testName: "test_equals_cons_2_are_not_equal_different_contents_2",
                 expected: false,
                 received: list1.equals(otherList: list2, compareInner: ==))
} // test_equals_cons_2_are_not_equal_different_contents_2

func runTests() {
    // isEmpty
    test_isEmpty_empty()
    test_isEmpty_cons()

    // append
    test_append_empty_empty()
    test_append_empty_cons_1()
    test_append_empty_cons_2()
    test_append_cons_1_empty()
    test_append_cons_2_empty()
    test_append_cons_1_cons_1()
    test_append_cons_1_cons_2()
    test_append_cons_2_cons_1()
    test_append_cons_2_cons_2()

    // length
    test_length_empty()
    test_length_cons_1()
    test_length_cons_2()
    test_length_cons_3()

    // foldLeft
    test_foldLeft_empty_1()
    test_foldLeft_empty_2()
    test_foldLeft_cons_1_sum()
    test_foldLeft_cons_2_sum()
    test_foldLeft_cons_1_or_1()
    test_foldLeft_cons_1_or_2()
    test_foldLeft_cons_2_or_1()
    test_foldLeft_cons_2_or_2()
    test_foldLeft_cons_2_or_3()
    test_foldLeft_cons_2_or_4()
    test_foldLeft_cons_1_concatenate()
    test_foldLeft_cons_2_concatenate()
    test_foldLeft_cons_3_concatenate()
    test_foldLeft_cons_1_last()
    test_foldLeft_cons_2_last()
    test_foldLeft_cons_3_last()
    
    // foldRight
    test_foldRight_empty_1()
    test_foldRight_empty_2()
    test_foldRight_cons_1_copy()
    test_foldRight_cons_2_copy()
    test_foldRight_cons_1_concatenate()
    test_foldRight_cons_2_concatenate()
    test_foldRight_cons_3_concatenate()
    test_foldRight_cons_1_last()
    test_foldRight_cons_2_last()
    test_foldRight_cons_3_last()

    // map
    test_map_empty_1()
    test_map_empty_2()
    test_map_cons_1_lengths()
    test_map_cons_2_lengths()
    test_map_cons_3_lengths()
    test_map_cons_1_strings()
    test_map_cons_2_strings()
    test_map_cons_3_strings()

    // filter
    test_filter_empty_integers()
    test_filter_empty_strings()
    test_filter_cons_1_integers()
    test_filter_cons_2_integers()
    test_filter_cons_3_integers()
    test_filter_cons_4_integers()
    test_filter_cons_1_strings()
    test_filter_cons_2_strings()
    test_filter_cons_3_strings()
    test_filter_cons_4_strings()
    
    // toString
    test_toString_empty_integers()
    test_toString_cons_1_integers()
    test_toString_cons_2_integers()
    test_toString_cons_3_integers()
    test_toString_empty_strings()
    test_toString_cons_1_strings()
    test_toString_cons_2_strings()
    test_toString_cons_3_strings()

    // contains
    test_contains_empty_integers()
    test_contains_empty_strings()
    test_contains_cons_1_integers_1()
    test_contains_cons_1_integers_2()
    test_contains_cons_2_integers_1()
    test_contains_cons_2_integers_2()
    test_contains_cons_2_integers_3()
    test_contains_cons_1_strings_1()
    test_contains_cons_1_strings_2()
    test_contains_cons_2_strings_1()
    test_contains_cons_2_strings_2()
    test_contains_cons_2_strings_3()

     // sum
    test_sum_empty()
    test_sum_cons_1()
    test_sum_cons_2()
    test_sum_cons_3()

    // equals
    test_equals_empty_lists()
    test_equals_cons_1_are_equal()
    test_equals_cons_1_are_not_equal_different_contents()
    test_equals_cons_1_are_not_equal_different_lengths()
    test_equals_cons_2_are_equal()
    test_equals_cons_2_are_not_equal_different_contents_1()
    test_equals_cons_2_are_not_equal_different_contents_2()
} // runTests
// ---END TEST SUITE---

// ---BEGIN MAIN---
runTests()
// ---END MAIN---


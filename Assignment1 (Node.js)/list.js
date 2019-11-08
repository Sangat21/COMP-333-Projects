// COMP 333 Assignment 1
//
// WORKING WITH NODE
// You will need node.js (https://nodejs.org/en/) installed and working
// to run this.  It's also possible, with some tweaking, to get it working
// in a Web browser.  In that case, you probably will want to replace
// `console.log` with some output routine.
//
// To work with node from the command line, you can do the following:
// 1.) Go to the directory containing the file (using the cd command)
// 2.) Start node.js with the `node` command
// 3.) Within the node.js prompt, type `.load list.js` and hit enter.
//     This will read your program.
// 4.) Run the tests by typing `runTests()` and hitting enter.
//     This will execute the `runTests()` function in this file.
//
// ASSIGNMENT: IMMUTABLE SINGLY-LINKED LIST IMPLEMENTATION
// In this assignment, you'll be defining code for an immutable
// singly-linked list.  Lists are constructed with two kinds of objects:
// - A `Cons` object represents a non-empty list.  It holds a single
//   element of the list, along with the rest of the list.
// - A `Nil` object represents an empty list, containing no elements,
//   and no other elements.
// These objects are not wrapped around anything; if you take a list,
// you take `Cons` or `Nil` objects.
//
// This list is intended to be used in an immutable way.  This means
// For example, there is an `append` operation, but `append` does
// not modify the list it was called on.  Instead, `append` will
// return a new list, representing the result of the append.  For
// example, if we append `[1, 2]` onto `[3, 4, 5]`, `append` will
// return a new list representing `[1, 2, 3, 4, 5]`, and the
// original lists `[1, 2]`, and `[3, 4, 5]` will be unchanged.
//
// Your goal with this assignment is to get all the tests to pass,
// without modifying any of the testing code.  There are enough
// unit tests that they serve as a (possibly incomplete) specification
// of what the code needs to do.
//
// HINTS:
// 1.) The join function has been provided to you, but you'll need to
//     implement a join method.  You can use the provided join function
//     to assist with this.
// 2.) The behaviors for `append`, `contains`, and `length` differ
//     depending on whether or not they are called on `Cons` or `Nil`.
//     Some tests force you to use virtual dispatch to encode this
//     difference.
// 3.) Singly-linked lists are a recursive data structure, and
//     the methods can most naturally be implemented with recursion.
// 4.) My reference solution contains 50 lines of code.  If you start
//     needing dramatically more than 50 lines, talk to me to make
//     sure you're on the right track.
// 5.) Many tests depend on the `toString` method working correctly;
//     you should try to get `toString` working before the other
//     methods.

// join
//
// Parameters:
// - A List of elements
// - A delimeter to separate them by
// Returns a single string, which results from calling
// toString on each element, separated by the delimeter.
//
// For example:
// join(new Nil(), ", ")                     // "[]"
// join(new Cons(1, new Nil()), ", ")        // [1]
// join(new Cons(2, new Cons(3, new Nil())), // [2, 3]
//


function join(list, delim) {
    var retval = "[";
    while (list instanceof Cons &&
           !(list.tail() instanceof Nil)) {
        retval += list.head().toString() + delim;
        list = list.tail();
    }
    if (list instanceof Cons) {
        retval += list.head().toString();
    }
    retval += "]";
    return retval;
} // join

// TODO: write your code below *************###################

function Cons(h, t)
{
  this.h = h;
  this.t = t;
}
function Nil() {}
function List()
{

}

//List.prototype.toString = function () { return '';};

// List Methods
List.prototype.toString = function() { return join(this, ", ")};
List.prototype.join = function(param) { return join(this, param);};

// Inheritance from List
Cons.prototype = Object.create(List.prototype);
Nil.prototype = Object.create(List.prototype);

// Cons Methods
Cons.prototype.head = function() {
  return this.h;
};
Cons.prototype.tail = function() {
  return this.t;
};
Cons.prototype.length = function() {
  return 1 + (this.t).length();
}
Cons.prototype.append = function(list) {
  /*
  let e = this;
  while (e instanceof Cons &&
         !(e.tail() instanceof Nil))
  {
    e = e.tail();
  }
  e.t = list;
  return this;*/
  let newList = new Cons(this.head(), this.tail().append(list));
  return newList;
  /*
  let current = this;
  let newList = new Cons(current.head());
  let result;


    while (current instanceof Cons &&
        !(current.tail() instanceof Nil)){
            current = current.tail();
            newList.t = new Cons(current.head(), current.tail());
            result = newList;
            newList = newList.t;
        }
    result.t = list;
    return result;*/
}

Cons.prototype.contains = function(x) {
  let e = (this);
  var i = 0;
  while(i < this.length())
  {
    if(e.h == x) { return true; }
    else {
      e = e.t;
    }
    i++;
  }
  return false;
}
Cons.prototype.init = function()
{
  let e = this;
  if(e.tail() instanceof Nil)
  {
    e = new Nil();
    return e;
  }
  while (e instanceof Cons && !(e.tail().tail() instanceof Nil))
  {
    e = e.t;
  }
  e.t = e.t.t;
  return this;
}
// Nil Methods
Nil.prototype.length = function() { return 0; };
Nil.prototype.append = function(list) { return list; }
Nil.prototype.contains = function(x) { return false; }




// ---BEGIN CODE FOR TESTING---
// Do not modify!  When I test your code myself,
// I won't use this code below, so I won't be working
// with any of your modifications!
function runTest(test) {
    process.stdout.write(test.name + ": ");
    try {
        test();
        process.stdout.write("pass\n");
    } catch (error) {
        process.stdout.write("FAIL\n");
        console.log(error);
    }
} // runTest

function assertEquals(expected, received) {
    if (expected !== received) {
        throw ("\tExpected: " + expected.toString() + "\n" +
               "\tReceived: " + received.toString());
    }
} // assertEquals

function test_nil_join() {
    let nil = new Nil();
    assertEquals("[]",
                 nil.join(", "));
} // test_nil_join

function test_nil_toString() {
    let nil = new Nil();
    assertEquals("[]",
                 nil.toString());
} // test_nil_toString

function test_nil_instanceof_list() {
    let nil = new Nil();
    assertEquals(true,
                 nil instanceof List);
} // test_nil_instanceof_list

function test_nil_has_no_head() {
    let nil = new Nil();
    assertEquals(false,
                 nil.hasOwnProperty("head"));
} // test_nil_has_no_head

function test_nil_has_no_tail() {
    let nil = new Nil();
    assertEquals(false,
                 nil.hasOwnProperty("tail"));
} // test_nil_has_no_tail

function test_nil_has_no_init() {
    let nil = new Nil();
    assertEquals(false,
                 nil.hasOwnProperty("init"));
} // test_nil_has_no_init

function test_nil_length() {
    let nil = new Nil();
    assertEquals(0,
                 nil.length());
} // test_nil_length

function test_cons_instanceof_list() {
    let list = new Cons(1, new Nil());
    assertEquals(true,
                 list instanceof List);
} // test_cons_instanceof_list

function test_cons_join_single_element() {
    let list = new Cons(1, new Nil());
    assertEquals("[1]",
                 list.join(":"));
} // test_cons_join_single_element

function test_cons_join_two_elements() {
    let list = new Cons(1, new Cons(2, new Nil()));
    assertEquals("[1:2]",
                 list.join(":"));
} // test_cons_join_two_elements

function test_cons_join_three_elements() {
    let list = new Cons(1, new Cons(2, new Cons(3, new Nil())));
    assertEquals("[1:2:3]",
                 list.join(":"));
} // test_cons_join_three_elements

function test_cons_toString_single_element() {
    let list = new Cons(1, new Nil());
    assertEquals("[1]",
                 list.toString());
} // test_cons_toString_single_element

function test_cons_toString_two_elements() {
    let list = new Cons(1, new Cons(2, new Nil()));
    assertEquals("[1, 2]",
                 list.toString());
} // test_cons_toString_two_elements

function test_cons_toString_three_elements() {
    let list = new Cons(1, new Cons(2, new Cons(3, new Nil())));
    assertEquals("[1, 2, 3]",
                 list.toString());
} // test_cons_toString_three_elements

function test_cons_head() {
    let list = new Cons(1, new Nil());
    assertEquals(1,
                 list.head());
} // test_cons_head

function test_cons_empty_tail() {
    let list = new Cons(1, new Nil());
    assertEquals("[]",
                 list.tail().toString());
} // test_cons_empty_tail

function test_cons_nonempty_tail() {
    let list = new Cons(1, new Cons(2, new Nil()));
    assertEquals("[2]",
                 list.tail().toString());
} // test_cons_nonempty_tail

function test_cons_length_1() {
    let list = new Cons("a", new Nil());
    assertEquals(1,
                 list.length());
} // test_cons_length_1

function test_cons_length_2() {
    let list = new Cons("a", new Cons("b", new Nil()));
    assertEquals(2,
                 list.length());
} // test_cons_length_2

function test_cons_init_empty() {
    let list = new Cons(1, new Nil());
    assertEquals("[]",
                 list.init().toString());
} // test_cons_init_empty

function test_cons_init_length_1() {
    let list = new Cons(1, new Cons(2, new Nil()));
    assertEquals("[1]",
                 list.init().toString());
} // test_cons_init_length_1

function test_cons_init_length_2() {
    let list = new Cons(1, new Cons(2, new Cons(3, new Nil())));
    assertEquals("[1, 2]",
                 list.init().toString());
} // test_cons_init_length_2

function test_nil_nil_append() {
    let nil1 = new Nil();
    let nil2 = new Nil();
    assertEquals("[]",
                 nil1.append(nil2).toString());
} // test_nil_nil_append

function test_nil_cons_append() {
    let nil = new Nil();
    let list = new Cons(1, new Cons(2, new Nil()));
    assertEquals("[1, 2]",
                 nil.append(list).toString());
} // test_nil_cons_append

function test_cons_nil_append() {
    let list = new Cons(1, new Cons(2, new Nil()));
    let nil = new Nil();
    assertEquals("[1, 2]",
                 list.append(nil).toString());
} // test_cons_nil_append

function test_cons_cons_append_1() {
    let list1 = new Cons(1, new Cons(2, new Nil()));
    let list2 = new Cons(3, new Cons(4, new Cons(5, new Nil())));
    assertEquals("[1, 2, 3, 4, 5]",
                 list1.append(list2).toString());
} // test_cons_cons_append_1

function test_cons_cons_append_2() {
    let list1 = new Cons(1, new Cons(2, new Nil()));
    let list2 = new Cons(3, new Cons(4, new Cons(5, new Nil())));
    assertEquals("[3, 4, 5, 1, 2]",
                 list2.append(list1).toString());
} // test_cons_cons_append_2

function test_nil_contains() {
    let nil = new Nil();
    assertEquals(false,
                 nil.contains(1));
} // test_nil_contains

function test_cons_contains_first() {
    let list = new Cons(1, new Cons(2, new Cons(3, new Nil())));
    assertEquals(true,
                 list.contains(1));
} // test_cons_contains_first

function test_cons_contains_second() {
    let list = new Cons(1, new Cons(2, new Cons(3, new Nil())));
    assertEquals(true,
                 list.contains(2));
} // test_cons_contains_second

function test_cons_contains_nowhere() {
    let list = new Cons(1, new Cons(2, new Cons(3, new Nil())));
    assertEquals(false,
                 list.contains(4));
} // test_cons_contains_nowhere

function test_nil_and_cons_have_different_prototypes() {
    let nil = new Nil();
    let cons = new Cons(1, new Nil());
    assertEquals(false,
                 Object.getPrototypeOf(nil) == Object.getPrototypeOf(cons));
} // test_nil_and_cons_have_different_prototypes

function getGrandparent(obj) {
    return Object.getPrototypeOf(Object.getPrototypeOf(obj));
} // getGrandparent

function test_nil_and_cons_have_same_grandparent_prototypes() {
    let nil = new Nil();
    let cons = new Cons(1, new Nil());
    assertEquals(getGrandparent(nil),
                 getGrandparent(cons));
} // test_nil_and_cons_have_same_grandparent_prototypes

function test_nil_grandparent_prototype_has_join() {
    let nil = new Nil();
    assertEquals(true,
                 getGrandparent(nil).hasOwnProperty("join"));
} // test_nil_grandparent_prototype_has_join

function test_nil_grandparent_prototype_has_toString() {
    let cons = new Cons(1, new Nil());
    assertEquals(true,
                 getGrandparent(cons).hasOwnProperty("toString"));
} // test_nil_grandparent_prototype_has_toString

function test_nil_and_cons_have_different_append() {
    let nil = new Nil();
    let cons = new Cons(1, new Nil());
    assertEquals(false,
                 nil.append == cons.append);
} // test_nil_and_cons_have_different_append

function test_nil_and_cons_have_different_contains() {
    let nil = new Nil();
    let cons = new Cons(1, new Nil());
    assertEquals(false,
                 nil.contains == cons.contains);
} // test_nil_and_cons_have_different_contains

function test_nil_and_cons_have_different_length() {
    let nil = new Nil();
    let cons = new Cons(1, new Nil());
    assertEquals(false,
                 nil.length == cons.length);
} // test_nil_and_cons_have_different_length

function runTests() {
    // ---begin tests for nil---

    // instanceof
    runTest(test_nil_instanceof_list);

    // join
    runTest(test_nil_join);

    // toString
    runTest(test_nil_toString);

    // head
    runTest(test_nil_has_no_head);

    // tail
    runTest(test_nil_has_no_tail);

    // init
    runTest(test_nil_has_no_init);

    // length
    runTest(test_nil_length);

    // append
    runTest(test_nil_nil_append);
    runTest(test_nil_cons_append);

    // contains
    runTest(test_nil_contains);
    // ---end tests for nil---

    // ---begin tests for cons---

    // join
    runTest(test_cons_join_single_element);
    runTest(test_cons_join_two_elements);
    runTest(test_cons_join_three_elements);

    // toString
    runTest(test_cons_toString_single_element);
    runTest(test_cons_toString_two_elements);
    runTest(test_cons_toString_three_elements);

    // instanceof
    runTest(test_cons_instanceof_list);

    // head
    runTest(test_cons_head);

    // tail
    runTest(test_cons_empty_tail);
    runTest(test_cons_nonempty_tail);

    // length
    runTest(test_cons_length_1);
    runTest(test_cons_length_2);

    // init
    runTest(test_cons_init_empty);
    runTest(test_cons_init_length_1);
    runTest(test_cons_init_length_2);

    // append
    runTest(test_cons_nil_append);
    runTest(test_cons_cons_append_1);
    runTest(test_cons_cons_append_2);

    // contains
    runTest(test_cons_contains_first);
    runTest(test_cons_contains_second);
    runTest(test_cons_contains_nowhere);
    // ---end tests for cons---

    // ---begin tests relating to prototypes---
    runTest(test_nil_and_cons_have_different_prototypes);
    runTest(test_nil_and_cons_have_same_grandparent_prototypes);
    runTest(test_nil_grandparent_prototype_has_join);
    runTest(test_nil_grandparent_prototype_has_toString);
    runTest(test_nil_and_cons_have_different_append);
    runTest(test_nil_and_cons_have_different_contains);
    runTest(test_nil_and_cons_have_different_length);
    // ---end tests relating to prototypes---
} // runTests

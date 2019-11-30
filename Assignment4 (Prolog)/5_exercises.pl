% Below we have some logical facts and some potential queries
% that could be run with those facts.  Your goal is to fill
% in what these queries do.  Ignore any warnings for this file.
% As a hint, you can run this file directly by:
%
% swipl -s 5_exercises.pl
%
% ...and then issuing the queries at the prompt.

% Consider the following Prolog logicbase:

a(a1,1).
a(A,2).
a(a3,N).

b(1,b1).
b(2,B).
b(N,b3).

c(X,Y) :- 
        a(X,N),
        b(N,Y).

d(X,Y) :- 
        a(X,N),
        b(Y,N).

d(X,Y) :- 
        a(N,X),
        b(N,Y).

% Write out whether or not the following queries are true or
% false, replacing `???` where appropriate.
% If a query is true and involves variable instantiations, then write out
% all possible variable instantiations which make the query
% true.  Some have already been done for you, to give an
% example of the expected format.  If you wish, you may simply
% copy and paste the output of SWI-PL here directly; we will be grading
% this by hand, so the output format isn't important.

% QUERY: a(X, 2).
% ANSWER: true, X = a3

% QUERY: c(X,Y).
% ANSWER: (X = a1, Y = b1), (X = a1, Y = b3), true, Y = b3, (X = a3, Y = b1), X = a3, (X = a3, Y = b3)

% QUERY: b(X,kalamazoo).
% ANSWER: X = 2; false

% QUERY: c(X,b3).
% ANSWER: ???

% QUERY: c(A, B).
% ANSWER: ???

% QUERY: c(X, X).
% ANSWER: ???

% QUERY: d(X, Y).
% ANSWER: ???

% QUERY: d(X, X).
% ANSWER: ???


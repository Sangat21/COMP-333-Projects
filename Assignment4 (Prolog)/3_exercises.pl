% Below we have some logical facts and some potential queries
% that could be run with those facts.  Your goal is to fill
% in what these queries do.  Ignore any warnings for this file.
% As a hint, you can run this file directly by:
%
% swipl -s 3_exercises.pl
%
% ...and then issuing the queries at the prompt.

% Consider the following Prolog logicbase:

easy(1).
easy(2).
easy(3).

gizmo(a,1).
gizmo(b,3).
gizmo(a,2).
gizmo(d,5).
gizmo(c,3).
gizmo(a,3).
gizmo(c,4).

% Write out whether or not the following queries are true or
% false, replacing `???` where appropriate.
% If a query is true and involves variable instantiations, then write out
% all possible variable instantiations which make the query
% true.  Some have already been done for you.  If you wish, you may simply
% copy and paste the output of SWI-PL here directly; we will be grading
% this by hand, so the output format isn't important.


% QUERY: easy(2).
% ANSWER: true

% QUERY: gizmo(a,X).
% ANSWER: X = 1, X = 2, X = 3

% QUERY: easy(X).
% ANSWER: X = 1, X = 2, X = 3

% QUERY: gizmo(X,3).
% ANSWER: X = b, X = c, X = a

% QUERY: gizmo(d,Y).
% ANSWER: Y = 5

% QUERY: gizmo(X,X).
% ANSWER: false

% Consider this logicbase:

harder(a,1).
harder(c,X).
harder(b,4).
harder(d,2).

% Again, replace `???` where appropriate below:

% QUERY: harder(a,X).
% ANSWER: X = 1

% QUERY: harder(c,X).
% ANSWER: true

% QUERY: harder(X,1).
% ANSWER: X = a, X = c, false

% QUERY: harder(X,4).
% ANSWER: X = c, X = b, false


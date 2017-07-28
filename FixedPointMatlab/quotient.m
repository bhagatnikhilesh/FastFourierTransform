

function [Q,R] = quotient(numerator,denominator)
% quotient: divides two integers, computing a quotient and remainder
%
% usage: [Q,R] = quotient(numerator,denominator);
%  numerator,denominator - integer scalar numeric variables
%
% arguments: (output)
%  Q,R - integers such that (numerator = Q*denominator + R)
%        R has the property that it will be smaller
%        in magnitude than numerator.

% is the denominator zero?
if denominator == 0
  error('Divide by zero')
end

% use matlab's divide operator.
Q = fix(numerator./denominator);    % Fix will round to zero.
R = numerator - Q.*denominator;
end




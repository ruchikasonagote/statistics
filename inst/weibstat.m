## Copyright (C) 2006 Arno Onken
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{m}, @var{v}] =} weibstat (@var{alpha}, @var{sigma})
## Returns mean and variance of the weibull distribution
##
## Arguments are
##
## @itemize
## @item
## @var{alpha} is the shape parameter of the weibull distribution.
## @var{alpha} must be positive
## @item
## @var{sigma} is the scale parameter of the weibull distribution.
## @var{sigma} must be positive
## @end itemize
## @var{alpha} and @var{sigma} must be of common size or one of them must be
## scalar
##
## Return values are
##
## @itemize
## @item
## @var{m} is the mean of the weibull distribution
## @item
## @var{v} is the variance of the weibull distribution
## @end itemize
##
## Examples:
##
## @example
## alpha = 1:6;
## sigma = 3:8;
## [m, v] = weibstat (alpha, sigma)
##
## [m, v] = weibstat (alpha, 6)
## @end example
##
## References:
##
## @itemize
## @item
## @cite{Matlab 7.0 documentation (pdf)}
## @item
## @uref{http://en.wikipedia.org/wiki/Weibull_distribution}
## @end itemize
##
## @end deftypefn

## Author: Arno Onken <whyly@gmx.net>

function [m, v] = weibstat (alpha, sigma)

  # Check arguments
  if (nargin != 2)
    usage ("[m, v] = weibstat (alpha, sigma)");
  endif

  if (! isempty (alpha) && ! ismatrix (alpha))
    error ("weibstat: alpha must be a numeric matrix");
  endif
  if (! isempty (sigma) && ! ismatrix (sigma))
    error ("weibstat: sigma must be a numeric matrix");
  endif

  if (! isscalar (alpha) || ! isscalar (sigma))
    [retval, alpha, sigma] = common_size (alpha, sigma);
    if (retval > 0)
      error ("weibstat: alpha and sigma must be of common size or scalar");
    endif
  endif

  # Calculate moments
  m = sigma .* gamma (1 + 1 ./ alpha);
  v = (sigma .^ 2) .* gamma (1 + 2 ./ alpha) - m .^ 2;

  # Continue argument check
  k = find (! (alpha > 0) | ! (alpha < Inf) | ! (sigma > 0) | ! (sigma < Inf));
  if (any (k))
    m (k) = NaN;
    v (k) = NaN;
  endif

endfunction

%!test
%! alpha = 1:6;
%! sigma = 3:8;
%! [m, v] = weibstat (alpha, sigma);
%! expected_m = [3.0000, 3.5449, 4.4649, 5.4384, 6.4272, 7.4218];
%! expected_v = [9.0000, 3.4336, 2.6333, 2.3278, 2.1673, 2.0682];
%! assert (m, expected_m, 0.001);
%! assert (v, expected_v, 0.001);

%!test
%! alpha = 1:6;
%! [m, v] = weibstat (alpha, 6);
%! expected_m = [ 6.0000, 5.3174, 5.3579, 5.4384, 5.5090, 5.5663];
%! expected_v = [36.0000, 7.7257, 3.7920, 2.3278, 1.5923, 1.1634];
%! assert (m, expected_m, 0.001);
%! assert (v, expected_v, 0.001);

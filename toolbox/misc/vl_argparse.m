function [conf, args] = vl_argparse(conf, args, varargin)
% VL_ARGPARSE  Parse list of parameter-value pairs
%   CONF = VL_ARGPARSE(CONF, ARGS) updates the structure CONF based on
%   the specified parameter-value pairs ARGS={PAR1, VAL1, ... PARN,
%   VALN}. The function produces an error if an unknown parameter name
%   is passed in.
%
%   [CONF, ARGS] = VL_ARGPARSE(CONF, ARGS) copies any parameter in
%   ARGS that does not match CONF back to ARGS instead of producing an
%   error.
%
%   Example::
%     The function can be used to parse a list of arguments
%     passed to a MATLAB functions:
%
%       function myFunction(x,y,z,varargin)
%       conf.parameterName = defaultValue ;
%       conf = vl_argparse(conf, varargin)
%
%     If only a subset of the options should be parsed, for example
%     because the other options are interpreted by a subroutine, then
%     use the form
%
%      [conf, varargin] = vl_argparse(conf, varargin)
%
%     that copies back to VARARGIN any unknown parameter.
%
%   See also: VL_OVERRIDE(), VL_HELP().

% Author: Andrea Vedaldi

% AUTORIGHTS
% Copyright (C) 2007-10 Andrea Vedaldi and Brian Fulkerson
%
% This file is part of VLFeat, available under the terms of the
% GNU GPLv2, or (at your option) any later version.

if ~isstruct(conf), error('CONF must be a structure') ; end

if length(varargin) > 0, args = {args, varargin{:}} ; end

remainingArgs = {} ;
names = fieldnames(conf) ;

if mod(length(args),2) == 1
  error('Parameter-value pair expected (missing value?).') ;
end

for ai = 1:2:length(args)
  paramName = args{ai} ;
  value = args{ai+1} ;
  if isfield(conf,paramName)
    conf.(paramName) = value ;
  else
    % try case-insensitive
    i = find(strcmpi(paramName, names)) ;
    if isempty(i)
      if nargout < 2
        error('Unknown parameter ''%s''.', paramName) ;
      else
        remainingArgs(end+1:end+2) = args(ai:ai+1) ;
      end
    else
      conf.(names{i}) = value ;
    end
  end
end

args = remainingArgs ;

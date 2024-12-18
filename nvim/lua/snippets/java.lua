local ls = require 'luasnip'
local parse = ls.parser.parse_snippet

return {
  parse('pln', 'StdOut.println($1);'),
}

+ ABSTRACT SYNTAX TREE:
    + keep moving until EOF token type is found!
    + push numbers and operations into the stack
    + if "(" is found then call the parse_primary function
    + if an operator is found with a higher precedence than the tos operator, make the nodes!
    
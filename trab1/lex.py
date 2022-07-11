class Dfa:
  def __init__(self):
    self.s0 = 0
    self.sf = [1]
    self.q = [0, 1]
    self.token = ['token0', 'token1']
    self.alpha = ['a', 'b', 'c']
    self.delta = [ #a*b[ac]*
      [0, 1, None],
      [1, None, 1]
    ]

  def trans(self, state, ch):
    try:
      return self.delta[state][self.alpha.index(ch)]
    except ValueError:
      return None


def word_rec(word: str, dfa: Dfa):
  state = 0
  lexema = ""
  stack = []
  
  for ch in word:
    lexema += ch
    if(state in dfa.sf):
      stack = []
    stack.append(state)
    state = dfa.trans(state, ch)
    if(state == None): break
  
  while(state not in dfa.sf and len(stack) != 0):
    state = stack.pop()
    lexema = lexema[:-1]
    # Faltou voltaChar()
  
  if(state in dfa.sf):
    return (dfa.token[state], lexema)
  
  raise Exception("Invalid word")

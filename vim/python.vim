syn keyword pythonMod np
syn keyword pythonMod numpy
syn keyword pythonMod plt
syn keyword pythonMod pyplot
syn keyword pythonMod matplotlib

highlight def link pythonMod Type

syn match   pythonAttribute	/\.\h\w*/hs=s+1 contains=ALLBUT,pythonBuiltin transparent

syn match  pythonClass "\%(\%(def\s\|class\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained nextgroup=pythonClassVars

syn match pythonExtraOperator       "\%([~!^&|*/%+-]\|\%(class\s*\)\@<!<<\|<=>\|<=\|\%(<\|\<class\s\+\u\w*\s*\)\@<!<[^<]\@=\|===\|==\|=\~\|>>\|>=\|=\@<!>\|\*\*\|\.\.\.\|\.\.\|::\|=\)"

syn region pythonClassVars start="(" end=")" contained contains=pythonClassParameters transparent keepend
syn match  pythonClassParameters "[^,]*" contained contains=pythonExtraOperator,pythonBuiltin,pythonConstant,pythonStatement,pythonNumber,pythonString,pythonBrackets skipwhite

" Function parameters
syn match  pythonFunction "\%(\%(def\s\|class\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained nextgroup=pythonFunctionVars
syn match  pythonFunction '\(\.\)\@<=.\{-}\((\)\@='
syn match  pythonFunction '\(\.\)\@<!\w*\((\)\@='
syn region pythonFunctionVars start="(" end=")" contained contains=pythonFunctionParameters transparent keepend
syn match  pythonFunctionParameters "[^,]*" contained contains=pythonSelf,pythonExtraOperator,pythonBuiltin,pythonConstant,pythonStatement,pythonNumber,pythonString,pythonBrackets skipwhite

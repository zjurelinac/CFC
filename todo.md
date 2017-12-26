# Bugfixes
1. `PUSH SR` - SR cannot be pushed, try to fix this
2. `ADJCALLSTACKUP` & `ADJCALLSTACKDOWN` - Stack improperly increased/decreased
3. `CALL (f)` - Fix this, should be without braces
4. Add `*`, `/`, `%` operator implementations - via function calls?
5. `setcc` SDNode cannot be selected - fix it

# Tests
1. Try creating .o files
2. Try linking two .o files
3. Try compiling C++ code

# Tasks
1. See how this could be bundled with clang itself
2. Investigate all needed compile and link options
3. Find (or create) a suitable C stdlib

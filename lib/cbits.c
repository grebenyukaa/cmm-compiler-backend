/* cbits
$ gcc -fPIC -shared cbits.c -o cbits.so
$ clang -fPIC -shared cbits.c -o cbits.so
*/

#include <stdio.h>
#include <stdint.h>

void putChar(int32_t X) {
  putchar((char)X);
  fflush(stdout);
}

int32_t getChar() 
{
  return getchar();
}
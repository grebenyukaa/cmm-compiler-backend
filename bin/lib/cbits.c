/* cbits
$ gcc -fPIC -shared cbits.c -o cbits.so
$ clang -fPIC -shared cbits.c -o cbits.so
*/

#include "stdio.h"

void putChar(int X) 
{
  putchar((char)X);
  fflush(stdout);
}

int getChar() 
{
  return getchar();
}
#include <iostream>

double *the_pointer;

extern "C" {
int set_pointer(double target[], int index, int len) {
  the_pointer = &(target[index]);
  return 0;
}

int show_pointer() {
  std::cout << *the_pointer << std::endl;
  return 0;
}
}

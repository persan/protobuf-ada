#include "message.pb.h"

#include <iostream>
#include <fstream>
#include <ios>

int main(int argc, char *argv[])
{
  Person person;
  std::fstream in("asdfk.dat", std::ios::in | std::ios::binary);
  if (!person.ParseFromIstream(&in)) {
    std::cerr << "Failed to parse person.pb." << std::endl;
    exit(1);
  }
  std::cout << "ID: " << person.id() << std::endl;
  std::cout << "Age: " << person.age() << std::endl;

  return 0;
}

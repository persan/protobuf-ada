# See README.txt.

.PHONY: all cpp java python clean ada
ada:

all: ada cpp java python

cpp:    add_person_cpp    list_people_cpp
python: add_person_python list_people_python
ada:    add_person_ada    list_people_ada


.protoc_middleman: addressbook.proto Makefile
	rm -rf src.cpp src.java src.ada
	mkdir -p src.cpp src.java src.ada
	protoc --cpp_out=src.cpp --java_out=src.java --python_out=. --ada_out=src.ada addressbook.proto
	@touch protoc_middleman

add_person.adb:.protoc_middleman
add_person_ada: add_person.adb
	gprbuild -j0 -p -P example_ada.gpr

list_people.adb:.protoc_middleman
list_people_ada:list_people.adb
	gprbuild -j0 -p -P example_ada.gpr


add_person_cpp: add_person.cc .protoc_middleman
	pkg-config --cflags protobuf  # fails if protobuf is not installed
	c++ add_person.cc addressbook.pb.cc -o add_person_cpp `pkg-config --cflags --libs protobuf`

list_people_cpp: list_people.cc .protoc_middleman
	pkg-config --cflags protobuf  # fails if protobuf is not installed
	c++ list_people.cc addressbook.pb.cc -o list_people_cpp `pkg-config --cflags --libs protobuf`

javac_middleman: AddPerson.java ListPeople.java .protoc_middleman
	javac AddPerson.java ListPeople.java com/example/tutorial/AddressBookProtos.java
	@touch javac_middleman


clean:
	git clean . -xdf

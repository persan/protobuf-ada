# See README.txt.

.PHONY: all cpp java python clean ada
ada:

all: ada cpp java python

cpp:    add_person_cpp    list_people_cpp
python: add_person_python list_people_python
ada:    add_person_ada    list_people_ada

clean:
	rm -f add_person_cpp list_people_cpp add_person_java list_people_java add_person_python list_people_python
	rm -f javac_middleman AddPerson*.class ListPeople*.class com/example/tutorial/*.class
	rm -f protoc_middleman addressbook.pb.cc addressbook.pb.h addressbook_pb2.py com/example/tutorial/AddressBookProtos.java
	rm -f *.pyc
	rmdir com/example/tutorial 2>/dev/null || true
	rmdir com/example 2>/dev/null || true
	rmdir com 2>/dev/null || true

protoc_middleman: addressbook.proto Makefile
	protoc --cpp_out=. --java_out=. --python_out=. --ada_out=. addressbook.proto
	@touch protoc_middleman
add_person.adb:protoc_middleman Makefile
add_person_ada: add_person.adb protoc_middleman

list_people.adb:protoc_middleman Makefile
list_people_ada:list_people.adb protoc_middleman
	

add_person_cpp: add_person.cc protoc_middleman
	pkg-config --cflags protobuf  # fails if protobuf is not installed
	c++ add_person.cc addressbook.pb.cc -o add_person_cpp `pkg-config --cflags --libs protobuf`

list_people_cpp: list_people.cc protoc_middleman
	pkg-config --cflags protobuf  # fails if protobuf is not installed
	c++ list_people.cc addressbook.pb.cc -o list_people_cpp `pkg-config --cflags --libs protobuf`

javac_middleman: AddPerson.java ListPeople.java protoc_middleman
	javac AddPerson.java ListPeople.java com/example/tutorial/AddressBookProtos.java
	@touch javac_middleman

add_person_python: add_person.py protoc_middleman
	@echo "Writing shortcut script add_person_python..."
	@echo '#! /bin/sh' > add_person_python
	@echo './add_person.py "$$@"' >> add_person_python
	@chmod +x add_person_python

list_people_python: list_people.py protoc_middleman
	@echo "Writing shortcut script list_people_python..."
	@echo '#! /bin/sh' > list_people_python
	@echo './list_people.py "$$@"' >> list_people_python
	@chmod +x list_people_python

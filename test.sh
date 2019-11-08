#!/bin/sh

rm BASE
export DEBUG=1
 # Add a base named "mydatabase"
 source storage.sh ADD_BASE "mydatabase"
 
 # Add a column named "name" in the database
 source storage.sh ADD_COL "name" "mydatabase"
 
 # Add a column named "status" in the database
 source storage.sh ADD_COL "status" "mydatabase"
 
 # Insert some data : parameters are simply in order of the columns created, 
 # ended with the name of the database
 source storage.sh APPEND_LINE "Harry" "Student" "mydatabase"
 source storage.sh APPEND_LINE "Ron" "Student" "mydatabase"
 source storage.sh APPEND_LINE "Hermione" "Student" "mydatabase"
 source storage.sh APPEND_LINE "Hagrid" "Student" "mydatabase"


 source storage.sh GET_VALUE "4" "name" "mydatabase"
 source storage.sh GET_VALUE "4" "status" "mydatabase"

 # Mh Hagrid is not a student.. Lets correct that

 source storage.sh UPDATE_VALUE "4" "Professor" "status" "mydatabase"

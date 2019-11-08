#!/bin/sh

rm BASE
 # Add a base named "mydatabase"
 source storage.sh ADD_BASE "mydatabase"
 
 # Add a column named "ID" in the database
 source storage.sh ADD_COL "ID" "mydatabase"
 
 # Add a column named "name" in the database
 source storage.sh ADD_COL "name" "mydatabase"
 
 # Add a column named "status" in the database
 source storage.sh ADD_COL "status" "mydatabase"
 
 # Insert some data : parameters are simply in order of the columns created, 
 # ended with the name of the database
 source storage.sh APPEND_LINE "1" "Harry" "Student" "mydatabase"
 source storage.sh APPEND_LINE "2" "Ron" "Student" "mydatabase"
 source storage.sh APPEND_LINE "3" "Hermione" "Student" "mydatabase"

 source storage.sh GET_VALUE "2" "name" "mydatabase"
 source storage.sh GET_VALUE "2" "status" "mydatabase"

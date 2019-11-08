#!/bin/sh

rm BASE
export DEBUG=1
 # Add a table named "Users"
 source storage.sh ADD_TABLE "Users"
 
 # Add a column named "name" in the database
 source storage.sh ADD_COL "name" "Users"
 
 # Add a column named "status" in the database
 source storage.sh ADD_COL "status" "Users"
 
 # Insert some data : parameters are simply in order of the columns created, 
 # ended with the name of the database
 source storage.sh APPEND_LINE "Harry" "Student" "Users"
 source storage.sh APPEND_LINE "Ron" "Student" "Users"
 source storage.sh APPEND_LINE "Hermione" "Student" "Users"
 source storage.sh APPEND_LINE "Hagrid" "Student" "Users"


 source storage.sh GET_VALUE "4" "name" "Users"
 source storage.sh GET_VALUE "4" "status" "Users"

 # Mh Hagrid is not a student.. Lets correct that

 source storage.sh UPDATE_VALUE "4" "Professor" "status" "Users"

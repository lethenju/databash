# databash
Simple database solution with Linux bash 

## What for ?

You want a simple CRUD system that is lighter than 400 lines of shell code ?

No nodeJS, no Python, no Ruby, no dependency, not even a compiled binary ?

Here you go : this simple script based on `sed` and `perl` give you different APIs to manage your data just like any CRUD system.

## Usage

You can see the test.sh script to see how the script is used.

It will create a small table in the `BASE` file and query information from it

### Create 

```sh
 # Add a table named "Users"
 source storage.sh ADD_TABLE "Users"
 
 # Add a column named "name" in the table
 source storage.sh ADD_COL "name" "Users"
 
 # Add a column named "status" in the table
 source storage.sh ADD_COL "status" "Users"
 
 # Insert some data : parameters are simply in order of the columns created, 
 # ended with the name of the database
 source storage.sh APPEND_LINE "Harry" "Student" "Users"
 source storage.sh APPEND_LINE "Ron" "Student" "Users"
 source storage.sh APPEND_LINE "Hermione" "Student" "Users"
 source storage.sh APPEND_LINE "Hagrid" "Student" "Users"

```

Your `BASE` file now looks like that : 
```
#BASE_FILE#
STARTB=Users;
ID:1,2,3,
name:Harry,Ron,Hermione,Hagrid,
status:Student,Student,Student,Student,
ENDB;
```

### Read

```sh 
 # Print the number of columns created in the database
 source storage.sh GET_COLS_NUM "Users"
 
 # Print the names of columns created in the database
 source storage.sh GET_COLS_NAMES "Users"
 
 # Print the number of lines created in the database
 source storage.sh GET_LINE_NUM "test2" "Users"
 
 # Print the second value for the column name in the database 
 source storage.sh GET_VALUE "2" "name" "Users"
 
 # Print table
 source storage.sh PRINT_TABLE "Users"
 
```
### Update 

```sh
 # Mh Hagrid is not a student.. Lets correct that. 
 #    -> Takes the ID, the new value, the column to change, and the table
 source storage.sh SET_VALUE "4" "Professor" "status" "Users"

```

### Delete

```sh
 # Deletes a line
 # Hagrid is no longer in poudlard :'(
 source storage.sh DEL_LINE "4" "Users"

 # Deletes a column named "ID" in the table
 source storage.sh DEL_COL "ID" "Users"
 
 # delete a table named "Users"
 # will also delete the inner data and columns
 source storage.sh DEL_TABLE "Users"
```

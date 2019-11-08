# databash
Simple database solution with Linux bash 

/!\ WARNING /!\\

This is just a project, as for now only some APIs are implemented. They lack unitary and verification tests and error handling. You shouldnt use this code for your application

## What for ?

You want a simple CRUD system that is less heavier than 300 lines of shell code ?

No nodeJS, no Python, no Ruby, no dependency, not even a compiled binary ?

Here you go : this simple script based on `sed` to give you different APIs to manage your data just like any CRUD system.

### Usage

You can see the test.sh script to see how the script is used.

It will create a small database in the `BASE` file and query information from it

#### Create 

```sh
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
```

Your `BASE` file now looks like that : 
```
#BASE_FILE#
STARTB=mydatabase;
ID:1,2,3,
name:Harry,Ron,Hermione,
status:Student,Student,Student,
ENDB;
```

#### Read

```sh 
 # Print the number of columns created in the database
 source storage.sh GET_COLS_NUM "mydatabase"
 
 # Print the names of columns created in the database
 source storage.sh GET_COLS_NAMES "mydatabase"
 
 # Print the number of lines created in the database
 source storage.sh GET_LINE_NUM "test2"
 
 # Select the second value for the column name in the database 
 source storage.sh GET_VALUE "2" "name" "mydatabase"
 
```
#### Update 

TODO (Nothing implemented for now)

#### Delete

```sh
 # Deletes a column named "ID" in the database
 source storage.sh DEL_COL "ID" "mydatabase"
 
 # delete a base named "mydatabase"
 # will also delete the inner data and columns
 source storage.sh DEL_BASE "mydatabase"
```

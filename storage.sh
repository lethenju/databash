#!/bin/bash

debug() {
    if [[ DEBUG -eq 1 ]]; then
        echo $1
    fi
}

if [[ ! -e BASE ]]; then
    echo "Base does not exist, write it";
    echo "#BASE_FILE#" > BASE
fi

# Adds a table given in parameter
add_table() {
    debug "add table $1"
    sed -i '$ a\STARTB='$1';\nENDB;' BASE;
}

# Deletes the table fiven in parameer
del_table() {
    debug "remove table $1"
    sed -i '/STARTB='$1';/,/ENDB;/d' BASE;
}

# Adds column to table
add_column() {
    debug "add column $1 to table $2"
    sed -i '/STARTB='$2';/,/ENDB;/{s/ENDB;/'$1':\nENDB;/g}' BASE
}

# Deletes a column of a table
del_column() {
    debug "del column $1 to table $2"
    sed -i '/STARTB='$2';/,/ENDB;/{/'$1':/d}' BASE

}

# Returns the number of columns of a table in the result var
get_number_columns() {
    debug "get number of columns in table $1"
    result=$(sed -n '/STARTB='$1';/,/ENDB/p' BASE | wc -l )
    result=$((result-2))
}

# Returns the number of lines of a table in the result var
get_number_lines() {
    debug "get number of lines in table $1"
    sed -n '/STARTB='$1';/,/ENDB;/p' BASE | sed -n 2p > .file
    result=$(awk -F "," '{print NF-1}' .file)
    rm .file
}

# Get the position in chars of an id from a column line.
# For internal use only!
get_position_id() {
    debug "position id for id $1 of column $2 of table $3"
    echo $(sed -n '/STARTB='$3';/,/ENDB;/{/'$2':/p}' BASE) > .file
    echo $(awk -F ":" '{print $2}' .file) > .file
    pos=$(echo -n $2 | wc -c) # Counting size of column name
    pos=$((pos+1)) # for the ":"
    ID=$1
    for ((i=1 ; i < $((ID+1)); i++)) {
        #get the value for i in val
        val=$(awk -v var='$i' -F  "," '{print $((i+1))}' .file)
        # Remove the value from the .file
        echo $(cat .file | perl -pe "s/(?:^.*?,)(.*)/\1/g") > .file
        # count the number of char of val
        size=$(echo -n $val | wc -c)
        # add the size of val to pos + the comma
        pos=$((pos + size + 1 ))
    }
    result=$pos
    rm .file
}

# Get a value of a field from a column line
get_value_from_id() {
    debug "get value of line $1 of column $2 of table $3"
    echo $(sed -n '/STARTB='$3';/,/ENDB;/{/'$2':/p}' BASE) > .file
    result=$(cat .file | perl -pe "s/(?:.*?[,:]){$1}(.*?)\,/\1,/g" | perl -pe "s/,([^\,]*,$)//g")
    rm .file
}

# Update a value in the datatable
update_value_in_column() {
    id=$1
    id=$((id-1))
    debug "update value id $1 by $2 in column $3 of table $4"
    get_position_id $id $3 $4
    position_id=$result

    debug "position_id : $position_id "

    # Get column in a different file
    echo $(sed -n '/STARTB='$4';/,/ENDB;/{/'$3':/p}' BASE) > .file
    non_modified_line=$(cat .file)
    modified_line=$(cat .file | perl -pe "s/(^.{$position_id}).*?,(.*$)/\1$2,\2/g")

    debug "Modified line = $modified_line"
    sed -i "s/$non_modified_line/$modified_line/g" BASE
    rm .file
}

# Appends a value in a column. 
# For internal use : need to appends value in all columns
# to keep the same number of lines
append_value_in_column() {
    debug "append value $1 in column $2 of table $3"
    sed -i '/STARTB='$3';/,/ENDB;/{/'$2':/{s/$/'$1',/g}}' BASE
}

# Deletes a value from a column.
# For internal use : see append_value_in_column
delete_value_in_column() {
    id=$1
    id=$((id-1))
    debug "deletes value id $1 in column $2 of table $3"
    get_position_id $id $2 $3
    position_id=$result

    debug "position_id : $position_id "

    # Get column in a different file
    echo $(sed -n '/STARTB='$3';/,/ENDB;/{/'$2':/p}' BASE) > .file
    non_modified_line=$(cat .file)
    modified_line=$(cat .file | perl -pe "s/(^.{$position_id}).*?,(.*$)/\1\2/g")
    sed -i "s/$non_modified_line/$modified_line/g" BASE
    #rm .file
}

# Gets name of a column of a table by its ID
get_name_of_column_id() {
    debug "return name of column id $1 in table $2"
    ID=$1
    result=$(sed -n '/STARTB='$2';/,/ENDB;/p' BASE | sed -n $((ID+2))p | sed 's/:.*//g')
    debug "result = $result"
}

# Appends a line in a table 
append_line() {
    num_args=$#
    num_cols_given=$((num_args-1))
    table_name="${@: -1}"
    get_number_columns $table_name 
    num_cols_table=$result
    if [[ $num_cols_given -ne $num_cols_table ]]; then
        echo "ERR : Wrong number of columns : given $num_cols_given , need $num_cols_table"
        return 0
    fi

    debug "append line in $table_name"
    i=0;
    for var in "$@"; do
        get_name_of_column_id $i $table_name
        col_name=$result
        append_value_in_column $var $col_name $table_name
        if [[ $i -eq $((num_cols_table - 1)) ]]; then # ok
            return 1;
        fi

        i=$((i+1));
    done
}

#delete line with id
delete_line() {
    debug "Delete line with ID $1 in table $2"
    get_number_columns $2
    number_columns=$result
    debug "Number of col = $number_columns"
    for ((i_delete_line=0 ; i_delete_line < $number_columns; i_delete_line++)); do
        get_name_of_column_id $i_delete_line $2
        col_name=$result
        delete_value_in_column $1 $col_name $2
    done

}


#return ID of the lines 
#format : $RESULT=1;2;3;8
get_lines_where_value_is_eq() {
    debug "Select lines where column $2 is equal to $1, in table $3"
}



print_table() {
    debug "print table $1"

}

# Return list of column names in a table in the RESULT variable
# format RESULT="column_1;column_2;column_3"
get_column_names() {
    debug "get column names for table $1"
    # TODO Verify existance table $1
    table_name=$1
    get_number_columns $table_name 
    num_cols_table=$result
    list_column_names=''
    for ((i=0 ; i < num_cols_table; i++)); do
        get_name_of_column_id $i $table_name
        list_column_names="$list_column_names;$result"
    done
    result=${list_column_names#;} #Remove first ';' that is here because of the first loop
}

# To implement
get_column() {
    debug "get column $1 of table $2"

}

# To implement
export_into_json() {
    debug "exporting in json table $1"

}

case "$1" in 
"ADD_TABLE")
    add_table $2
    ;;
"DEL_TABLE")
    del_table $2
    ;;
"ADD_COL")
    add_column $2 $3
    ;;
"DEL_COL")
    del_column $2 $3
    ;;
"APPEND_LINE")
    shift
    append_line $@
    ;;
"GET_COLS_NAMES")
    get_column_names $2
    echo $result
    ;;
"GET_COLS_NUM")
    get_number_columns $2
    echo $result
    ;;
"GET_LINE_NUM")
    get_number_lines $2
    echo $result
    ;;
"GET_VALUE")
    get_value_from_id $2 $3 $4
    echo $result
    ;;
"UPDATE_VALUE")
    update_value_in_column $2 $3 $4 $5
    ;;
"DEL_LINE")
    delete_line $2 $3
    ;;
esac


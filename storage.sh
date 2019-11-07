#!/bin/sh
# @Author : Julien LE THENO
# @Date : 07/11/2019
# @Version : 0.1

DEBUG=1

debug() {
    if [[ DEBUG -eq 1 ]]; then
        echo $1
    fi
}

if [[ ! -e BASE ]]; then
    echo "Base does not exist, write it";
    echo "#BASE_FILE#" > BASE
fi

# Adds a base given in parameter
add_base() {
    debug "add base $1"
    sed -i '$ a\STARTB='$1';\nENDB;' BASE;
}

# Deletes the base fiven in parameer
del_base() {
    debug "remove base $1"
    sed -i '/STARTB='$1';/,/ENDB;/d' BASE;
}

# Adds column to base
add_column() {
    debug "add column $1 to base $2"
    sed -i '/STARTB='$2';/,/ENDB;/{s/ENDB;/'$1':\nENDB;/g}' BASE
}

# Deletes a column of a base
del_column() {
    debug "del column $1 to base $2"
    sed -i '/STARTB='$2';/,/ENDB;/{/'$1':/d}' BASE

}

# Returns the number of columns of a base in the result var
get_number_columns() {
    debug "get number of columns in base $1"
    RESULT=$(sed -n '/STARTB='$1';/,/ENDB/p' BASE | wc -l )
    RESULT=$((RESULT-2))
}

# Returns the number of lines of a base in the result var
get_number_lines() {
    debug "get number of lines in base $1"
    sed -n '/STARTB='$1';/,/ENDB;/p' BASE | sed -n 2p > .file
    RESULT=$(awk -F "," '{print NF-1}' .file)
    rm .file
}

# Get the position in chars of an id from a column line.
# For internal use only!
get_position_id() {
    debug "position id for id $1 of column $2 of base $3"
    echo $(sed -n '/STARTB='$3';/,/ENDB;/{/'$2':/p}' BASE) > .file
    echo $(awk -F ":" '{print $2}' .file) > .file
    POS=$(echo -n $2 | wc -c) # Counting size of column name
    POS=$((POS+1)) # for the ":"
    ID=$1
    for ((i=1 ; i < $((ID+1)); i++)) {
        VAL=$(awk -v var='$i' -F  "," '{print $((i+1))}' .file)
        SIZE=$(echo -n $VAL | wc -c)
        POS=$((POS + SIZE + 1 ))
    }
    RESULT=$POS
    rm .file
}

update_value_in_column() {
    # We could use that ?
    #sed -i '/STARTB=test2;/,/ENDB;/{/name:/{s/\([a-Z0-9_]*\)\:\([a-Z0-9_]*\),/\1:88888\,/g}}' BASE 
    # Sed doesnt support non capturing groups, so we cannot use :
    # this regex : (?:.*?(\,)){1}.*?([_.0-9a-zA-Z]+)

    debug "update value id $1 by $2 in column $3 of base $4"
    get_position_id $1 $3 $4
    POSITION_ID=$RESULT

    get_number_lines $4
    debug "Number of lines : $RESULT"
    get_position_id $RESULT $3 $4
    LAST_POSITION_ID=$RESULT
    debug "POSITION_ID : $POSITION_ID LAST_POSITION_ID : $LAST_POSITION_ID"

    # How to change a file with the position ID ?

    # TODO Find a solution

}

# Appends a value in a column. 
# For internal use : need to appends value in all columns
# to keep the same number of lines
append_value_in_column() {
    debug "append value $1 in column $2 of base $3"
    sed -i '/STARTB='$3';/,/ENDB;/{/'$2':/{s/$/'$1',/g}}' BASE
}

# Deletes a value from a column.
# For internal use : see append_value_in_column
delete_value_in_column() {
    debug "delete value id $1 in column $2 of base $3"
    
}

# Gets name of a column of a base by its ID
get_name_of_column_id() {
    debug "return name of column id $1 in base $2"
    ID=$1
    RESULT=$(sed -n '/STARTB='$2';/,/ENDB;/p' BASE | sed -n $((ID+2))p | sed 's/:.*//g')
    debug "result = $RESULT"
}

# Appends a line in a base 
append_line() {
    NUM_ARGS=$#
    NUM_COLS_GIVEN=$((NUM_ARGS-1))
    BASE_NAME="${@: -1}"
    get_number_columns $BASE_NAME 
    NUM_COLS_BASE=$RESULT
    if [[ $NUM_COLS_GIVEN -ne $NUM_COLS_BASE ]]; then
        echo "ERR : Wrong number of columns : given $NUM_COLS_GIVEN , need $NUM_COLS_BASE"
        return 0
    fi

    debug "append line in $BASE_NAME"
    i=0;
    for var in "$@"; do
        get_name_of_column_id $i $BASE_NAME
        COL_NAME=$RESULT
        append_value_in_column $var $COL_NAME $BASE_NAME
        if [[ $i -eq $((NUM_COLS_BASE - 1)) ]]; then # ok
            return 1;
        fi

        i=$((i+1));
    done
}

#delete line with id
delete_line() {
    debug "Delete line with ID $1 in base $2"

}


#return ID of the lines 
#format : $RESULT=1;2;3;8
get_lines_where_value_is_eq() {
    debug "Select lines where column $2 is equal to $1, in base $3"
}



print_base() {
    debug "print base $1"

}

# Return list of column names in a base in the RESULT variable
# format RESULT="column_1;column_2;column_3"
get_column_names() {
    debug "get column names for base $1"
    # TODO Verify existance base $1
    get_number_columns $BASE_NAME 
    NUM_COLS_BASE=$RESULT
    LIST_COLUMN_NAMES=''
    for ((i=0 ; i < NUM_COLS_BASE; i++)); do
        get_name_of_column_id $i $BASE_NAME
        LIST_COLUMN_NAMES="$LIST_COLUMN_NAMES;$RESULT"
    done
    RESULT=${LIST_COLUMN_NAMES#;} #Remove first ';' that is here because of the first loop
}

# To implement
get_column() {
    debug "get column $1 of base $2"

}

# To implement
export_into_json() {
    debug "exporting in json base $1"

}

case "$1" in 
"ADD_BASE")
    add_base $2
    ;;
"DEL_BASE")
    del_base $2
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
    echo $RESULT
    ;;
"GET_COLS_NUM")
    get_number_columns $2
    echo $RESULT
    ;;
"GET_LINE_NUM")
    get_number_lines $2
    echo $RESULT
    ;;
"UPDATE_VALUE")
    update_value_in_column $2 $3 $4 $5
    ;;
esac


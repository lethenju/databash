#!/bin/sh

DEBUG=0

debug() {
    if [[ DEBUG -eq 1 ]]; then
        echo $1
    fi
}

if [[ ! -e BASE ]]; then
    echo "Base does not exist, write it";
    echo "#BASE_FILE#" > BASE
fi


add_base() {
    debug "add base $1"
    sed -i '$ a\STARTB='$1';\nENDB;' BASE;
}

del_base() {
    debug "remove base $1"
    sed -i '/STARTB='$1';/,/ENDB;/d' BASE;
}

add_column() {
    debug "add column $1 to base $2"
    sed -i '/STARTB='$2';/,/ENDB;/{s/ENDB;/'$1':\nENDB;/g}' BASE
}

del_column() {
    debug "del column $1 to base $2"
    sed -i '/STARTB='$2';/,/ENDB;/{/'$1':/d}' BASE

}
get_number_columns() {
    debug "get number of columns in base $1"
    RESULT=$(sed -n '/STARTB='$1';/,/ENDB/p' BASE | wc -l )
    RESULT=$((RESULT-2))
}
get_number_lines() {
    debug "get number of lines in base $1"
    sed -n '/STARTB=test2;/,/ENDB;/p' BASE | sed -n 2p > .file
    RESULT=$(awk -F, '{print NF-1}' .file)
    rm .file
}
update_value_in_column() {
    debug "update value id $1 by $2 in column $3 of base $4"

}

append_value_in_column() {
    debug "append value $1 in column $2 of base $3"
    sed -i '/STARTB='$3';/,/ENDB;/{/'$2':/{s/$/'$1',/g}}' BASE
}
delete_value_in_column() {
    debug "delete value id $1 in column $2 of base $3"
    
}

get_name_of_column_id() {
    debug "return name of column id $1 in base $2"
    ID=$1
    RESULT=$(sed -n '/STARTB='$2';/,/ENDB;/p' BASE | sed -n $((ID+2))p | sed 's/:.*//g')
    debug "result = $RESULT"
}

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

get_column() {
    debug "get column $1 of base $2"

}

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
esac


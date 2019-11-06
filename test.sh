#!/bin/sh

rm BASE

source storage.sh ADD_BASE "test"
source storage.sh ADD_BASE "test2"

source storage.sh ADD_COL "name" "test"
source storage.sh ADD_COL "name2" "test"

source storage.sh ADD_COL "name" "test2"
source storage.sh ADD_COL "name2" "test2"
source storage.sh DEL_COL "name" "test"


source storage.sh APPEND_LINE "1" "test"
source storage.sh APPEND_LINE "column_1" "column_2" "test2"


source storage.sh GET_COLS_NAMES test2
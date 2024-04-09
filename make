filename=$1
cc "$filename.c" -o  "$filename" && "./$filename"
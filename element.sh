#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ARG=$1

#If the argument is empty:

if [[ -z $ARG ]]
then 
  echo "Please provide an element as an argument."
  exit
fi

#Check if the argument is a number then it must be the atomic number:

if [[ $1 =~ ^[1-9]+$ ]]
then 
  PRINT=$($PSQL " SELECT atomic_number, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $1 ")
#Otherwise if the argument is a string then it must be the atomic name or symbol:
else
  PRINT=$($PSQL " SELECT atomic_number, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE name = '$1' OR symbol = '$1' ")
fi

#If the element is not found:
if [[ -z $PRINT ]]
then
  echo "I could not find that element in the database."
  exit
fi

#for each row in the table, extract the element info and make the print: 

echo $PRINT | while IFS="|" read ATOMIC_NUMBER TYPE MASS MELTING_POINT BOILING_POINT SYMBOL NAME
do
  echo  "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done




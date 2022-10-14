#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_PROGRAM(){

  if [[ $1 ]]
  then

  re='^[0-9]+$'
  if [[ $1 =~ $re ]] ; then
   element_atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    element_atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  fi  
    if [ $element_atomic_number ] ; then
      SHOW_ELEMENT_INFO $element_atomic_number
    else
      echo "I could not find that element in the database."
    fi
  else
    echo -e "Please provide an element as an argument."
  fi

}

SHOW_ELEMENT_INFO(){
  element_name=$($PSQL "SELECT name FROM elements WHERE atomic_number=$element_atomic_number")
  element_symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$element_atomic_number")
  
  element_mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$element_atomic_number")
  element_melting=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$element_atomic_number")
  element_boiling=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$element_atomic_number")
  element_type_id=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$element_atomic_number")
  
  element_type=$($PSQL "SELECT type FROM types WHERE type_id=$element_type_id")

  echo -e "The element with atomic number $element_atomic_number is $element_name (${element_symbol/ /}). It\'s a $element_type, with a mass of $element_mass amu. $element_name has a melting point of $element_melting celsius and a boiling point of $element_boiling celsius." | xargs
}

MAIN_PROGRAM $1
#!/bin/bash

# Connect to the periodic_table database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function to get element details
get_element_details() {
  if [[ -z $1 ]]; then
    echo "Please provide an element as an argument."
  else
    ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $1 OR e.symbol = '$1' OR e.name = '$1'")
    if [[ -z $ELEMENT ]]; then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT; do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  fi
}

# Run the function with the argument provided
get_element_details $1


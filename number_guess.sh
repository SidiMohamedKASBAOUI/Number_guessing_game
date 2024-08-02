#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$((RANDOM % 1000 + 1))
echo "$SECRET_NUMBER"
echo "Enter your username:"
read USERNAME
USERNAME_RESULT=$($PSQL "SELECT name FROM names WHERE name='$USERNAME'")
if [[ -z $USERNAME_RESULT ]]
then 
echo "Welcome, $USERNAME! It looks like this is your first time here."
INSERT=$($PSQL "INSERT INTO names(name, games_played, best_game) VALUES('$USERNAME', 0, 2147483647)")
GAMES_PLAYED=$($PSQL "SELECT games_played FROM names WHERE name='$USERNAME'")
BEST_GAME=$($PSQL "SELECT best_game FROM names WHERE name='$USERNAME'")

else
GAMES_PLAYED=$($PSQL "SELECT games_played FROM names WHERE name='$USERNAME'")
BEST_GAME=$($PSQL "SELECT best_game FROM names WHERE name='$USERNAME'")
echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses." 
fi


GUESS=0
TRIES=0
echo "Guess the secret number between 1 and 1000:"


while [[ $GUESS -ne $SECRET_NUMBER ]]
do
  read GUESS
  TRIES=$((TRIES + 1))
  if [[ ! $GUESS =~ ^[0-9]+$ ]] 
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS -lt $SECRET_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "You guessed it in $TRIES tries. The secret number was $SECRET_NUMBER. Nice job!"
    #INSERT_WINNER_NAME=$($PSQL "INSERT INTO names(name) VALUES('$USERNAME')")
    if [[ $TRIES -lt $BEST_GAME ]]
    then
    INCREMENT=$($PSQL "UPDATE names SET games_played = games_played + 1, best_game= $TRIES WHERE name='$USERNAME'")
    #SCORE=$($PSQL "INSERT INTO names(best_game) VALUES($TRIES) WHERE name='$USERNAME'")
    else 
    INCREMENT=$($PSQL "UPDATE names SET games_played = games_played + 1 WHERE name='$USERNAME'")
    fi
  fi
done
#fix:
#feat: 
#refractor
#chore
#test:

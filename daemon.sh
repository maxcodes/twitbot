# To run the bot, run the following command in the terminal
# nohup ./daemon.sh >> create.log &
echo $$ > nohup.pid

ruby index.rb

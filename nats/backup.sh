mkdir /data/backup/nats

nats str ls -n |
grep -v "^\s*$" |
while IFS= read -r line
do
  nats str backup --no-progress "$line" "/data/backup/nats/$line"
done

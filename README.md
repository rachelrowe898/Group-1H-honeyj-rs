# Group-1H-honeyj-rs

## Honey Creation

To run the honey creation script, execute the following command, replacing 10 with the number of lines of data you want. 
```bash
python3 honey-creation.py 10
```
The script will create (or replace, if the file already exists) an `employee-data.csv` file with a heading line and the given number of lines of data. An `employee-data.csv` file with 10 lines is provided as a reference. 

## Symlink Creation

To run this, script, execute the following command:
```bash
bash monitor-new-users.sh <container name>
```
Or run `sudo chmod a+x monitor-new-users.sh`, and then use `./` on the file name. 

This script should be run in the background, as it will continuously run. Note that you must have `inotifywait` installed on the system for this to work. Run `sudo apt-get install inotify-tools` to get this command. 

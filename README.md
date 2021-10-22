# Group-1H-honeyj-rs

## Honey Creation

To run the honey creation script, execute the following command. 
```bash
python3 honey-creation.py <number of lines>
```
The script will create (or replace, if the file already exists) an `employee-data.csv` file with a heading line and the given number of lines of data. 

## Template Creation

To run the template creation script, execute the following command, with either A, B, C, or D as an argument (alternatively, you can change permissions through `sudo chmod a+x template-creation.sh` and run without the `bash` keyword). 
```bash
bash template-creation.sh <template letter>
```
The four letters correspond to which number of lines there are in the honey file: A to 0, B to 5000, C to 50000, and D to 500000. An lxc container of the name letter_template will be created. Ideally, this script should only be run once per template, as we are not replacing the templates unless necessary. 

## Symlink Creation

To run this, script, execute the following command:
```bash
bash monitor-new-users.sh <container name>
```
Or run `sudo chmod a+x monitor-new-users.sh`, and then use `./` on the file name. 

This script should be run in the background, as it will continuously run. Note that you must have `inotifywait` installed on the system for this to work. Run `sudo apt-get install inotify-tools` to get this command. 

## MITM Config File
Clone the following repository onto your machine and follow instructions in that repository to properly set up MITM: https://github.com/UMD-ACES/MITM

Then move the mitm.js configuration file into the MITM/config directory.

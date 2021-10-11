# Group-1H-honeyj-rs

## Honey Creation

To run the honey creation script, execute the following command, replacing 10 with the number of lines of data you want. 
```bash
python3 honey-creation.py 10
```
The script will create (or replace, if the file already exists) an `employee-data.csv` file with a heading line and the given number of lines of data. 

## Template Creation

To run the template creation script, execute the following command, with either A, B, C, or D as an argument (alternatively, you can change permissions through `sudo chmod a+x template-creation.sh` and run without the `bash` keyword). 
```bash
bash template-creation.sh [ABCD]
```
The four letters correspond to which number of lines there are in the honey file: A to 0, B to 5000, C to 50000, and D to 500000. An lxc container of the name letter_template will be created. Ideally, this script should only be run once per template, as we are not replacing the templates unless necessary. 
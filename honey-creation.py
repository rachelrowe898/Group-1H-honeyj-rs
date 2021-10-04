from faker import Faker
from random import random
import sys

fake = Faker()

def create_person():
    person = {}
    person["last_name"] = fake.last_name()

    r = random()
    if r < .5:
        person["first_name"] = fake.first_name_male()
        person["sex"] = "Male"
    else:
        person["first_name"] = fake.first_name_female()
        person["sex"] = "Female"

    r = random()

    if r < 0.73:
        person["race"] = "White"
    elif r < 0.857:
        person["race"] = "Black or African American"
    elif r < 0.865:
        person["race"] = "American Indian or Alaska Native"
    elif r < 0.919:
        person["race"] = "Asian"
    elif r < 0.921:
        person["race"] = "Native Hawaiian or Other Pacific Islander"
    elif r < 0.969:
        person["race"] = "Other"
    else:
        person["race"] = "Two or More Races"

    person["address"] = fake.address().replace("\n", ", ")
    person["birthdate"] = fake.date_between(start_date='-70y', end_date='-20y')
    person["bank_routing"] = fake.aba()
    person["bank_account"] = fake.bban()

    return person


# p = create_person()
# for k in p:
#     print(k.upper(), "\n" + str(p[k]))

if __name__ == "__main__":

    if len(sys.argv) != 2:
        print("Usage: honey-creation.py <number of lines>")
        sys.exit(1)
    
    if not sys.argv[1].isdigit():
        print("Error: argument must be int")
        sys.exit(2)
    
    num_lines = int(sys.argv[1])

    with open("employee-data.csv", "w") as f:
        f.write("id,last_name,first_name,sex,race,address,birthdate,bank_routing,bank_account\n")
        for l in range(num_lines):
            person_string = str(l+1) + ","
            p = create_person()
            for k in p:
                if k == "address": 
                    person_string += "\""
                person_string += str(p[k]) 
                if k == "address":
                    person_string += "\""
                if k != "bank_account":
                    person_string += ","
            f.write(person_string + "\n")

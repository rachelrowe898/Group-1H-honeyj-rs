from faker import Faker
from random import random

fake = Faker()

def create_person():
    person = {}
    person["last name"] = fake.last_name()

    r = random()
    if r < .5:
        person["first name"] = fake.first_name_male()
        person["sex"] = "Male"
    else:
        person["first name"] = fake.first_name_female()
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

    person["address"] = fake.address()
    person["birthdate"] = fake.date_between(start_date='-70y', end_date='-20y')
    person["bank routing"] = fake.aba()
    person["bank account"] = fake.bban()

    return person


def create_file(num_lines):
    return None


p = create_person()
for k in p:
    print(k.upper(), "\n" + str(p[k]))


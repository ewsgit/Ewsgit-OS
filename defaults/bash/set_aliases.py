#!/bin/env python

# EwsgitOS © 2022 Ewsgit

default_aliases = [
    [
        "ls",
        "exa"
    ],
    [
        "ed",
        "nvim"
    ],
    [
        "cl",
        "clear"
    ]
]

output_string = ""
current_aliases = []

def get_current_aliases():
    f = open("./aliases.sh", "wr")
    file = f.read()
    f.close()
    file = file.split("start of aliases")[1]
    file = file.split("end of aliases")[0]
    raw_aliases = file.split("\n")

    # begin to parse each line as an alias into the array

    output_array = []



    return output_array
def add_alias(alias):


# see what is wrong with this code and update to follow pep8
import os

import numpy as np


def function():
    print(os.random())


class School():
    """
    class definition for school.
    This includes attribute called type and method called return_type()
    """

    def __init__(self, type='middle'):  # comments
        self.type = type

    def return_type(self):
        return self.type  # return its type attribute

# see what is wrong with this code and update to follow pep8
import numpy as np
import os


def Function():
  print(os.random())

class school():
  """
  class definition for school.
  This includes attribute called type and method called return_type()
  """
  def __init__( self,type = 'middle' ):
    self.type=type
  def return_type(self):
    return self.type # return its type attribute
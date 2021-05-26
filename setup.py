#!/usr/bin/env python

"""
setup.py file for Cython
"""

from setuptools import setup
from Cython.Build import cythonize

setup(
	name="ogdl",
	ext_modules=cythonize("src/ogdl.pyx"),
)
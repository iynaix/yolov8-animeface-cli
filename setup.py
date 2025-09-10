#!/usr/bin/env python3

from setuptools import setup, find_packages

setup(
    name="anime-face-detector",
    version="1.0",
    # Executables
    scripts=["cli.py"],
    entry_points={
        "console_scripts": [
            "anime-face-detector = cli:main",
        ],
    },
    py_modules=["cli"],
)

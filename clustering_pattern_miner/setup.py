# Always prefer setuptools over distutils
from setuptools import setup, find_packages

setup(
    name="clustering_pattern_miner",
    version="1.0",
    description="""Application of an implementation of the kmode clustering algorithm to
    mine for patterns in the call graph""",
    author="André Silva Telles",
    py_modules=["clustering"],
    entry_points={
        "console_scripts":{
            "clustering=clustering:main"
        }
    }
)

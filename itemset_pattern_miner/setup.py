# Always prefer setuptools over distutils
from setuptools import setup, find_packages

setup(
    name="itemset_pattern_miner",
    version="1.0",
    description="""Application of an implementation of the apriori algorithm to
    mine for patterns in the call graph""",
    author="André Silva Telles",
    py_modules=["itemset_pattern_miner"],
    entry_points={
        "console_scripts":{
            "itemset_pattern_miner=itemset_pattern_miner:main"
        }
    }
)

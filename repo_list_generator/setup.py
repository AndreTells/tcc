# Always prefer setuptools over distutils
from setuptools import setup, find_packages

setup(
    name="repo_list_generator",
    version="1.0",
    description="""Python project that selects github repos compling with the
        requirements for data mining in the current study""",
    author="André Silva Telles",
    py_modules=["main"],
    entry_points={
        "console_scripts":{
            "repo_list_generator=main:main"
        }
    }
)

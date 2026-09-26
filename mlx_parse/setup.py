from setuptools import setup, find_packages

setup(
    name="mlx_parse",  # Name of the package
    version="0.1",
    py_modules=["mlx_soln2assign", "mlx_to_plain_m"],  # Modules to be installed
    packages=find_packages(),
    install_requires=[],
    entry_points={
        'console_scripts': [
            'mlx_soln2assign = mlx_soln2assign:main',  # Maps the command 'mlx_soln2assign' to the 'main' function in mlx_soln2assign.py
            'mlx_to_plain_m = mlx_to_plain_m:main',
        ],
    },
    author="Brian Bingham",
    author_email="briansbingham@gmail.com",
    description="Python utilities for a MATLAB class",
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)

import tempfile

temp_dir = tempfile.gettempdir()
print(temp_dir)

with tempfile.TemporaryDirectory() as temp_dir:
    print(temp_dir)

tmp_dir = tempfile.TemporaryDirectory()
# Perform operations in the directory
tmp_dir.cleanup()  # Manually remove the direc
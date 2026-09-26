## mlx_parse utilities

Utility scripts for manipulating MATLAB `.mlx` live scripts.

### `mlx_soln2assign.py`

Creates student-facing `.mlx` files by blanking code blocks in instructor solutions.

```bash
python mlx_soln2assign.py assign1/aquarium_soln.mlx
python mlx_soln2assign.py assign1/aquarium_soln.mlx -o assign1/aquarium.mlx
```

### `mlx_to_plain_m.py`

Converts `.mlx` files to MATLAB's plain-text live script `.m` format using MATLAB's
Live Editor conversion API.

```bash
# Single file (auto output: same name, .m extension)
python mlx_to_plain_m.py assign3/takeoff.mlx

# Single file with explicit output path
python mlx_to_plain_m.py assign3/takeoff.mlx -o assign3/takeoff_plain.m

# Convert all .mlx in a directory
python mlx_to_plain_m.py assign3/

# Recursively convert all .mlx below a directory
python mlx_to_plain_m.py lessons/ -r
```

Notes:
- Existing output files are skipped unless `--force` is provided.
- Use `--matlab` to specify a non-default MATLAB command.
- You can also set `MATLAB_CMD` in the environment.

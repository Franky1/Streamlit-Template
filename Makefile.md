<!-- markdownlint-disable MD026 -->
# Makefile :hammer:

This is the description how to use the Makefile with the `make` command.

> :point_right: *You can delete this file before committing your project to GitHub.*

## Description :pencil2:

If you are a bit lazy like me and don't want to type the same commands into the shell all the time, using `make` is a relief.

You can use the **Makefile** to setup your local development environment, to build and run the Docker container locally and to clean up your local environment.

You need to have **make** installed on your system. If you want to use the Docker commands, you need to have **Docker** installed on your system. The Makefile should work on Linux, MacOS and Windows.

For the details of the commands have a look at the [Makefile](Makefile) itself.

## Prerequisites :heavy_check_mark:

- You have installed **make** on your system.
- If you want to use the docker commands, you have installed **Docker** on your system.

## Makefile commands :computer:

Below you find a list of the commands you can use with the Makefile.

### Commands to setup the python virtual environment :snake:

```bash
make update  # update local python packages related to package and virtualenv management
```

```bash
make venv  # create the python virtual environment
```

```bash
make venvupdate  # update the python virtual environment
```

```bash
make all  # make these 3 steps in one go: cleanpy, update, venv
```

### Docker related commands :whale:

```bash
make docker  # build the docker image and tag it as (folder name):latest
```

### Cleanup commands :wastebasket:

```bash
make cleanpy  # delete all local python __cache__ files
```

```bash
make cleanvenv  # delete the whole python virtual environment
```

```bash
make cleanall  # delete the whole python virtual environment and all __cache__ files
```

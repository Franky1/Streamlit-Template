<!-- markdownlint-disable MD026 -->
# Usage :wrench:

This template is made for **Python 3.11** version.

> :point_right: *You can delete this file before committing your project to GitHub.*

How to use this template project see the following steps:

1. Clone the template project.
2. Write your code in the `streamlit_app.py` file.
3. If necessary: Add additional python dependencies to the `requirements.txt` file.
4. If necessary: Add binary dependencies to the `packages.txt` file. Keep the line-endings in Linux (LF only) format. Uncomment the binary installation lines in the Dockerfile.
5. Build the Docker image locally (commands see below or in the Dockerfile).
6. Run the Docker container locally (commands see below or in the Dockerfile) and debug your streamlit app locally until you are ready to deploy to Streamlit Cloud.
7. Deploy the project to Streamlit Cloud and test it.
8. Adjust the `Open in Streamlit` badge in this README.md file, that it points to the deployed project.
9. Adjust the README.md file and describe your streamlit project.
10. Delete this "Usage" file before committing your project to GitHub.

---

## Python **virtualenv** setup for local development :snake:

If you don't want to use Docker for local development, you can also use a Python virtual environment.
How to setup a Python virtual environment for local development:

### 1. Install virtualenv package

```bash
pip install --upgrade virtualenv
```

### 2. Make and activate virtual environment

```bash
python -m venv .venv
```

#### On Windows

```bash
.venv\Scripts\activate
```

#### On macOS and Linux

```bash
source .venv/bin/activate
```

### 3. Install dependencies within the virtual environment

```bash
python -m pip install --upgrade pip
pip install --upgrade -r requirements.txt
```

### 4. Develop and test your streamlit app within the virtual environment

```bash
streamlit run streamlit-app.py
```

### 5. After development, deactivate virtual environment

```bash
deactivate
```

---

## Dockerfile for local development :whale:

This template contains a Dockerfile for local debugging and testing of the project, before deploying the project to Streamlit Cloud. This shall ease the process of developing and deploying projects to Streamlit Cloud, without endless back and forth trial-and-error between local development environment, GitHub and Streamlit Cloud.

The Dockerfile is based on `python:3.11-slim` image and shall mimic the Streamlit Cloud runtime as closely as possible.

**Hint**: If you run the Dockerfile locally on a Windows host system, you have to uncomment the `[server]` settings in the `.streamlit/config.toml` file. Comment these lines again before deploying the project to Streamlit Cloud.

### Docker commands :computer:

To build the docker image locally, run the following command:

```bash
docker build --progress=plain --tag streamlit:latest .
```

Then to run the docker container locally, run the following command:

```bash
docker run -ti -p 8501:8501 --rm streamlit:latest
```

If you want to run the docker container locally and make code changes on the fly, run the following command:

```bash
docker run -ti -p 8501:8501 -v ${pwd}:/app --rm streamlit:latest
```

> :point_right: For more details, look into the [Dockerfile](Dockerfile) file itself.

---

## Makefile :bulb:

For lazy or advanced users, there is also a **Makefile** included in this template project.

Details about how to use the Makefile with the `make` command see [Makefile.md](Makefile.md).

---

## Hints :warning:

- I don't recommend to use conda and an `environment.yml` file for streamlit projects. Better use a plain and simple `requirements.txt` file.
- If you write your `requirements.txt` file, do it manually! Don't use `pip freeze > requirements.txt` to generate the file! This will generate a lot of unnecessary or even uninstallable dependencies, which will slow down or even crash the deployment process on Streamlit Cloud.

---

## Resources :books:

See also the official documentation from Streamlit about docker deployments:

<https://docs.streamlit.io/knowledge-base/tutorials/deploy/docker>

## Status :heavy_check_mark:

> Last changed: 2023-11-11

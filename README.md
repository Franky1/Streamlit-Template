# Streamlit Template Project

Streamlit template project for new streamlit projects.

[![Streamlit App](https://static.streamlit.io/badges/streamlit_badge_black_white.svg)](https://streamlit.io/)

## Dockerfile

This template contains a Dockerfile for local debugging and testing of the project, before deploying the project to Streamlit Cloud. This shall ease the process of developing and deploying projects to Streamlit Cloud, without endless back and forth trial-and-error between local development environment, GitHub and Streamlit Cloud.

The Dockerfile is based on `python:3.9-slim` image and shall mimic the Streamlit Cloud runtime as closely as possible.

**Hint**: If you run the Dockerfile locally on a Windows host system, you have to uncomment the `[server]` settings in the `.streamlit/config.toml` file. Comment these lines again before deploying the project to Streamlit Cloud.

### Usage

1. Clone the template project.
2. Write your code in the `streamlit_app.py` file.
3. If necessary: Add additional python dependencies to the `requirements.txt` file.
4. If necessary: Add binary dependencies to the `packages.txt` file. Keep the line-endings in Linux (LF only) format. Uncomment the binary installation lines in the Dockerfile.
5. Build the docker image locally (commands see below or in the Dockerfile).
6. Run the docker container locally (commands see below or in the Dockerfile) and debug your streamlit app locally until you are ready to deploy to Streamlit Cloud.
7. Deploy the project to Streamlit Cloud and test it.
8. Adjust the `Open in Streamlit` badge in this README.md file, that it points to the deployed project.
9. Adjust this README.md file and describe your streamlit project.

#### Docker commands

To build the docker image locally, run the following command:

```bash
docker build --progress=plain --tag streamlit:latest .
```

Then to run the docker container locally, run the following command:

```bash
docker run -ti -p 8501:8501 --rm streamlit:latest
```

> For more details, look into the [Dockerfile](Dockerfile) file.

## Resources

See also the official documentation from Streamlit about docker deployments:

<https://docs.streamlit.io/knowledge-base/tutorials/deploy/docker>

## Status

> Last changed: 2022-12-20

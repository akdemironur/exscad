# Exscad

Exscad is an OpenSCAD viewer written in Elixir using Phoenix LiveView and three.js.

## Usage

Follow these steps to set up and run Exscad on your local machine:

1. Clone the project:
`git clone https://github.com/akdemironur/exscad`
`cd exscad`

2. Build the Docker image:
`cd openscad`
`docker build . --tag openscad`

3. Return to the project root directory:
`cd ..`

4. Set up the Elixir environment:
`mix setup`

5. Start the Phoenix server:
`mix phx.server`

Now you can open your web browser and visit [localhost:4000](http://localhost:4000) to use Exscad.

## Known Issues

- [ ] Text functions in OpenSCAD are not working because there is no font in the Docker image.
- [ ] Invoking Docker from Elixir is possible but not recommended for production. Consider alternative solutions.
- [ ] Updating the textarea may sometimes trigger three.js controls unexpectedly.
- [ ] The initial camera position does not take into account the bounding box of the object.

Feel free to contribute by addressing these issues or submitting new ones. 
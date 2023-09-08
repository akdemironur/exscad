// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import * as THREE from "three"
import { STLLoader } from "three/addons/loaders/STLLoader.js";
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';

let hooks = {
  canvas: {
    mounted() {
      let canvas = this.el;
      let rawStl = canvas.dataset.stl;
      let context = canvas.getContext("3d");
      let scene = new THREE.Scene();
      scene.background = new THREE.Color(0x1f6e8c);
      const light = new THREE.DirectionalLight(0xffffff)
      light.position.set(-120, 120, -120)
      const light2 = new THREE.DirectionalLight(0xffffff)
      light2.position.set(120, -120, 120)
      let camera = new THREE.PerspectiveCamera(10, window.innerWidth / window.innerHeight, 0.1, 1000);
      let renderer = new THREE.WebGLRenderer({ canvas: canvas });
      let controls = new OrbitControls(camera, renderer.domElement)
      controls.enableDamping = true
      renderer.setSize(window.innerWidth, window.innerHeight);
      let material = new THREE.MeshPhongMaterial({ color: 0x84a7a1, specular: 0x111111, shininess: 200 })
      const loader = new STLLoader()
      let loadedStl = new THREE.Mesh(loader.parse(rawStl), material)
      loadedStl.position.set(0, 0, 0)
      let geometry = new THREE.EdgesGeometry(loadedStl.geometry);
      let material_wf = new THREE.LineBasicMaterial({ color: 0x000000 });
      let wireframe = new THREE.LineSegments(geometry, material_wf);

      scene.add(loadedStl)
      scene.add(wireframe)
      scene.add(new THREE.AxesHelper(5))
      scene.add(light)
      scene.add(light2)
      camera.position.z = 5;
      function animate() {

        requestAnimationFrame(animate);

        controls.update();
        renderer.render(scene, camera);

      }
      animate();
      // Object.assign(this, { canvas, context, scene, camera, renderer, loadedStl, material, controls });
    },
    updated() {
      mounted();
    }
  }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: hooks })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


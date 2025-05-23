import init, { Visualizer } from "./pkg/jarviz.js";

// Global variables for audio context and related objects
let audioCtx = null;
let audioSource = null;
let analyser = null;
let animationId = null;

async function run() {
  try {
    await init();
    console.log("WASM initialized successfully");
    
    const canvas = document.getElementById("gpu-canvas");
    const fileInput = document.getElementById("file-input");
    // Since Visualizer constructor is async, we need to await it
    
    // Set up keyboard listener for space key
    document.addEventListener("keydown", (event) => {
      if (event.code === "Space") {
        // Prevent default space behavior (like scrolling)
        event.preventDefault();
        if (viz && audioCtx) {
          viz.togglePause();
          if (viz.isPaused()) {
            audioCtx.suspend();
          } else {
            audioCtx.resume();
          }
        }
      }
    });
    console.log("Creating Visualizer...");
    const vizPromise = new Visualizer("gpu-canvas");
    
    // Properly await the Promise to get the actual Visualizer instance
    const viz = await vizPromise;
    console.log("Visualizer created successfully");
    


    fileInput.onchange = async () => {
      try {
        // Stop any previous visualization
        if (animationId) {
          cancelAnimationFrame(animationId);
        }
        if (audioSource) {
          audioSource.stop();
        }
        
        
        const file = fileInput.files[0];
        if (!file) return;
        
        const arrayBuffer = await file.arrayBuffer();
        audioCtx = new AudioContext();
        
        const buf = await audioCtx.decodeAudioData(arrayBuffer);
        audioSource = audioCtx.createBufferSource();
        audioSource.buffer = buf;

        analyser = audioCtx.createAnalyser();
        analyser.fftSize = 2048;
        audioSource.connect(analyser);
        analyser.connect(audioCtx.destination);
        
        audioSource.start();

        // Create a buffer for the audio data
        const data = new Uint8Array(1024);
        
        
        // Reset pause state when loading new audio
        if (viz.isPaused()) {
          viz.togglePause();
          audioCtx.resume();
        }
        
        function frame() {
          analyser.getByteTimeDomainData(data);
          
          // Try to call methods with more error handling
          let hasError = false;
          
          try {
              viz.update(data);
              viz.render();
          } catch (e) {
            console.error("Error calling viz methods:", e);
            hasError = true;
          }
          
          // Only continue the animation if there were no errors
          if (!hasError) {
            animationId = requestAnimationFrame(frame);
          } else {
            console.log("Stopping animation due to errors");
          }
        }
        animationId = requestAnimationFrame(frame);
        
        // Handle when audio finishes playing
        audioSource.onended = () => {
          cancelAnimationFrame(animationId);
        };
      } catch (error) {
        console.error("Error processing audio:", error);
        message.textContent = `Error: ${error.message}`;
      }
    };
  } catch (error) {
    console.error("Initialization error:", error);
    document.body.innerHTML = `<h1>Error initializing visualizer</h1><p>${error.message}</p>`;
  }
}


run();

import init, { Visualizer } from "./pkg/jarviz.js";

// Global variables for audio context and related objects
let audioCtx = null;
let audioSource = null;
let analyser = null;
let animationId = null;
let audioDuration = 0;
let seeking = false;
let audioBuffer = null;
let startTime = 0;
let pauseTime = 0;
let offsetTime = 0;
let sliderUpdateTimeout = null;
let lastUpdateTime = 0;

async function run() {
  try {
    await init();
    console.log("WASM initialized successfully");
    
    const canvas = document.getElementById("gpu-canvas");
    const fileInput = document.getElementById("file-input");
    // Since Visualizer constructor is async, we need to await it
    
    // Set up keyboard listener for space key (desktop)
    document.addEventListener("keydown", (event) => {
      if (event.code === "Space") {
        // Prevent default space behavior (like scrolling)
        event.preventDefault();
        togglePlayPause(viz, audioCtx);
      }
    });
    
    // Set up pause button for touch devices
    const pauseBtn = document.getElementById("pause-btn");
    pauseBtn.addEventListener("click", () => {
      togglePlayPause(viz, audioCtx);
      
      // Update button appearance
      if (viz && viz.isPaused()) {
        pauseBtn.classList.add("paused");
        pauseBtn.textContent = "Resume";
      } else {
        pauseBtn.classList.remove("paused");
        pauseBtn.textContent = "Pause";
      }
    });
    
    // Helper function to toggle play/pause
    function togglePlayPause(visualizer, context) {
      if (visualizer && context) {
        visualizer.togglePause();
        if (visualizer.isPaused()) {
          context.suspend();
          // Store pause time to adjust timing calculations
          pauseTime = context.currentTime;
        } else {
          context.resume();
          // Update start time to account for the pause duration
          if (pauseTime > 0) {
            startTime += (context.currentTime - pauseTime);
            pauseTime = 0;
          }
        }
      }
    }
    
    // Helper function to format time in MM:SS format
    function formatTime(seconds) {
      const minutes = Math.floor(seconds / 60);
      const remainingSeconds = Math.floor(seconds % 60);
      return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
    }
    
    // Setup seek slider
    const seekSlider = document.getElementById("seek-slider");
    const currentTimeDisplay = document.getElementById("current-time");
    const durationDisplay = document.getElementById("duration");
    
    // Add mousedown event to start seeking
    seekSlider.addEventListener("mousedown", function() {
      seeking = true;
      clearTimeout(sliderUpdateTimeout);
    });
    
    // Add touchstart event for mobile
    seekSlider.addEventListener("touchstart", function() {
      seeking = true;
      clearTimeout(sliderUpdateTimeout);
    });
    
    // Add global mouseup and touchend events to handle when slider is released
    document.addEventListener("mouseup", function() {
      if (seeking) {
        // Keep seeking true until the change event fully processes
        clearTimeout(sliderUpdateTimeout);
      }
    });
    
    document.addEventListener("touchend", function() {
      if (seeking) {
        // Keep seeking true until the change event fully processes
        clearTimeout(sliderUpdateTimeout);
      }
    });
    
    seekSlider.addEventListener("input", function() {
      seeking = true;
      const seekPosition = audioDuration * (seekSlider.value / 100);
      currentTimeDisplay.textContent = formatTime(seekPosition);
      
      // Update slider fill
      const percentage = seekSlider.value;
      seekSlider.style.background = `linear-gradient(to right, #ccffdd 0%, #ccffdd ${percentage}%, #333 ${percentage}%)`;
    });
    
    seekSlider.addEventListener("change", function() {
      if (audioCtx && audioSource && audioBuffer) {
        // We're still seeking during this handler
        seeking = true;
        
        // Update slider fill
        const percentage = seekSlider.value;
        seekSlider.style.background = `linear-gradient(to right, #ccffdd 0%, #ccffdd ${percentage}%, #333 ${percentage}%)`;
        
        // Remove the current onended handler before stopping to prevent it firing
        audioSource.onended = null;
        
        // Stop current audio source
        audioSource.stop();
        
        // Calculate the new position
        const seekPosition = audioDuration * (seekSlider.value / 100);
        
        // Update our time tracking variables
        startTime = audioCtx.currentTime;
        offsetTime = seekPosition;
        pauseTime = 0;
        
        // Create a new source for seeking
        audioSource = audioCtx.createBufferSource();
        audioSource.buffer = audioBuffer;
        
        // Create a new analyser node for the new source
        const oldAnalyser = analyser;
        analyser = audioCtx.createAnalyser();
        analyser.fftSize = oldAnalyser.fftSize;
        
        // Connect the new source to the analyser
        audioSource.connect(analyser);
        analyser.connect(audioCtx.destination);
        
        // Start playback from the new position
        audioSource.start(0, seekPosition);
        
        // Update the audio context's current time reference
        audioCtx.resume();
        
        // If viz is paused, unpause it
        if (viz && viz.isPaused()) {
          viz.togglePause();
          // Update pause button state
          const pauseBtn = document.getElementById("pause-btn");
          pauseBtn.classList.remove("paused");
          pauseBtn.textContent = "Pause";
        }
        
        // Immediately update the visualization with new data
        const bufferSize = analyser.fftSize / 2;
        const data = new Uint8Array(bufferSize);
        analyser.getByteTimeDomainData(data);
        viz.update(data);
        
        // Re-add the onended handler to the new audio source
        audioSource.onended = function() {
          console.log("Audio playback ended naturally");
          cancelAnimationFrame(animationId);
          
          // Reset the slider to the end position
          seekSlider.value = 100;
          currentTimeDisplay.textContent = formatTime(audioDuration);
          
          // Update pause button state
          const pauseBtn = document.getElementById("pause-btn");
          pauseBtn.classList.add("paused");
          pauseBtn.textContent = "Resume";
          
          // Pause the visualization
          if (viz && !viz.isPaused()) {
            viz.togglePause();
          }
        };
        
        // Important: Only set seeking to false AFTER everything is done,
        // and use a timeout to ensure the animation frame doesn't immediately
        // override our position
        clearTimeout(sliderUpdateTimeout);
        sliderUpdateTimeout = setTimeout(() => {
          seeking = false;
          lastUpdateTime = performance.now() + 500; // Prevent updates for 500ms
        }, 200);
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
        // Create audio context with mobile-friendly settings
        const AudioContext = window.AudioContext || window.webkitAudioContext;
        audioCtx = new AudioContext({
          latencyHint: 'interactive',
          sampleRate: 44100
        });
        
        const buf = await audioCtx.decodeAudioData(arrayBuffer);
        audioBuffer = buf;  // Store buffer globally for seeking
        audioDuration = buf.duration;
        
        // Update duration display
        durationDisplay.textContent = formatTime(audioDuration);
        
        // Enable and reset the seek slider
        seekSlider.disabled = false;
        seekSlider.value = 0;
        currentTimeDisplay.textContent = "0:00";
        seekSlider.style.background = `linear-gradient(to right, #ccffdd 0%, #ccffdd 0%, #333 0%)`;
        
        audioSource = audioCtx.createBufferSource();
        audioSource.buffer = buf;

        analyser = audioCtx.createAnalyser();
        // Use smaller FFT size on mobile for better performance
        const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
        analyser.fftSize = isMobile ? 1024 : 2048;
        audioSource.connect(analyser);
        analyser.connect(audioCtx.destination);
        
        audioSource.start();

        // Create a buffer for the audio data (size depends on FFT size)
        const bufferSize = analyser.fftSize / 2;
        const data = new Uint8Array(bufferSize);
        
        
        // Reset pause state when loading new audio
        if (viz.isPaused()) {
          viz.togglePause();
          audioCtx.resume();
        }
        
        // Reset time tracking variables
        startTime = audioCtx.currentTime;
        offsetTime = 0;
        pauseTime = 0;
        lastUpdateTime = performance.now();
        
        // Update pause button state
        const pauseBtn = document.getElementById("pause-btn");
        pauseBtn.classList.remove("paused");
        pauseBtn.textContent = "Pause";
        
        // On iOS, we need user interaction to start audio
        if (/iPhone|iPad|iPod/i.test(navigator.userAgent) && audioCtx.state === 'suspended') {
          const resumeAudio = () => {
            audioCtx.resume().then(() => {
              document.body.removeEventListener('touchstart', resumeAudio);
            });
          };
          document.body.addEventListener('touchstart', resumeAudio);
        }
        
        function frame() {
          analyser.getByteTimeDomainData(data);
          
          // Try to call methods with more error handling
          let hasError = false;
          
          try {
              viz.update(data);
              viz.render();
              
              // Update slider position if not currently seeking
              if (!seeking && audioCtx && audioSource && audioBuffer) {
                const now = performance.now();
                // Don't update too frequently and ensure we're not in a seeking operation
                if (now - lastUpdateTime > 250) {
                  // Calculate current playback position accounting for seeks and pauses
                  const elapsedTime = offsetTime + (audioCtx.currentTime - startTime);
                  
                  // Constrain to valid range and prevent overflow
                  const constrainedTime = Math.min(Math.max(elapsedTime, 0), audioDuration);
                  const sliderPosition = Math.min((constrainedTime / audioDuration) * 100, 100);
                  
                  // Only update if the slider position is valid and not too close to user-set position
                  if (sliderPosition >= 0 && sliderPosition <= 100) {
                    const currentPosition = parseFloat(seekSlider.value);
                    // Only update if the change is significant (prevents jitter and avoids overriding user input)
                    if (Math.abs(sliderPosition - currentPosition) > 1.0) {
                      seekSlider.value = sliderPosition;
                      currentTimeDisplay.textContent = formatTime(constrainedTime);
                      // Update slider fill
                      seekSlider.style.background = `linear-gradient(to right, #ccffdd 0%, #ccffdd ${sliderPosition}%, #333 ${sliderPosition}%)`;
                      lastUpdateTime = now;
                    }
                  }
                }
              }
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
        
        // Handle when audio finishes playing naturally (not during seeking)
        audioSource.onended = function() {
          console.log("Audio playback ended naturally");
          cancelAnimationFrame(animationId);
          
          // Reset the slider to the end position
          seekSlider.value = 100;
          currentTimeDisplay.textContent = formatTime(audioDuration);
          
          // Update pause button state
          const pauseBtn = document.getElementById("pause-btn");
          pauseBtn.classList.add("paused");
          pauseBtn.textContent = "Resume";
          
          // Pause the visualization
          if (viz && !viz.isPaused()) {
            viz.togglePause();
          }
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

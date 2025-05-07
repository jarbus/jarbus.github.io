//const chars = '!<>\/[]{}=+*^?#_$%&();:@"\~|0';
const chars = '>+*^#1234567890\/)@';

function scrambleText(el) {
  const targetText = el.dataset.original || el.textContent;
  el.dataset.original = targetText;
  const original = targetText.split('');
  let current = original.map(() => '');
  
  // Create array of indices and shuffle it for random reveal order
  const indices = Array.from({ length: original.length }, (_, i) => i)
    .sort(() => Math.random() - 0.5); // Better shuffling with random - 0.5
  
  let decodedCount = 0;
  let decodedPositions = new Set(); // Track which positions have been decoded
  
  // Calculate interval based on inverse of string length
  // Use a base value of 500 and divide by length, with min of 10ms and max of 100ms
  //const intervalDuration = Math.max(10, Math.min(50, Math.floor(500 / original.length)));
  const intervalDuration = Math.max(5, Math.min(50, Math.floor(500 / original.length)));
  
  const interval = setInterval(() => {
    // If all positions are decoded, clear the interval and exit
    if (decodedCount >= original.length) {
      clearInterval(interval);
      el.textContent = targetText;
      return;
    }
    
    // Get the next position from our shuffled indices
    const position = indices[decodedCount];
    decodedPositions.add(position);
    decodedCount++;
    
    // Update the current array with the original character at the position
    current[position] = original[position];
    
    // For all positions that haven't been decoded yet, use random characters
    for (let i = 0; i < original.length; i++) {
      if (!decodedPositions.has(i)) {
        // Preserve spaces, don't scramble them
        if (original[i] === ' ') {
          current[i] = ' ';
        } else {
          current[i] = chars[Math.floor(Math.random() * chars.length)];
        }
      }
    }
    
    el.textContent = current.join('');
  }, intervalDuration);
}

// Make sure the DOM is fully loaded before adding event listeners
document.addEventListener('DOMContentLoaded', () => {
  // Make the body visible once the page has loaded
  document.body.style.visibility = 'visible';
  document.body.style.opacity = '1';
  
  // Add event listeners to elements
  document.querySelectorAll('h1, h2, h3, h4, h5, h6, a').forEach(element => {
    element.addEventListener('mouseover', () => scrambleText(element));
  });
  // run on page load
  document.querySelectorAll('h1, h2, h3, h4, h5, h6, a').forEach(element => { scrambleText(element); });
  
});


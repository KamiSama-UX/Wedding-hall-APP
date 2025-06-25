const express = require('express');
const router = express.Router();
const db = require("../config/db");
const fs = require('fs');
const path = require('path');

// In-memory cache for halls data
let hallsCache = [];
let lastUpdated = null;
const CACHE_TTL = 60 * 60 * 1000; // 5 minutes in milliseconds

// Service synonyms mapping
const serviceSynonyms = {
  "valet": ["valet service", "parking", "car service"],
  "catering": ["food", "meal", "dining", "banquet"],
  "floral": ["flowers", "decorations", "arrangements"],
  "photography": ["photos", "pictures", "camera"],
  "music": ["band", "dj", "entertainment", "live music"],
  "champagne": ["toast", "drinks", "beverages"]
};

// Helper functions
function normalizeServiceTerm(term) {
  for (const [key, synonyms] of Object.entries(serviceSynonyms)) {
    if (synonyms.includes(term.toLowerCase())) {
      return key;
    }
  }
  return term;
}

function findHall(name) {
  return hallsCache.find(hall => 
    hall.name.toLowerCase().includes(name.toLowerCase())
  );
}

function getHallDetails(hallName) {
  const hall = findHall(hallName);
  if (!hall) return { text: "Venue not found. Try: Emerald Palace, Crystal Ballroom, Azure Gardens" };

  const services = hall.services.map(s => 
    `- ${s.name}: $${s.price} ${s.type}`
  ).join('\n') || 'Basic reservation only';

  return {
    text: `${hall.name} Details:\n📍 ${hall.location}\n👥 ${hall.capacity} guests\n💰 Base: $${hall.base_price}/person\n💡 ${hall.description}\n✨ Services:\n${services}`
  };
}

function compareHalls(name1, name2) {
  const hall1 = findHall(name1);
  const hall2 = findHall(name2);
  
  if (!hall1 || !hall2) {
    return { text: "One or both venues not found" };
  }

  let valueJudgment = '';
  if (hall1.base_price < hall2.base_price) {
    valueJudgment = `${hall1.name} is more budget-friendly`;
  } else if (hall1.base_price > hall2.base_price) {
    valueJudgment = `${hall2.name} is more budget-friendly`;
  } else {
    valueJudgment = "Base prices are similar";
  }

  return {
    text: `Comparing ${hall1.name} vs ${hall2.name}:\n\n` +
          `📍 Location: ${hall1.location} vs ${hall2.location}\n` +
          `👥 Capacity: ${hall1.capacity} vs ${hall2.capacity}\n` +
          `💰 Base Price: $${hall1.base_price} vs $${hall2.base_price}/person\n` +
          `💡 ${valueJudgment}`
  };
}

function getServiceDetails(hallName, serviceTerm) {
  const hall = findHall(hallName);
  if (!hall) return { text: "Venue not found" };
  
  const normalizedTerm = normalizeServiceTerm(serviceTerm);
  const service = hall.services.find(s => 
    s.name.toLowerCase().includes(normalizedTerm)
  );
  
  if (!service) {
    return { text: `${hall.name} doesn't offer ${serviceTerm} services` };
  }
  
  return {
    text: `${hall.name} ${service.name}:\n💰 Price: $${service.price} ${service.type}\n💡 Included in packages: No`
  };
}

function getRecommendation(input) {
  let candidates = [...hallsCache];
  let filters = [];

  // Location filters
  const locationPatterns = [
    { pattern: 'downtown', filter: h => h.location.toLowerCase().includes('downtown') },
    { pattern: 'beach|ocean', filter: h => h.description.toLowerCase().includes('beach') },
    { pattern: 'river', filter: h => h.location.toLowerCase().includes('riverside') },
    { pattern: 'garden', filter: h => h.description.toLowerCase().includes('garden') },
    { pattern: 'financial', filter: h => h.location.toLowerCase().includes('financial') }
  ];

  locationPatterns.forEach(loc => {
    if (new RegExp(loc.pattern).test(input)) {
      filters.push(loc.pattern);
      candidates = candidates.filter(loc.filter);
    }
  });

  // Budget filters
  const budgetTerms = ['cheap', 'budget', 'afford', 'low-cost', 'inexpensive', 'economical'];
  const luxuryTerms = ['luxury', 'premium', 'high-end', 'deluxe', 'exclusive'];
  
  if (budgetTerms.some(term => input.includes(term))) {
    candidates.sort((a, b) => a.base_price - b.base_price);
    const best = candidates[0];
    return {
      text: `Best budget${filters.length ? ' ' + filters.join('/') : ''} option:\n\n` +
            `🏰 ${best.name}\n💰 $${best.base_price}/person\n👥 ${best.capacity} guests\n` +
            `📍 ${best.location}\n💡 ${best.description}`
    };
  }
  
  if (luxuryTerms.some(term => input.includes(term))) {
    candidates.sort((a, b) => b.base_price - a.base_price);
    const best = candidates[0];
    return {
      text: `Best luxury${filters.length ? ' ' + filters.join('/') : ''} option:\n\n` +
            `🏰 ${best.name}\n💰 $${best.base_price}/person\n👥 ${best.capacity} guests\n` +
            `📍 ${best.location}\n💡 ${best.description}`
    };
  }

  // Service filters
  const servicePatterns = [
    { pattern: 'valet|parking', service: 'valet' },
    { pattern: 'catering|food|meal', service: 'catering' },
    { pattern: 'floral|flowers|decor', service: 'floral' },
    { pattern: 'photo|picture', service: 'photography' },
    { pattern: 'music|band|dj', service: 'music' },
    { pattern: 'champagne|drink|toast', service: 'champagne' }
  ];

  for (const servicePattern of servicePatterns) {
    if (new RegExp(servicePattern.pattern).test(input)) {
      const withService = hallsCache.find(h => 
        h.services.some(s => s.name.toLowerCase().includes(servicePattern.service))
      );
      
      return withService 
        ? { 
            text: `${withService.name} offers ${servicePattern.service} services\n💰 Starting at $${withService.services.find(s => s.name.toLowerCase().includes(servicePattern.service)).price} ${withService.services.find(s => s.name.toLowerCase().includes(servicePattern.service)).type}`
          }
        : { text: `No venues with ${servicePattern.service} service found` };
    }
  }

  // Capacity filters
  const capacityMatch = input.match(/(\d+)\s+guests|people|attendees/);
  if (capacityMatch) {
    const capacity = parseInt(capacityMatch[1]);
    const suitableHalls = candidates.filter(h => h.capacity >= capacity);
    
    if (suitableHalls.length === 0) {
      return { text: `No venues found for ${capacity} guests. Try a smaller number.` };
    }
    
    suitableHalls.sort((a, b) => a.base_price - b.base_price);
    const best = suitableHalls[0];
    
    return {
      text: `Best venue for ${capacity} guests:\n\n` +
            `🏰 ${best.name}\n👥 Capacity: ${best.capacity}\n💰 $${best.base_price}/person\n` +
            `📍 ${best.location}`
    };
  }

  return {
    text: `Try being more specific:\n- "Best budget beach venue"\n- "Affordable downtown option"\n- "Recommend venue with valet service"`
  };
}

function extractHalls(input) {
  const patterns = [
    /compare (.+?) and (.+)/i,
    /(.+?) vs (.+)/i,
    /difference between (.+?) and (.+)/i,
    /which is better: (.+?) or (.+)\?/i,
    /contrast (.+?) and (.+)/i,
    /(.+?) versus (.+)/i
  ];

  for (const pattern of patterns) {
    const match = input.match(pattern);
    if (match && match.length >= 3) {
      return [match[1].trim(), match[2].trim()];
    }
  }
  return [];
}

function extractVenueAndService(input) {
  const patterns = [
    /does (.+?) have (.+)\??/i,
    /what (.+) at (.+)/i,
    /(.+) at (.+)/i,
    /(.+) availability at (.+)/i,
    /price for (.+) at (.+)/i
  ];

  for (const pattern of patterns) {
    const match = input.match(pattern);
    if (match && match.length >= 3) {
      return { venue: match[2].trim(), service: match[1].trim() };
    }
  }
  return null;
}

// Function to fetch halls data
async function fetchHallsData() {
  try {
    const [halls] = await db.query(`
      SELECT id, name, location, capacity, description 
      FROM wedding_halls
    `);

    const [services] = await db.query(`
      SELECT id, hall_id, name, price_per_person, pricing_type 
      FROM services
    `);

    const hallsData = halls.map(hall => {
      const baseService = services.find(
        s => s.hall_id === hall.id && 
             s.name === 'Cost per person reservation'
      );
      
      const additionalServices = services
        .filter(s => s.hall_id === hall.id && 
                     s.name !== 'Cost per person reservation')
        .map(s => ({
          name: s.name,
          price: s.price_per_person,
          type: s.pricing_type === 'static' ? 'fixed' : 'per person'
        }));

      return {
        id: hall.id,
        name: hall.name,
        location: hall.location,
        capacity: hall.capacity,
        description: hall.description,
        base_price: baseService ? baseService.price_per_person : 0,
        services: additionalServices
      };
    });

    return hallsData;
  } catch (error) {
    console.error('Database error:', error);
    throw error;
  }
}

// Initialize cache and start refresh interval
async function initializeCache() {
  try {
    console.log('Initializing halls cache...');
    hallsCache = await fetchHallsData();
    lastUpdated = new Date();
    console.log(`Cache initialized with ${hallsCache.length} halls at ${lastUpdated}`);
  } catch (error) {
    console.error('Failed to initialize cache:', error);
  }
}

// Refresh cache periodically
function startCacheRefresh() {
  setInterval(async () => {
    try {
      console.log('Refreshing halls cache...');
      const newData = await fetchHallsData();
      hallsCache = newData;
      lastUpdated = new Date();
      console.log(`Cache refreshed at ${lastUpdated}`);
    } catch (error) {
      console.error('Cache refresh failed:', error);
    }
  }, CACHE_TTL);
}

// Chatbot API endpoint
router.post('/B', async (req, res) => {
  try {
    const userInput = req.body.message.toLowerCase();
    let response = { text: "I can help with venue details, comparisons, service info, and recommendations." };

    // Check if cache is empty
    if (hallsCache.length === 0) {
      await initializeCache();
    }

    // 1. Hall details request (expanded triggers)
    const hallDetailRegex = /(tell me about|describe|info on|details for|what's special about|features of|specifications of|what does .+ offer|tell me more about|can you describe) (.+)/i;
    if (hallDetailRegex.test(userInput)) {
      const hallName = userInput.match(hallDetailRegex)[2];
      response = getHallDetails(hallName);
    }
    
    // 2. Comparison request (expanded patterns)
    else if (/(compare|vs|versus|difference between|which is better|compared to|show differences|contrast)/i.test(userInput)) {
      const hallsToCompare = extractHalls(userInput);
      if (hallsToCompare.length >= 2) {
        response = compareHalls(hallsToCompare[0], hallsToCompare[1]);
      } else {
        response.text = "Please specify two halls to compare (e.g., 'compare Azure Gardens and Crystal Ballroom')";
      }
    }
    
    // 3. Service inquiry (new intent)
    else if (/(does .+ have|what .+ at|.+ at .+|.+ availability at|price for .+ at)/i.test(userInput)) {
      const extraction = extractVenueAndService(userInput);
      if (extraction) {
        response = getServiceDetails(extraction.venue, extraction.service);
      } else {
        response.text = "Please specify a venue and service (e.g., 'Does Azure Gardens have valet service?')";
      }
    }
    
    // 4. Recommendation request (expanded triggers)
    else if (/(recommend|suggest|best|good|find|looking for|top|favorite|prefer|ideal|perfect|should i choose)/i.test(userInput)) {
      response = getRecommendation(userInput);
    }
    
    // 5. Location-based request
    else if (/(downtown|beach|ocean|river|riverside|garden|financial|harbor|historic|university)/i.test(userInput)) {
      response = getRecommendation(userInput);
    }
    
    res.json(response);
  } catch (error) {
    console.error('Chatbot error:', error);
    res.status(500).json({ text: "Sorry, I'm having trouble. Please try again later." });
  }
});

// Endpoint to get cache status
router.get('/cache-status', (req, res) => {
  res.json({
    lastUpdated,
    hallCount: hallsCache.length,
    cacheTTL: `${CACHE_TTL / 60000} minutes`
  });
});

// Initialize cache when module loads
initializeCache();
// Start periodic refresh
startCacheRefresh();

// New function to export data to JSON
async function exportToJson() {
  try {
    const data = JSON.stringify(hallsCache, null, 2);
    const filePath = path.join(__dirname, '../../../wedding-chatbot-env/venue_data.json');
    
    fs.writeFileSync(filePath, data);
    console.log(`✅ Venue data exported to ${filePath}`);
    
    return filePath;
  } catch (error) {
    console.error('JSON export error:', error);
    return null;
  }
}

// Add this to your initializeCache function
async function initializeCache() {
  try {
    console.log('Initializing halls cache...');
    hallsCache = await fetchHallsData();
    lastUpdated = new Date();
    console.log(`Cache initialized with ${hallsCache.length} halls at ${lastUpdated}`);
    
    // Export to JSON on startup
    await exportToJson();
  } catch (error) {
    console.error('Failed to initialize cache:', error);
  }
}

// Add this to your refresh interval
function startCacheRefresh() {
  setInterval(async () => {
    try {
      console.log('Refreshing halls cache...');
      const newData = await fetchHallsData();
      hallsCache = newData;
      lastUpdated = new Date();
      console.log(`Cache refreshed at ${lastUpdated}`);
      
      // Export to JSON on refresh
      await exportToJson();
    } catch (error) {
      console.error('Cache refresh failed:', error);
    }
  }, CACHE_TTL);
}

// Add this endpoint to your router
router.get('/export-json', async (req, res) => {
  const filePath = await exportToJson();
  if (filePath) {
    res.download(filePath);
  } else {
    res.status(500).send('Export failed');
  }
});

module.exports = router;
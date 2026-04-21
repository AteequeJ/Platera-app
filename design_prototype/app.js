const ingredients = [
    { name: 'Avocado', icon: '🥑', size: 1.2 },
    { name: 'Tomato', icon: '🍅', size: 0.9 },
    { name: 'Spinach', icon: '🍃', size: 1.1 },
    { name: 'Chickpeas', icon: '🫘', size: 0.8 },
    { name: 'Quinoa', icon: '🌾', size: 1.0 },
    { name: 'Lemon', icon: '🍋', size: 0.7 },
    { name: 'Garlic', icon: '🧄', size: 0.6 },
    { name: 'Olive Oil', icon: '🫒', size: 0.8 },
    { name: 'Salmon', icon: '🐟', size: 1.3 },
    { name: 'Asparagus', icon: '🌱', size: 1.0 }
];

const dishes = [
    {
        id: 'ready-1',
        name: 'Gourmet Grain Bowl',
        description: 'Vibrant bowl with roasted chickpeas, avocado, and fresh greens.',
        image: 'assets/ready.png',
        ready: true,
        ingredients: ['Avocado', 'Chickpeas', 'Spinach', 'Quinoa', 'Tomato'],
        missing: []
    },
    {
        id: 'almost-1',
        name: 'Balsamic Glazed Salmon',
        description: 'Slow-roasted salmon with asparagus and quinoa.',
        image: 'assets/almost.png',
        ready: false,
        ingredients: ['Salmon', 'Asparagus', 'Quinoa', 'Lemon'],
        missing: ['Balsamic Vinegar', 'Fresh Dill']
    }
];

// Initialize Ingredient Cloud
function initCloud() {
    const cloud = document.getElementById('ingredient-cloud');
    const container = document.querySelector('.ingredient-cloud-container');
    const width = container.offsetWidth;
    const height = container.offsetHeight;

    ingredients.forEach((ing, i) => {
        const bubble = document.createElement('div');
        bubble.className = 'bubble fade-in';
        bubble.style.left = `${Math.random() * (width - 100)}px`;
        bubble.style.top = `${Math.random() * (height - 60)}px`;
        bubble.style.transform = `scale(${ing.size})`;
        bubble.style.animationDelay = `${i * 0.1}s`;
        
        bubble.innerHTML = `<i>${ing.icon}</i> ${ing.name}`;
        
        // Simple float animation
        animateBubble(bubble);
        cloud.appendChild(bubble);
    });
}

function animateBubble(el) {
    let x = parseFloat(el.style.left);
    let y = parseFloat(el.style.top);
    const container = el.parentElement;
    const maxX = container.offsetWidth - el.offsetWidth;
    const maxY = container.offsetHeight - el.offsetHeight;
    
    let dx = (Math.random() - 0.5) * 0.4;
    let dy = (Math.random() - 0.5) * 0.4;

    function move() {
        x += dx;
        y += dy;
        
        if (x <= 0 || x >= maxX) dx *= -1;
        if (y <= 0 || y >= maxY) dy *= -1;
        
        el.style.left = `${x}px`;
        el.style.top = `${y}px`;
        requestAnimationFrame(move);
    }
    move();
}

// Navigation
function navigateTo(screenId) {
    document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
    document.getElementById(screenId).classList.add('active');
    
    if (screenId === 'suggestions-screen') {
        renderSuggestions();
    }
}

// Render Suggestions
function renderSuggestions() {
    const readyContainer = document.getElementById('ready-to-cook');
    const almostContainer = document.getElementById('almost-there');
    
    readyContainer.innerHTML = '';
    almostContainer.innerHTML = '';

    dishes.forEach(dish => {
        const card = document.createElement('div');
        card.className = 'dish-card fade-in';
        card.onclick = () => showDetail(dish);
        
        card.innerHTML = `
            <div class="dish-image-wrapper">
                <img src="${dish.image}" alt="${dish.name}">
            </div>
            <div class="dish-info">
                <div class="dish-meta">
                    <h4>${dish.name}</h4>
                    ${dish.ready ? '<span class="tag-ready">READY</span>' : ''}
                </div>
                ${!dish.ready ? `
                    <div class="missing-tags">
                        ${dish.missing.map(m => `<span class="missing-tag">+ ${m}</span>`).join('')}
                    </div>
                ` : ''}
            </div>
        `;

        if (dish.ready) {
            readyContainer.appendChild(card);
        } else {
            almostContainer.appendChild(card);
        }
    });
}

// Show Detail
function showDetail(dish) {
    const screen = document.getElementById('detail-screen');
    document.getElementById('dish-name').innerText = dish.name;
    document.getElementById('dish-description').innerText = dish.description;
    document.getElementById('detail-image').src = dish.image;
    
    const ingList = document.getElementById('detail-ingredients');
    ingList.innerHTML = '';
    
    dish.ingredients.forEach(ing => {
        const tag = document.createElement('span');
        tag.className = 'ing-tag';
        tag.innerText = ing;
        ingList.appendChild(tag);
    });

    dish.missing.forEach(ing => {
        const tag = document.createElement('span');
        tag.className = 'ing-tag missing';
        tag.innerText = ing;
        ingList.appendChild(tag);
    });

    navigateTo('detail-screen');
}

// Event Listeners
document.getElementById('generate-btn').addEventListener('click', () => {
    navigateTo('suggestions-screen');
});

// Start
window.onload = () => {
    initCloud();
};

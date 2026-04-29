// Scroll Animations
document.addEventListener('DOMContentLoaded', () => {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
            }
        });
    }, observerOptions);

    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
});

// Translation Data
const translations = {
    ar: {
        nav_download: "حمل الآن",
        hero_title: 'تطبيق "اشترِ لي" <br><span class="highlight">كل ما تحتاجه في مكان واحد</span>',
        hero_desc: "منصة جزائرية مبتكرة تجمع بين التسوق الذكي، إدارة المتاجر، وفرص العمل.",
        btn_download: "تحميل APK للأندرويد (مجاناً)",
        roles_header: "نظام متكامل لجميع الفئات",
        role_customer: "أنا زبون",
        role_customer_desc: "تصفح المنتجات، قارن الأسعار، واطلب ما تحتاجه ليصلك لباب منزلك.",
        role_merchant: "أنا تاجر",
        role_merchant_desc: "حول متجرك التقليدي لمتجر رقمي في دقائق، واكتسب زبائن جدد يومياً.",
        test_header: "ماذا يقول مستخدمونا؟",
        user_1_text: '"تطبيق ممتاز ساعدني في الوصول لزبائن في مناطق لم أكن أتوقعها."',
        user_1_name: "أحمد بن محمد",
        user_1_role: "تاجر تجزئة",
        user_2_text: '"أحب ميزة الخريطة كثيراً، أستطيع أن أرى المتاجر المفتوحة حولي وأطلب بسرعة."',
        user_2_name: "سارة علي",
        user_2_role: "زبونة دائمة",
        stat_downloads: "تحميل",
        stat_stores: "متجر مسجل",
        stat_jobs: "فرصة عمل",
        stat_rating: "تقييم",
        copyright: "© 2026 جميع الحقوق محفوظة - Buy For Me الجزائر"
    },
    en: {
        nav_download: "Download",
        hero_title: 'Buy For Me <br><span class="highlight">Everything in one place</span>',
        hero_desc: "An innovative Algerian platform combining smart shopping, store management, and job opportunities.",
        btn_download: "Download APK (Free)",
        roles_header: "Integrated System for All",
        role_customer: "I am a Customer",
        role_customer_desc: "Browse products, compare prices, and order items to your door.",
        role_merchant: "I am a Merchant",
        role_merchant_desc: "Turn your store into a digital shop in minutes, gain new customers.",
        test_header: "User Reviews",
        user_1_text: '"Excellent app helped me reach customers in new areas."',
        user_1_name: "Ahmed Bin Mohamed",
        user_1_role: "Retail Merchant",
        user_2_text: '"I love the map feature, I can find open stores around me quickly."',
        user_2_name: "Sarah Ali",
        user_2_role: "Regular Customer",
        stat_downloads: "Downloads",
        stat_stores: "Stores",
        stat_jobs: "Jobs",
        stat_rating: "Rating",
        copyright: "© 2026 All Rights Reserved - Buy For Me Algeria"
    },
    fr: {
        nav_download: "Télécharger",
        hero_title: 'Buy For Me <br><span class="highlight">Tout au même endroit</span>',
        hero_desc: "Plateforme algérienne innovante alliant shopping, gestion et opportunités d'emploi.",
        btn_download: "Télécharger APK (Gratuit)",
        roles_header: "Système intégré pour tous",
        role_customer: "Je suis Client",
        role_customer_desc: "Parcourez les produits et commandez ce dont vous avez besoin.",
        role_merchant: "Je suis Marchand",
        role_merchant_desc: "Transformez votre magasin en boutique numérique en quelques minutes.",
        test_header: "Avis des utilisateurs",
        user_1_text: '"Excellente application qui m\'a aidé à atteindre de nouveaux clients."',
        user_1_name: "Ahmed",
        user_1_role: "Marchand",
        user_2_text: '"J\'aime la fonction carte, je trouve vite les magasins proches."',
        user_2_name: "Sarah",
        user_2_role: "Cliente",
        stat_downloads: "Téléchargements",
        stat_stores: "Magasins",
        stat_jobs: "Emplois",
        stat_rating: "Note",
        copyright: "© 2026 Tous droits réservés"
    }
};

function setLanguage(lang) {
    localStorage.setItem('preferredLang', lang);
    const html = document.documentElement;
    html.setAttribute('lang', lang);
    html.setAttribute('dir', lang === 'ar' ? 'rtl' : 'ltr');

    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        if (translations[lang][key]) {
            el.innerHTML = translations[lang][key];
        }
    });
}

// Initial Load
const savedLang = localStorage.getItem('preferredLang') || 'ar';
setLanguage(savedLang);

// Theme Toggle
const themeToggle = document.getElementById('theme-toggle');
const body = document.body;

themeToggle.addEventListener('click', () => {
    body.classList.toggle('light-mode');
    const icon = themeToggle.querySelector('i');
    if (body.classList.contains('light-mode')) {
        icon.className = 'fas fa-sun';
    } else {
        icon.className = 'fas fa-moon';
    }
});

// Particle Background
const canvas = document.getElementById('bg-canvas');
const ctx = canvas.getContext('2d');
let particles = [];

function resize() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
}
window.addEventListener('resize', resize);
resize();

class Particle {
    constructor() {
        this.reset();
    }
    reset() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.size = Math.random() * 2 + 1;
        this.vx = Math.random() * 0.4 - 0.2;
        this.vy = Math.random() * 0.4 - 0.2;
    }
    update() {
        this.x += this.vx;
        this.y += this.vy;
        if (this.x < 0 || this.x > canvas.width) this.vx *= -1;
        if (this.y < 0 || this.y > canvas.height) this.vy *= -1;
    }
    draw() {
        ctx.fillStyle = 'rgba(76, 175, 80, 0.3)';
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
    }
}

for (let i = 0; i < 50; i++) particles.push(new Particle());

function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    particles.forEach(p => {
        p.update();
        p.draw();
    });
    requestAnimationFrame(animate);
}
animate();

// Fetch Stats
const supabaseUrl = 'https://hrraflleindvjvaqofnz.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'; // Keeping your key

async function fetchStats() {
    if (typeof window.supabase !== 'undefined') {
        const supabase = window.supabase.createClient(supabaseUrl, supabaseKey);
        const { count: s } = await supabase.from('stores').select('*', { count: 'exact', head: true });
        if (s) document.getElementById('stores-count').textContent = `+${s}`;
    }
}
fetchStats();

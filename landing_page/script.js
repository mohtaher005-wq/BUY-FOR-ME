/* =============================================
   BUY FOR ME — COMPLETE SCRIPT
   =============================================
   1. Translations (AR / EN / FR)
   2. Language Switcher
   3. Theme Toggle
   4. Scroll Reveal Observer
   5. Navbar Shrink on Scroll
   6. Mouse Glow Orb
   7. 3D Parallax Hero Image
   8. Interactive Card Tilt
   9. Counter Animation (Stats)
  10. Particle Canvas Background
  11. Download Modal
  12. Supabase Stats Fetch
============================================= */

// ─── 0 — DOWNLOAD MODAL ────────────────────────────────────────────────

function showDownloadModal() {
    const modal = document.getElementById('dl-modal');
    modal.style.display = 'flex';
    // Prevent body scroll
    document.body.style.overflow = 'hidden';
}

function hideDownloadModal() {
    const modal = document.getElementById('dl-modal');
    modal.style.display = 'none';
    document.body.style.overflow = '';
}

// Close on Escape key
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') hideDownloadModal();
});


// ─── 1 & 2 — TRANSLATIONS ──────────────────────────────────────────────────

const translations = {
    ar: {
        // Navbar
        nav_download: "تحميل APK",

        // Hero
        hero_badge:  "المنصة الجزائرية الأولى للتجارة الذكية",
        hero_title:  'اكتشف مستقبل <br><span class="highlight">التجارة الذكية في الجزائر</span>',
        hero_desc:   "منصة Buy For Me ليست مجرد تطبيق، بل هي نظام متكامل يربط الزبائن بالتجار، ويوفر فرص عمل حقيقية للشباب الجزائري.",
        btn_download: "تحميل التطبيق مجاناً",
        btn_explore:  "اكتشف المزايا",

        // Hero Stats
        stat_downloads: "تحميل",
        stat_stores:    "متجر",
        stat_rating:    "تقييم",

        // Features Section
        features_badge:      "🚀 مزايا حصرية",
        features_header:     "لماذا تختار Buy For Me؟",
        features_subheader:  "نظام متكامل يخدم الجميع — الزبون، التاجر، والباحث عن عمل.",
        feat_map:          "خريطة تفاعلية ذكية",
        feat_map_desc:     "اكتشف المتاجر المفتوحة من حولك في الوقت الحقيقي. فلاتر ذكية حسب المسافة والفئة والتقييم.",
        feat_merchant:     "إدارة متاجر احترافية",
        feat_merchant_desc:"رفع المنتجات، إدارة الطلبات، والإحصائيات المباشرة كلها في راحة يدك.",
        feat_jobs:         "فرص عمل محلية",
        feat_jobs_desc:    "خريطة مخصصة للباحثين عن عمل تتيح التقديم الفوري للمتاجر القريبة بضغطة واحدة.",
        feat_secure:       "آمن وموثوق",
        feat_secure_desc:  "بياناتك وطلباتك محمية بأحدث معايير الأمن والتشفير. ثق بنا لتتعامل بثقة.",

        // Gallery Section
        real_badge:        "📸 الواقع الحقيقي",
        real_impact_header:"Buy For Me على أرض الواقع",
        real_impact_sub:   "من الرف إلى بابك — نحن نعيش التجربة معك كل يوم.",
        gtag_1:       "التسوق الذكي",
        real_1_title: "خدمة لا تتوقف",
        real_1_desc:  "نتعامل مع أكبر المساحات التجارية لضمان طلباتكم تصل في أسرع وقت ممكن.",
        gtag_2:       "التطبيق",
        real_2_title: "طلب بنقرة واحدة",
        real_2_desc:  "واجهة سهلة ومبسطة تتيح لك تقديم طلبك خلال ثوانٍ معدودة.",
        gtag_3:       "التوصيل",
        real_3_title: "توصيل سريع وآمن",
        real_3_desc:  "شبكة واسعة من الموصلين المحترفين تغطي كامل ولايات الوطن.",

        // Roles Section
        roles_badge:    "👥 ثلاثة أدوار",
        roles_header:   "تجربة مخصصة لكل مستخدم",
        roles_sub:      "سواء كنت زبوناً، تاجراً، أو باحثاً عن عمل — Buy For Me مصمم خصيصاً لك.",
        role_customer:     "واجهة الزبون",
        role_customer_long:"تصفح المنتجات بحسب الفئات، قارن الأسعار، صنّف المتاجر بالنجوم، وتابع طلبك لحظة بلحظة حتى وصوله لبابك.",
        role_merchant:     "لوحة تحكم التاجر",
        role_merchant_long:"أنشئ متجرك الرقمي في دقائق، ارفع منتجاتك، نظّمها في فئات، واستقبل الطلبات مع تنبيهات فورية لا تفوّت أي زبون.",
        role_jobseeker:     "نظام الباحث عن عمل",
        role_jobseeker_long:"استكشف الخريطة لمعرفة المتاجر التي تطلب كوادر، وأرسل طلبك مباشرة بضغطة زر.",

        // Testimonials
        test_badge:   "💬 آراء حقيقية",
        test_header:  "شركاؤنا في النجاح يتحدثون",
        user_1_text:  "\"كنت أواجه صعوبة كبيرة في التسويق المحلي. بفضل Buy For Me تضاعفت مبيعاتي في شهر واحد فقط، ووصلت لزبائن لم أتوقعهم!\"",
        user_1_name:  "ياسين بن عيسى",
        user_1_role:  "صاحب متجر إلكترونيات — الجزائر العاصمة",
        user_2_text:  "\"التطبيق سهل الاستخدام بشكل لا يصدق. أطلب مستلزماتي من العمل وتصلني حين أعود للمنزل. وفّر لي وقتاً ثميناً كل يوم.\"",
        user_2_name:  "ليلى مرابط",
        user_2_role:  "زبونة وفية — وهران",

        // Stats
        stat_downloads_full: "تحميل نشط",
        stat_stores_full:    "متجر معتمد",
        stat_jobs_full:      "فرصة عمل متاحة",
        stat_rating_full:    "تقييم المستخدمين",

        // Footer
        footer_slogan: "نحو اقتصاد رقمي جزائري أفضل",
        copyright:     "© 2026 جميع الحقوق محفوظة — Buy For Me الجزائر",
    },

    en: {
        nav_download: "Download APK",
        hero_badge:   "Algeria's #1 Smart Commerce Platform",
        hero_title:   'Discover the Future of <br><span class="highlight">Smart Commerce in Algeria</span>',
        hero_desc:    "Buy For Me is not just an app — it's an integrated ecosystem connecting customers with merchants and creating real job opportunities for Algerian youth.",
        btn_download:  "Download App Free",
        btn_explore:   "Explore Features",
        stat_downloads:"Downloads",
        stat_stores:   "Stores",
        stat_rating:   "Rating",

        features_badge:     "🚀 Exclusive Features",
        features_header:    "Why Choose Buy For Me?",
        features_subheader: "One integrated system for everyone — customer, merchant, and job seeker.",
        feat_map:          "Smart Interactive Map",
        feat_map_desc:     "Discover open stores near you in real-time with smart filters by distance, category, and rating.",
        feat_merchant:     "Pro Store Management",
        feat_merchant_desc:"Upload products, manage orders, and view live stats — all from your phone.",
        feat_jobs:         "Local Job Opportunities",
        feat_jobs_desc:    "A dedicated map to find jobs in nearby stores and apply instantly.",
        feat_secure:       "Secure & Trusted",
        feat_secure_desc:  "Your data and orders are protected by the latest encryption standards.",

        real_badge:        "📸 Real Life Impact",
        real_impact_header:"Buy For Me in Action",
        real_impact_sub:   "From the shelf to your door — we live the experience with you.",
        gtag_1:       "Smart Shopping",
        real_1_title: "Non-stop Service",
        real_1_desc:  "Partnered with the biggest supermarkets to ensure orders arrive fast.",
        gtag_2:       "The App",
        real_2_title: "One-Tap Ordering",
        real_2_desc:  "A clean, simple UI lets you place your order in seconds.",
        gtag_3:       "Delivery",
        real_3_title: "Fast & Safe Delivery",
        real_3_desc:  "A wide network of professional couriers covering all provinces.",

        roles_badge:   "👥 Three Roles",
        roles_header:  "Custom Experience for Everyone",
        roles_sub:     "Whether you're a customer, merchant, or job seeker — Buy For Me is built for you.",
        role_customer:     "Customer Interface",
        role_customer_long:"Browse products by category, compare prices, rate stores, and track your order every step of the way.",
        role_merchant:     "Merchant Dashboard",
        role_merchant_long:"Create your digital store in minutes, upload products, and receive real-time orders with instant alerts.",
        role_jobseeker:    "Job Seeker System",
        role_jobseeker_long:"Explore the map to find stores hiring and apply directly with a single tap.",

        test_badge:   "💬 Real Reviews",
        test_header:  "Our Partners Speak",
        user_1_text:  "\"I struggled with local marketing. Thanks to Buy For Me, my sales doubled in a single month and I reached customers I didn't expect!\"",
        user_1_name:  "Yassine Benaissa",
        user_1_role:  "Electronics Store Owner — Algiers",
        user_2_text:  "\"Incredibly easy to use. I order my groceries from work and they arrive when I get home. Saves me valuable time every day.\"",
        user_2_name:  "Leila Merabet",
        user_2_role:  "Loyal Customer — Oran",

        stat_downloads_full:"Active Downloads",
        stat_stores_full:   "Certified Stores",
        stat_jobs_full:     "Available Jobs",
        stat_rating_full:   "User Rating",

        footer_slogan:"Towards a better Algerian digital economy",
        copyright:    "© 2026 All Rights Reserved — Buy For Me Algeria",
    },

    fr: {
        nav_download: "Télécharger APK",
        hero_badge:   "La 1ère plateforme algérienne de commerce intelligent",
        hero_title:   'Découvrez le Futur du <br><span class="highlight">Commerce Intelligent en Algérie</span>',
        hero_desc:    "Buy For Me est un écosystème intégré qui connecte clients et commerçants, et crée de vraies opportunités d'emploi pour la jeunesse algérienne.",
        btn_download:  "Télécharger Gratuitement",
        btn_explore:   "Découvrir les fonctions",
        stat_downloads:"Téléchargements",
        stat_stores:   "Magasins",
        stat_rating:   "Note",

        features_badge:     "🚀 Fonctionnalités exclusives",
        features_header:    "Pourquoi choisir Buy For Me ?",
        features_subheader: "Un système intégré pour tous — client, commerçant et chercheur d'emploi.",
        feat_map:          "Carte Interactive Intelligente",
        feat_map_desc:     "Découvrez les magasins ouverts autour de vous en temps réel avec des filtres intelligents.",
        feat_merchant:     "Gestion de Boutique Pro",
        feat_merchant_desc:"Publiez vos produits, gérez les commandes et consultez vos stats en direct.",
        feat_jobs:         "Emplois Locaux",
        feat_jobs_desc:    "Une carte dédiée pour trouver des offres d'emploi à proximité et postuler en un clic.",
        feat_secure:       "Sécurisé & Fiable",
        feat_secure_desc:  "Vos données et commandes sont protégées par les dernières normes de chiffrement.",

        real_badge:        "📸 Sur le terrain",
        real_impact_header:"Buy For Me en action",
        real_impact_sub:   "De l'étagère à votre porte — nous vivons l'expérience avec vous.",
        gtag_1:       "Shopping Intelligent",
        real_1_title: "Service Continu",
        real_1_desc:  "En partenariat avec les plus grandes enseignes pour des livraisons rapides.",
        gtag_2:       "L'Application",
        real_2_title: "Commande en 1 clic",
        real_2_desc:  "Une interface simple et claire pour passer vos commandes en quelques secondes.",
        gtag_3:       "Livraison",
        real_3_title: "Livraison Rapide & Sûre",
        real_3_desc:  "Un vaste réseau de livreurs professionnels couvrant toutes les wilayas.",

        roles_badge:   "👥 Trois Rôles",
        roles_header:  "Expérience sur Mesure",
        roles_sub:     "Client, commerçant ou chercheur d'emploi — Buy For Me est fait pour vous.",
        role_customer:     "Interface Client",
        role_customer_long:"Parcourez les produits par catégorie, comparez les prix et suivez vos commandes en temps réel.",
        role_merchant:     "Dashboard Marchand",
        role_merchant_long:"Créez votre boutique numérique en minutes et recevez des commandes avec des alertes instantanées.",
        role_jobseeker:     "Recherche d'Emploi",
        role_jobseeker_long:"Explorez la carte pour trouver des offres dans les commerces proches et postulez directement.",

        test_badge:   "💬 Avis authentiques",
        test_header:  "Nos partenaires témoignent",
        user_1_text:  "\"J'avais du mal à me faire connaître localement. Grâce à Buy For Me, mes ventes ont doublé en un mois!\"",
        user_1_name:  "Yassine Benaissa",
        user_1_role:  "Propriétaire de boutique — Alger",
        user_2_text:  "\"Incroyablement facile à utiliser. Je commande mes courses depuis le travail et elles arrivent quand je rentre.\"",
        user_2_name:  "Leila Merabet",
        user_2_role:  "Cliente fidèle — Oran",

        stat_downloads_full:"Téléchargements actifs",
        stat_stores_full:   "Magasins certifiés",
        stat_jobs_full:     "Emplois disponibles",
        stat_rating_full:   "Note utilisateurs",

        footer_slogan:"Pour une meilleure économie numérique en Algérie",
        copyright:    "© 2026 Tous droits réservés — Buy For Me Algérie",
    }
};

// ─── LANGUAGE SWITCHER ────────────────────────────────────────────────────────

let currentLang = localStorage.getItem('preferredLang') || 'ar';

function setLanguage(lang) {
    currentLang = lang;
    localStorage.setItem('preferredLang', lang);

    const html = document.documentElement;
    html.setAttribute('lang', lang);
    html.setAttribute('dir', lang === 'ar' ? 'rtl' : 'ltr');

    // Update all translated elements
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        const val = translations[lang][key];
        if (val !== undefined) el.innerHTML = val;
    });

    // Update checkmarks in dropdown
    ['ar', 'en', 'fr'].forEach(l => {
        const chk = document.getElementById('check-' + l);
        if (chk) chk.style.opacity = l === lang ? '1' : '0';
    });
}

// Run on page load
setLanguage(currentLang);

// ─── THEME TOGGLE ─────────────────────────────────────────────────────────────

const themeToggle = document.getElementById('theme-toggle');
themeToggle.addEventListener('click', () => {
    document.body.classList.toggle('light-mode');
    document.body.classList.toggle('dark-mode');
    const icon = themeToggle.querySelector('i');
    icon.className = document.body.classList.contains('light-mode')
        ? 'fas fa-sun' : 'fas fa-moon';
    localStorage.setItem('theme', document.body.classList.contains('light-mode') ? 'light' : 'dark');
});

// Remember theme preference
if (localStorage.getItem('theme') === 'light') {
    document.body.classList.add('light-mode');
    document.body.classList.remove('dark-mode');
    themeToggle.querySelector('i').className = 'fas fa-sun';
}

// ─── SCROLL REVEAL OBSERVER ───────────────────────────────────────────────────

document.addEventListener('DOMContentLoaded', () => {
    const revealObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                revealObserver.unobserve(entry.target); // fire once
            }
        });
    }, { threshold: 0.12, rootMargin: '0px 0px -60px 0px' });

    document.querySelectorAll('.reveal, .reveal-left, .reveal-right').forEach(el => {
        revealObserver.observe(el);
    });

    // ─── NAVBAR SHRINK ON SCROLL ─────────────────────────────────────────────
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
        navbar.classList.toggle('scrolled', window.scrollY > 60);
    }, { passive: true });

    // ─── MOUSE GLOW ──────────────────────────────────────────────────────────
    const mouseGlow = document.getElementById('mouse-glow');
    window.addEventListener('mousemove', (e) => {
        if (mouseGlow) {
            mouseGlow.style.left = e.clientX + 'px';
            mouseGlow.style.top  = e.clientY + 'px';
        }
    }, { passive: true });

    // ─── 3D PARALLAX HERO IMAGE ───────────────────────────────────────────────
    const heroImg = document.getElementById('hero-img');
    if (heroImg && window.innerWidth > 768) {
        document.addEventListener('mousemove', (e) => {
            const xAxis = (window.innerWidth  / 2 - e.pageX) / 30;
            const yAxis = (window.innerHeight / 2 - e.pageY) / 30;
            heroImg.style.transform = `rotateY(${xAxis}deg) rotateX(${yAxis}deg) translateZ(10px)`;
        }, { passive: true });
        // Reset when mouse leaves window
        document.addEventListener('mouseleave', () => {
            heroImg.style.transform = '';
        });
    }

    // ─── INTERACTIVE CARD TILT ────────────────────────────────────────────────
    document.querySelectorAll('.role-card, .feature-card').forEach(card => {
        card.addEventListener('mousemove', (e) => {
            const rect    = card.getBoundingClientRect();
            const x       = e.clientX - rect.left;
            const y       = e.clientY - rect.top;
            const centerX = rect.width  / 2;
            const centerY = rect.height / 2;
            const rotY    = ((x - centerX)  / centerX) * 10;
            const rotX    = ((centerY - y)  / centerY) * 8;
            card.style.transform = `translateY(-12px) rotateX(${rotX}deg) rotateY(${rotY}deg)`;
            card.style.boxShadow = `
                ${-rotY * 2}px ${rotX * 2}px 40px rgba(0,0,0,0.35),
                0 0 30px rgba(0,255,136,0.1)
            `;
        });
        card.addEventListener('mouseleave', () => {
            card.style.transform  = '';
            card.style.boxShadow  = '';
        });
    });

    // ─── GALLERY CARD SUBTLE TILT ─────────────────────────────────────────────
    document.querySelectorAll('.gallery-card').forEach(card => {
        card.addEventListener('mousemove', (e) => {
            const rect = card.getBoundingClientRect();
            const rotY = ((e.clientX - rect.left)  / rect.width  - 0.5) * 6;
            const rotX = ((e.clientY - rect.top)   / rect.height - 0.5) * -6;
            card.style.transform = `perspective(800px) rotateX(${rotX}deg) rotateY(${rotY}deg) scale(1.01)`;
        });
        card.addEventListener('mouseleave', () => {
            card.style.transform = '';
        });
    });

    // ─── COUNTER ANIMATION ───────────────────────────────────────────────────
    const counters = document.querySelectorAll('.stat-item .number');
    const counterObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateCounter(entry.target);
                counterObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.5 });

    counters.forEach(el => counterObserver.observe(el));
});

function animateCounter(el) {
    const text = el.textContent;
    // Extract the numeric part
    const numMatch = text.match(/[\d.]+/);
    if (!numMatch) return;
    const target = parseFloat(numMatch[0]);
    const suffix = text.replace(numMatch[0], '');
    const duration = 1800;
    const startTime = performance.now();

    function update(current) {
        const elapsed  = current - startTime;
        const progress = Math.min(elapsed / duration, 1);
        // Ease out cubic
        const eased = 1 - Math.pow(1 - progress, 3);
        const value  = eased * target;
        el.textContent = (Number.isInteger(target) ? Math.floor(value) : value.toFixed(2)) + suffix;
        if (progress < 1) requestAnimationFrame(update);
    }
    requestAnimationFrame(update);
}

// ─── PARTICLE CANVAS BACKGROUND ──────────────────────────────────────────────

const canvas = document.getElementById('bg-canvas');
const ctx    = canvas.getContext('2d');
const COLORS = [
    'rgba(0, 255, 136, 0.18)',
    'rgba(0, 212, 255, 0.15)',
    'rgba(160, 100, 255, 0.12)',
];

function resizeCanvas() {
    canvas.width  = window.innerWidth;
    canvas.height = window.innerHeight;
}
window.addEventListener('resize', resizeCanvas, { passive: true });
resizeCanvas();

class Particle {
    constructor() { this.reset(true); }

    reset(init = false) {
        this.x    = Math.random() * canvas.width;
        this.y    = init ? Math.random() * canvas.height : canvas.height + 10;
        this.size = Math.random() * 2.2 + 0.4;
        this.vx   = (Math.random() - 0.5) * 0.5;
        this.vy   = -(Math.random() * 0.4 + 0.15);
        this.alpha = Math.random() * 0.6 + 0.2;
        this.color = COLORS[Math.floor(Math.random() * COLORS.length)];
        this.twinkle = Math.random() * Math.PI * 2; // phase offset
    }

    update() {
        this.x      += this.vx;
        this.y      += this.vy;
        this.twinkle += 0.03;
        this.alpha   = 0.3 + Math.sin(this.twinkle) * 0.2;
        if (this.y < -10) this.reset();
        if (this.x < 0 || this.x > canvas.width) this.vx *= -1;
    }

    draw() {
        ctx.globalAlpha = this.alpha;
        ctx.fillStyle   = this.color;
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
        ctx.globalAlpha = 1;
    }
}

const PARTICLE_COUNT = 80;
const particles = Array.from({ length: PARTICLE_COUNT }, () => new Particle());

// Draw subtle connection lines between close particles
function drawConnections() {
    const MAX_DIST = 120;
    for (let i = 0; i < particles.length; i++) {
        for (let j = i + 1; j < particles.length; j++) {
            const dx   = particles[i].x - particles[j].x;
            const dy   = particles[i].y - particles[j].y;
            const dist = Math.sqrt(dx * dx + dy * dy);
            if (dist < MAX_DIST) {
                ctx.beginPath();
                ctx.strokeStyle = `rgba(0, 255, 136, ${(1 - dist / MAX_DIST) * 0.06})`;
                ctx.lineWidth   = 0.5;
                ctx.moveTo(particles[i].x, particles[i].y);
                ctx.lineTo(particles[j].x, particles[j].y);
                ctx.stroke();
            }
        }
    }
}

function animateParticles() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    drawConnections();
    particles.forEach(p => { p.update(); p.draw(); });
    requestAnimationFrame(animateParticles);
}
animateParticles();

// ─── SUPABASE STATS FETCH ─────────────────────────────────────────────────────

const SUPABASE_URL = 'https://hrraflleindvjvaqofnz.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhycmphbmxlaW5kdmp2YXFvZm56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDAwMDAwMDAsImV4cCI6MjAxNTU2MDAwMH0.placeholder';

async function fetchLiveStats() {
    if (typeof window.supabase === 'undefined') return;
    // Basic check to avoid calling with placeholder key
    if (SUPABASE_KEY.endsWith('placeholder')) return;

    try {
        const sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

        const [{ count: storesCount }, { count: jobsCount }] = await Promise.all([
            sb.from('stores').select('*', { count: 'exact', head: true }),
            sb.from('job_requests').select('*', { count: 'exact', head: true }),
        ]);

        if (storesCount) {
            const el = document.getElementById('stores-count');
            if (el) el.textContent = storesCount + '+';
        }
        if (jobsCount) {
            const el = document.getElementById('jobs-count');
            if (el) el.textContent = jobsCount + '+';
        }
    } catch (err) {
        console.warn('[Buy For Me] Supabase fetch failed — using static values.', err.message);
    }
}

// Fetch after a short delay so the page renders first
setTimeout(fetchLiveStats, 1500);

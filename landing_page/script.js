// Initialize AOS with a fallback
document.addEventListener('DOMContentLoaded', () => {
    if (typeof AOS !== 'undefined') {
        AOS.init({
            duration: 800,
            once: true,
            offset: 50,
            disable: 'mobile' // Disable on small screens for better performance
        });
    }

    // Fallback: If elements are still hidden after 2 seconds, force them visible
    setTimeout(() => {
        const aosElements = document.querySelectorAll('[data-aos]');
        aosElements.forEach(el => {
            el.style.opacity = '1';
            el.style.transform = 'none';
        });
    }, 2000);
});

// Language Translations
const translations = {
    ar: {
        nav_features: "المميزات",
        nav_how: "كيف يعمل",
        nav_roles: "الأدوار",
        nav_download: "حمل الآن",
        hero_title: 'تسوق بذكاء، <span class="highlight">بكل بساطة</span>',
        hero_desc: 'تطبيق "اشترِ لي" هو بوابتك للوصول لأفضل المتاجر في جزائنا الحبيبة، سواء كنت مشترياً، تاجراً، أو باحثاً عن عمل.',
        btn_download: "تحميل APK للأندرويد (مجاناً)",
        showcase_title: "شاهد التطبيق من الداخل",
        feat_1_title: "خريطة تفاعلية",
        feat_2_title: "لوحة تحكم التاجر",
        feat_header: "مميزات التطبيق",
        feat_1_title_card: "مواقع دقيقة",
        feat_1_desc: "ابحث عن المتاجر القريبة منك على الخريطة بدقة عالية وسهولة تامة.",
        feat_2_title_card: "إدارة المتاجر",
        feat_2_desc: "كتاجر، يمكنك إضافة منتجاتك، وتحديد أسعارك، واستقبال الطلبات فوراً.",
        feat_3_title: "فرص عمل",
        feat_3_desc: "ميزة فريدة تمكنك من البحث عن عمل في المتاجر المجاورة وإرسال طلبك فوراً.",
        feat_4_title: "أمان ومصداقية",
        feat_4_desc: "نظام تقييم ومراجعة يضمن لك أفضل جودة وأمان للمشتري والتاجر.",
        roles_header: "نظام متكامل لجميع الفئات",
        role_customer: "أنا زبون",
        role_customer_desc: "تصفح المنتجات، قارن الأسعار، واطلب ما تحتاجه ليصلك لباب منزلك.",
        role_merchant: "أنا تاجر",
        role_merchant_desc: "حول متجرك التقليدي لمتجر رقمي في دقائق، واكتسب زبائن جدد يومياً.",
        role_jobseeker: "أنا أبحث عن عمل",
        role_jobseeker_desc: "ارسم مستقبلك المهني من خلال الخريطة التفاعلية لإرسال سيرتك الذاتية.",
        stat_downloads: "تحميل",
        stat_stores: "متجر مسجل",
        stat_jobs: "فرصة عمل",
        stat_rating: "تقييم",
        test_header: "ماذا يقول مستخدمونا؟",
        user_1_name: "أحمد بن محمد",
        user_1_role: "تاجر تجزئة",
        user_1_text: '"تطبيق ممتاز ساعدني في الوصول لزبائن في مناطق لم أكن أتوقعها. سهولة إدارة المنتجات هي الأفضل."',
        user_2_name: "سارة علي",
        user_2_role: "زبونة دائمة",
        user_2_text: '"أحب ميزة الخريطة كثيراً، أستطيع أن أرى المتاجر المفتوحة حولي وأطلب بسرعة. التطبيق واجهته فخمة جداً."',
        footer_cta_title: "جاهز للبدء؟",
        footer_cta_desc: "انضم إلى آلاف المستخدمين وابدأ تجربة تسوق جديدة كلياً.",
        footer_btn: "حمل التطبيق مباشرة",
        copyright: "© 2026 جميع الحقوق محفوظة - Buy For Me الجزائر"
    },
    en: {
        nav_features: "Features",
        nav_how: "How it works",
        nav_roles: "Roles",
        nav_download: "Download Now",
        hero_title: 'Shop Smart, <span class="highlight">Simply</span>',
        hero_desc: '"Buy For Me" is your gateway to the best stores in Algeria, whether you are a buyer, a merchant, or a job seeker.',
        btn_download: "Download APK (Free)",
        showcase_title: "App Preview",
        feat_1_title: "Interactive Map",
        feat_2_title: "Merchant Dashboard",
        feat_header: "App Features",
        feat_1_title_card: "Precise Locations",
        feat_1_desc: "Find near stores on the map with high precision and absolute ease.",
        feat_2_title_card: "Store Management",
        feat_2_desc: "As a merchant, add products, set prices, and receive orders instantly.",
        feat_3_title: "Job Opportunities",
        feat_3_desc: "Unique feature allows searching for work in nearby stores and applying instantly.",
        feat_4_title: "Safety & Reliability",
        feat_4_desc: "Review system ensures best quality and safety for both buyer and merchant.",
        roles_header: "Integrated System for All",
        role_customer: "I am a Customer",
        role_customer_desc: "Browse products, compare prices, and order what you need to your door.",
        role_merchant: "I am a Merchant",
        role_merchant_desc: "Turn your traditional store into a digital one in minutes, gain new customers.",
        role_jobseeker: "I am a Job Seeker",
        role_jobseeker_desc: "Draw your career future through the interactive map to send your CV.",
        stat_downloads: "Downloads",
        stat_stores: "Stores Registered",
        stat_jobs: "Job Opportunities",
        stat_rating: "Rating",
        test_header: "What our users say?",
        user_1_name: "Ahmed Bin Mohamed",
        user_1_role: "Retail Merchant",
        user_1_text: '"Excellent app helped me reach customers in unexpected areas."',
        user_2_name: "Sarah Ali",
        user_2_role: "Regular Customer",
        user_2_text: '"I love the map feature a lot, premium UI."',
        footer_cta_title: "Ready to start?",
        footer_cta_desc: "Join thousands of users and start a new experience.",
        footer_btn: "Download App Directly",
        copyright: "© 2026 All Rights Reserved - Buy For Me Algeria"
    },
    fr: {
        nav_features: "Caractéristiques",
        nav_how: "Comment ça marche",
        nav_roles: "Rôles",
        nav_download: "Télécharger",
        hero_title: 'Achetez Intelligemment, <span class="highlight">Simplement</span>',
        hero_desc: '"Buy For Me" est votre porte d\'entrée vers les meilleurs magasins en Algérie.',
        btn_download: "Télécharger APK (Gratuit)",
        showcase_title: "Aperçu de l'application",
        feat_1_title: "Carte Interactive",
        feat_2_title: "Tableau de Bord Marchand",
        feat_header: "Fonctionnalités",
        feat_1_title_card: "Emplacements Précis",
        feat_1_desc: "Trouvez des magasins avec une grande précision.",
        feat_2_title_card: "Gestion de Magasin",
        feat_2_desc: "En tant que marchand, ajoutez des produits et recevez des commandes.",
        feat_3_title: "Opportunités",
        feat_3_desc: "Cherchez du travail dans les magasins voisins.",
        feat_4_title: "Sécurité",
        feat_4_desc: "Système d'évaluation garantissant la qualité.",
        roles_header: "Système Intégré",
        role_customer: "Je suis un Client",
        role_customer_desc: "Parcourez les produits et commandez ce dont vous avez besoin.",
        role_merchant: "Je suis un Marchand",
        role_merchant_desc: "Transformez votre magasin en boutique numérique.",
        role_jobseeker: "Je cherche du travail",
        role_jobseeker_desc: "Envoyez votre CV via la carte.",
        stat_downloads: "Téléchargements",
        stat_stores: "Magasins",
        stat_jobs: "Opportunités",
        stat_rating: "Évaluation",
        test_header: "Avis",
        user_1_name: "Ahmed",
        user_1_role: "Marchand",
        user_1_text: '"Excellente application."',
        user_2_name: "Sarah",
        user_2_role: "Cliente",
        user_2_text: '"J\'aime beaucoup l\'interface."',
        footer_cta_title: "Prêt ?",
        footer_cta_desc: "Rejoignez-nous aujourd'hui.",
        footer_btn: "Télécharger",
        copyright: "© 2026 Tous droits réservés"
    },
    es: {
        nav_features: "Características",
        nav_how: "Cómo funciona",
        nav_roles: "Roles",
        nav_download: "Descargar",
        hero_title: 'Compre Inteligente, <span class="highlight">Simplemente</span>',
        hero_desc: '"Buy For Me" es su puerta de entrada a las mejores tiendas.',
        btn_download: "Descargar APK (Gratis)",
        showcase_title: "Previsualización",
        feat_1_title: "Mapa Interactivo",
        feat_2_title: "Panel de Comerciante",
        feat_header: "Características",
        feat_1_title_card: "Lugares Precisos",
        feat_1_desc: "Encuentre tiendas cercanas con facilidad.",
        feat_2_title_card: "Gestión",
        feat_2_desc: "Como comerciante, venda sus productos en línea.",
        feat_3_title: "Empleo",
        feat_3_desc: "Busque trabajo en tiendas cercanas.",
        feat_4_title: "Seguridad",
        feat_4_desc: "Sistema de confianza para todos.",
        roles_header: "Sistema Integrado",
        role_customer: "Soy Cliente",
        role_customer_desc: "Explore y pida productos fácilmente.",
        role_merchant: "Soy Comerciante",
        role_merchant_desc: "Venda digitalmente en minutos.",
        role_jobseeker: "Busco Trabajo",
        role_jobseeker_desc: "Envíe su CV por el mapa.",
        stat_downloads: "Descargas",
        stat_stores: "Tiendas",
        stat_jobs: "Empleos",
        stat_rating: "Opinión",
        test_header: "Opiniones",
        user_1_name: "Ahmed",
        user_1_role: "Comerciante",
        user_1_text: '"Excelente app."',
        user_2_name: "Sarah",
        user_2_role: "Cliente",
        user_2_text: '"Mucha calidad en la interfaz."',
        footer_cta_title: "¿Listo?",
        footer_cta_desc: "Únete ahora.",
        footer_btn: "Descargar",
        copyright: "© 2026 Reservados todos los derechos"
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

    // Re-init AOS for RTL/LTR changes
    if (typeof AOS !== 'undefined') {
        AOS.refresh();
    }
}

// Initial Language Load
const savedLang = localStorage.getItem('preferredLang') || 'ar';
setLanguage(savedLang);

// Particle Background Animation
const canvas = document.getElementById('bg-canvas');
const ctx = canvas.getContext('2d');

let particles = [];
const particleCount = 60;

function resize() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
}

window.addEventListener('resize', resize);
resize();

class Particle {
    constructor() {
        this.init();
    }

    init() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.size = Math.random() * 2 + 1;
        this.speedX = Math.random() * 0.5 - 0.25;
        this.speedY = Math.random() * 0.5 - 0.25;
        this.opacity = Math.random() * 0.5 + 0.2;
    }

    update() {
        this.x += this.speedX;
        this.y += this.speedY;

        if (this.x < 0 || this.x > canvas.width) this.speedX *= -1;
        if (this.y < 0 || this.y > canvas.height) this.speedY *= -1;
    }

    draw() {
        ctx.fillStyle = `rgba(76, 175, 80, ${this.opacity})`;
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
    }
}

for (let i = 0; i < particleCount; i++) {
    particles.push(new Particle());
}

function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // Draw connections
    ctx.strokeStyle = 'rgba(76, 175, 80, 0.05)';
    ctx.lineWidth = 1;
    for (let i = 0; i < particles.length; i++) {
        for (let j = i + 1; j < particles.length; j++) {
            const dx = particles[i].x - particles[j].x;
            const dy = particles[i].y - particles[j].y;
            const dist = Math.sqrt(dx * dx + dy * dy);
            if (dist < 150) {
                ctx.beginPath();
                ctx.moveTo(particles[i].x, particles[i].y);
                ctx.lineTo(particles[j].x, particles[j].y);
                ctx.stroke();
            }
        }
    }

    particles.forEach(p => {
        p.update();
        p.draw();
    });
    requestAnimationFrame(animate);
}

animate();

// Supabase Configuration
const supabaseUrl = 'https://hrraflleindvjvaqofnz.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhycmFmbGxlaW5kdmp2YXFvZm56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzMDUzOTAsImV4cCI6MjA5MDg4MTM5MH0.zH4xWI_Ey2iZnEVLSzFgExUCeKYXJlgRlpo0aGd6wFw';

let supabase;
if (typeof window.supabase !== 'undefined') {
    supabase = window.supabase.createClient(supabaseUrl, supabaseKey);
}

async function fetchStats() {
    if (!supabase) return;
    try {
        const { count: storesCount } = await supabase.from('stores').select('*', { count: 'exact', head: true });
        const { count: jobsCount } = await supabase.from('job_requests').select('*', { count: 'exact', head: true });
        
        if (storesCount !== null) document.getElementById('stores-count').textContent = `+${storesCount}`;
        if (jobsCount !== null) document.getElementById('jobs-count').textContent = `+${jobsCount}`;
    } catch (e) {
        console.warn('Stats fetch skipped (CORS or Network):', e);
    }
}

fetchStats();

// Theme Toggle
const themeToggle = document.getElementById('theme-toggle');
const body = document.body;
const icon = themeToggle.querySelector('i');

themeToggle.addEventListener('click', () => {
    body.classList.toggle('light-mode');
    body.classList.toggle('dark-mode');
    if (body.classList.contains('light-mode')) {
        icon.classList.replace('fa-moon', 'fa-sun');
    } else {
        icon.classList.replace('fa-sun', 'fa-moon');
    }
});

// Smooth scroll
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            e.preventDefault();
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

// Navbar scroll background
window.addEventListener('scroll', function() {
    const nav = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        nav.style.background = body.classList.contains('light-mode') ? 'rgba(245, 250, 247, 0.95)' : 'rgba(10, 15, 13, 0.95)';
        nav.style.borderBottom = '1px solid rgba(255, 255, 255, 0.1)';
    } else {
        nav.style.background = 'rgba(10, 15, 13, 0.8)';
        nav.style.borderBottom = 'none';
    }
});

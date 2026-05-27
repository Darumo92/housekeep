// ui.jsx — primitives, icons, strings, themes for HouseKeep prototype

// ─────────────────────────────────────────────────────────────
// THEMES — three visual directions
// ─────────────────────────────────────────────────────────────
const THEMES = {
  cozy: {
    name: 'Cozy',
    bg: '#f6f1e9',
    surface: '#ffffff',
    surfaceAlt: '#fbf6ee',
    border: 'rgba(46,125,111,0.10)',
    text: '#1f2624',
    textMuted: '#6b7270',
    textFaint: '#a4a8a4',
    primary: '#2e7d6f',
    primarySoft: '#dbeae5',
    onPrimary: '#ffffff',
    accent: '#e0913a',
    accentSoft: '#fbe9d2',
    ok: '#3f9c5c',
    warn: '#d4a017',
    danger: '#c8513c',
    okSoft: '#dcefd6',
    warnSoft: '#fcefc8',
    dangerSoft: '#f6dad0',
    radiusCard: 20,
    radiusBtn: 14,
    radiusChip: 999,
    fontDisplay: "'Inter', system-ui, sans-serif",
    fontBody: "'Inter', system-ui, sans-serif",
    fontMono: "'JetBrains Mono', monospace",
    displayWeight: 600,
    bodyWeight: 400,
    cardShadow: '0 1px 0 rgba(0,0,0,0.02), 0 2px 8px rgba(46,125,111,0.06)',
    placeholderStripe: 'rgba(46,125,111,0.06)',
  },
  editorial: {
    name: 'Editorial',
    bg: '#f4f1ec',
    surface: '#ffffff',
    surfaceAlt: '#ebe6dd',
    border: 'rgba(0,0,0,0.08)',
    text: '#15140f',
    textMuted: '#65615a',
    textFaint: '#a09a90',
    primary: '#15140f',
    primarySoft: '#e4dfd6',
    onPrimary: '#fdfbf6',
    accent: '#c34b2a',
    accentSoft: '#f3d8ce',
    ok: '#3f6b3a',
    warn: '#b88216',
    danger: '#a23217',
    okSoft: '#e1ead8',
    warnSoft: '#f3e2c0',
    dangerSoft: '#ecd2c5',
    radiusCard: 6,
    radiusBtn: 6,
    radiusChip: 4,
    fontDisplay: "'Instrument Serif', Georgia, serif",
    fontBody: "'Inter', system-ui, sans-serif",
    fontMono: "'JetBrains Mono', monospace",
    displayWeight: 400,
    bodyWeight: 400,
    cardShadow: 'none',
    placeholderStripe: 'rgba(0,0,0,0.05)',
  },
  vibrant: {
    name: 'Vibrant',
    bg: '#eef2e6',
    surface: '#ffffff',
    surfaceAlt: '#dfe9d0',
    border: 'rgba(0,0,0,0.06)',
    text: '#0f1a14',
    textMuted: '#5b6b5e',
    textFaint: '#9aa498',
    primary: '#1e6b3a',
    primarySoft: '#cce5ce',
    onPrimary: '#ffffff',
    accent: '#e85a3c',
    accentSoft: '#fbd8ce',
    ok: '#1e6b3a',
    warn: '#e8a13c',
    danger: '#e85a3c',
    okSoft: '#cce5ce',
    warnSoft: '#fbecc7',
    dangerSoft: '#fbd8ce',
    radiusCard: 28,
    radiusBtn: 999,
    radiusChip: 999,
    fontDisplay: "'Space Grotesk', system-ui, sans-serif",
    fontBody: "'Space Grotesk', system-ui, sans-serif",
    fontMono: "'JetBrains Mono', monospace",
    displayWeight: 700,
    bodyWeight: 500,
    cardShadow: '0 8px 24px rgba(30,107,58,0.10)',
    placeholderStripe: 'rgba(30,107,58,0.08)',
  },
};

const DARK_OVERLAY = {
  bg: '#13110d',
  surface: '#1e1c17',
  surfaceAlt: '#26231d',
  border: 'rgba(255,255,255,0.08)',
  text: '#f3efe8',
  textMuted: '#a39e94',
  textFaint: '#6d6960',
  cardShadow: 'none',
  placeholderStripe: 'rgba(255,255,255,0.04)',
};

function getTheme(dir, dark) {
  const base = THEMES[dir] || THEMES.cozy;
  if (!dark) return base;
  return { ...base, ...DARK_OVERLAY,
    primarySoft: 'rgba(46,125,111,0.18)',
    accentSoft: 'rgba(224,145,58,0.18)',
    okSoft: 'rgba(63,156,92,0.18)',
    warnSoft: 'rgba(212,160,23,0.20)',
    dangerSoft: 'rgba(200,81,60,0.20)',
  };
}

// ─────────────────────────────────────────────────────────────
// STRINGS — ES + EN
// ─────────────────────────────────────────────────────────────
const STRINGS = {
  es: {
    appName: 'HouseKeep',
    tagline: 'Tu casa cuidada, sin recordar nada.',
    tab_home: 'Inicio', tab_items: 'Cosas', tab_docs: 'Documentos', tab_settings: 'Ajustes',
    home_title: 'Buenas tardes',
    home_sub: 'Esto es lo que pide atención',
    home_summary_due: 'Pendientes', home_summary_soon: 'Esta semana', home_summary_ok: 'Al día',
    home_upcoming: 'Próximos eventos',
    home_empty_title: 'Empieza por lo más importante',
    home_empty_sub: 'Añade tu primer electrodoméstico o documento y HouseKeep te avisará antes de que sea tarde.',
    home_empty_cta: 'Añadir mi primera cosa',
    items_title: 'Mis cosas',
    items_count: (n) => `${n} elementos`,
    items_empty: 'Aún no hay nada por aquí',
    items_empty_sub: 'Tu caldera, la lavadora, el coche… cualquier cosa con un mantenimiento o garantía.',
    items_add: 'Añadir cosa',
    items_filter_all: 'Todo',
    items_filter_kitchen: 'Cocina', items_filter_bath: 'Baño', items_filter_laundry: 'Lavandería',
    items_filter_garden: 'Jardín', items_filter_garage: 'Garaje', items_filter_living: 'Salón',
    docs_title: 'Documentos',
    docs_empty: 'Sin documentos guardados',
    docs_empty_sub: 'DNI, ITV, seguros… te avisamos un mes antes.',
    docs_add: 'Añadir documento',
    docs_section_expired: 'Caducados',
    docs_section_soon: 'Caducan pronto',
    docs_section_ok: 'En vigor',
    detail_warranty: 'Garantía',
    detail_purchased: 'Comprado el',
    detail_until: 'hasta el',
    detail_maint_title: 'Mantenimientos',
    detail_maint_next: 'Próximo',
    detail_maint_history: 'Historial',
    detail_done: 'Hecho',
    detail_mark_done: 'Marcar como hecho',
    detail_edit: 'Editar',
    detail_delete: 'Borrar',
    add_item_title: 'Nuevo elemento',
    add_field_name: 'Nombre',
    add_field_brand: 'Marca y modelo',
    add_field_category: 'Categoría',
    add_field_purchased: 'Fecha de compra',
    add_field_warranty: 'Garantía (meses)',
    add_field_notes: 'Notas',
    add_save: 'Guardar',
    add_cancel: 'Cancelar',
    add_photo: 'Añadir foto',
    maint_title: 'Marcar como hecho',
    maint_when: '¿Cuándo lo hiciste?',
    maint_today: 'Hoy',
    maint_yesterday: 'Ayer',
    maint_other: 'Otra fecha',
    maint_notes_opt: 'Notas (opcional)',
    maint_confirm: 'Confirmar',
    maint_next: 'Próximo aviso',
    paywall_title: 'Pasa a HouseKeep Pro',
    paywall_sub: 'Un pago único. Para siempre.',
    paywall_b1: 'Cosas y documentos ilimitados',
    paywall_b2: 'Múltiples avisos por elemento',
    paywall_b3: 'Widget de pantalla de inicio',
    paywall_b4: 'Exporta a PDF y comparte con tu pareja',
    paywall_b5: 'Plantillas Pro: piscina, jardín, placas solares',
    paywall_price: '€5,99',
    paywall_once: 'pago único',
    paywall_cta: 'Desbloquear Pro',
    paywall_restore: 'Restaurar compra',
    paywall_skip: 'Ahora no',
    paywall_gate: 'Has llegado al límite gratuito',
    paywall_gate_sub: 'El plan gratuito incluye 5 cosas y 3 documentos. Pasa a Pro para no tener límites.',
    onb_1_t: 'Tu casa tiene memoria.',
    onb_1_s: 'Cuándo cambiar el filtro, cuándo caduca el seguro, cuándo toca revisión. Demasiado para recordar.',
    onb_2_t: 'HouseKeep recuerda por ti.',
    onb_2_s: 'Avisos a tiempo, plantillas listas y un historial de todo lo que has hecho.',
    onb_3_t: 'Empieza con una sola cosa.',
    onb_3_s: 'La caldera, la lavadora, el seguro del coche. Lo que más te preocupe.',
    onb_next: 'Siguiente',
    onb_skip: 'Saltar',
    onb_start: 'Empezar',
    settings_title: 'Ajustes',
    settings_account: 'Cuenta',
    settings_plan_free: 'Plan gratuito',
    settings_plan_pro: 'HouseKeep Pro',
    settings_upgrade: 'Pasar a Pro',
    settings_pro_badge: 'Activo',
    settings_notifs: 'Avisos',
    settings_notifs_on: 'Notificaciones',
    settings_notifs_lead: 'Días de antelación',
    settings_pref: 'Preferencias',
    settings_lang: 'Idioma',
    settings_theme: 'Tema',
    settings_about: 'Sobre la app',
    settings_privacy: 'Política de privacidad',
    settings_contact: 'Contacto',
    days_short: (n) => n === 1 ? 'mañana' : `en ${n} d.`,
    days_overdue: (n) => n === 1 ? 'ayer' : `hace ${n} d.`,
    today: 'hoy',
    status_overdue: 'Vencido', status_due: 'Toca ya', status_soon: 'Pronto', status_ok: 'Al día',
    upgrade_inline: 'Pásate a Pro',
    free_chip: 'Gratis',
    sample_greeting_name: 'Marta',
  },
  en: {
    appName: 'HouseKeep',
    tagline: 'Your house, looked after.',
    tab_home: 'Home', tab_items: 'Things', tab_docs: 'Documents', tab_settings: 'Settings',
    home_title: 'Good afternoon',
    home_sub: 'Here\u2019s what needs attention',
    home_summary_due: 'Due', home_summary_soon: 'This week', home_summary_ok: 'On track',
    home_upcoming: 'Coming up',
    home_empty_title: 'Start with what matters most',
    home_empty_sub: 'Add your first appliance or document and HouseKeep will nudge you before it\u2019s late.',
    home_empty_cta: 'Add my first thing',
    items_title: 'My things',
    items_count: (n) => `${n} items`,
    items_empty: 'Nothing here yet',
    items_empty_sub: 'Your boiler, washer, car\u2026 anything with maintenance or a warranty.',
    items_add: 'Add a thing',
    items_filter_all: 'All',
    items_filter_kitchen: 'Kitchen', items_filter_bath: 'Bath', items_filter_laundry: 'Laundry',
    items_filter_garden: 'Garden', items_filter_garage: 'Garage', items_filter_living: 'Living',
    docs_title: 'Documents',
    docs_empty: 'No documents saved',
    docs_empty_sub: 'ID, insurance, MOT\u2026 we ping you a month before.',
    docs_add: 'Add a document',
    docs_section_expired: 'Expired',
    docs_section_soon: 'Expires soon',
    docs_section_ok: 'In force',
    detail_warranty: 'Warranty',
    detail_purchased: 'Bought on',
    detail_until: 'until',
    detail_maint_title: 'Maintenance',
    detail_maint_next: 'Next',
    detail_maint_history: 'History',
    detail_done: 'Done',
    detail_mark_done: 'Mark as done',
    detail_edit: 'Edit',
    detail_delete: 'Delete',
    add_item_title: 'New item',
    add_field_name: 'Name',
    add_field_brand: 'Brand & model',
    add_field_category: 'Category',
    add_field_purchased: 'Purchase date',
    add_field_warranty: 'Warranty (months)',
    add_field_notes: 'Notes',
    add_save: 'Save',
    add_cancel: 'Cancel',
    add_photo: 'Add photo',
    maint_title: 'Mark as done',
    maint_when: 'When did you do it?',
    maint_today: 'Today',
    maint_yesterday: 'Yesterday',
    maint_other: 'Another date',
    maint_notes_opt: 'Notes (optional)',
    maint_confirm: 'Confirm',
    maint_next: 'Next reminder',
    paywall_title: 'Go HouseKeep Pro',
    paywall_sub: 'One payment. Yours forever.',
    paywall_b1: 'Unlimited things and documents',
    paywall_b2: 'Multiple reminders per item',
    paywall_b3: 'Home screen widget',
    paywall_b4: 'Export to PDF and share with your partner',
    paywall_b5: 'Pro templates: pool, garden, solar panels',
    paywall_price: '\u20ac5.99',
    paywall_once: 'one-time',
    paywall_cta: 'Unlock Pro',
    paywall_restore: 'Restore purchase',
    paywall_skip: 'Not now',
    paywall_gate: 'You\u2019ve hit the free limit',
    paywall_gate_sub: 'The free plan covers 5 things and 3 documents. Go Pro to drop the cap.',
    onb_1_t: 'Your house has memory.',
    onb_1_s: 'When to swap the filter, when the insurance expires, when the boiler is due. Too much to keep in your head.',
    onb_2_t: 'HouseKeep remembers for you.',
    onb_2_s: 'Timely nudges, ready-made templates, and a record of everything you\u2019ve done.',
    onb_3_t: 'Start with one thing.',
    onb_3_s: 'The boiler, the washer, your car insurance. Whatever\u2019s on your mind.',
    onb_next: 'Next',
    onb_skip: 'Skip',
    onb_start: 'Get started',
    settings_title: 'Settings',
    settings_account: 'Account',
    settings_plan_free: 'Free plan',
    settings_plan_pro: 'HouseKeep Pro',
    settings_upgrade: 'Upgrade to Pro',
    settings_pro_badge: 'Active',
    settings_notifs: 'Reminders',
    settings_notifs_on: 'Notifications',
    settings_notifs_lead: 'Days ahead',
    settings_pref: 'Preferences',
    settings_lang: 'Language',
    settings_theme: 'Theme',
    settings_about: 'About',
    settings_privacy: 'Privacy policy',
    settings_contact: 'Contact us',
    days_short: (n) => n === 1 ? 'tomorrow' : `in ${n}d`,
    days_overdue: (n) => n === 1 ? 'yesterday' : `${n}d ago`,
    today: 'today',
    status_overdue: 'Overdue', status_due: 'Due now', status_soon: 'Soon', status_ok: 'On track',
    upgrade_inline: 'Upgrade to Pro',
    free_chip: 'Free',
    sample_greeting_name: 'Sam',
  },
};

// ─────────────────────────────────────────────────────────────
// ICONS — inline SVG. 24px viewBox, stroke-based.
// ─────────────────────────────────────────────────────────────
function Icon({ name, size = 22, stroke = 'currentColor', fill = 'none', sw = 1.75 }) {
  const props = { width: size, height: size, viewBox: '0 0 24 24', fill, stroke, strokeWidth: sw, strokeLinecap: 'round', strokeLinejoin: 'round' };
  switch (name) {
    case 'home': return <svg {...props}><path d="M3 11l9-7 9 7"/><path d="M5 10v9a1 1 0 0 0 1 1h4v-6h4v6h4a1 1 0 0 0 1-1v-9"/></svg>;
    case 'box': return <svg {...props}><path d="M3 7l9-4 9 4-9 4-9-4z"/><path d="M3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></svg>;
    case 'file': return <svg {...props}><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5"/><path d="M9 13h6M9 17h4"/></svg>;
    case 'gear': return <svg {...props}><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1A1.7 1.7 0 0 0 4.6 15a1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9c.2.6.7 1 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z"/></svg>;
    case 'plus': return <svg {...props}><path d="M12 5v14M5 12h14"/></svg>;
    case 'chevron-right': return <svg {...props}><path d="M9 6l6 6-6 6"/></svg>;
    case 'chevron-left': return <svg {...props}><path d="M15 6l-6 6 6 6"/></svg>;
    case 'check': return <svg {...props}><path d="M20 6L9 17l-5-5"/></svg>;
    case 'check-circle': return <svg {...props}><circle cx="12" cy="12" r="9"/><path d="M8 12l3 3 5-6"/></svg>;
    case 'bell': return <svg {...props}><path d="M6 8a6 6 0 1 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10 21a2 2 0 0 0 4 0"/></svg>;
    case 'calendar': return <svg {...props}><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M16 3v4M8 3v4M3 11h18"/></svg>;
    case 'camera': return <svg {...props}><path d="M4 8h3l2-2h6l2 2h3a1 1 0 0 1 1 1v10a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1z"/><circle cx="12" cy="13" r="3.5"/></svg>;
    case 'sparkle': return <svg {...props}><path d="M12 3l1.7 4.3L18 9l-4.3 1.7L12 15l-1.7-4.3L6 9l4.3-1.7L12 3z"/><path d="M19 14l.8 2L22 17l-2.2 1L19 20l-.8-2L16 17l2.2-1z"/></svg>;
    case 'arrow-right': return <svg {...props}><path d="M5 12h14M13 5l7 7-7 7"/></svg>;
    case 'arrow-left': return <svg {...props}><path d="M19 12H5M11 5l-7 7 7 7"/></svg>;
    case 'search': return <svg {...props}><circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/></svg>;
    case 'more': return <svg {...props}><circle cx="5" cy="12" r="1.5" fill={stroke} stroke="none"/><circle cx="12" cy="12" r="1.5" fill={stroke} stroke="none"/><circle cx="19" cy="12" r="1.5" fill={stroke} stroke="none"/></svg>;
    case 'edit': return <svg {...props}><path d="M16 3l5 5-11 11H5v-5z"/></svg>;
    case 'trash': return <svg {...props}><path d="M3 6h18M8 6V4a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2M6 6l1 14a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1l1-14"/></svg>;
    case 'history': return <svg {...props}><path d="M3 12a9 9 0 1 0 3-6.7"/><path d="M3 4v5h5"/><path d="M12 7v5l3 2"/></svg>;
    case 'lock': return <svg {...props}><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 1 1 8 0v4"/></svg>;
    case 'share': return <svg {...props}><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><path d="M8.6 13.5l6.8 4M15.4 6.5l-6.8 4"/></svg>;
    case 'globe': return <svg {...props}><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/></svg>;
    case 'sun': return <svg {...props}><circle cx="12" cy="12" r="4"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3M4.9 4.9l2.1 2.1M17 17l2.1 2.1M4.9 19.1L7 17M17 7l2.1-2.1"/></svg>;
    case 'moon': return <svg {...props}><path d="M21 14a9 9 0 1 1-12-12 7 7 0 0 0 12 12z"/></svg>;
    // category icons
    case 'cat-kitchen': return <svg {...props}><path d="M6 3v6a3 3 0 0 0 3 3v9"/><path d="M9 3v6"/><path d="M15 3l3 6v3a2 2 0 0 1-2 2h0v7"/></svg>;
    case 'cat-bath': return <svg {...props}><path d="M3 12h18v3a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4v-3z"/><path d="M5 12V7a3 3 0 0 1 6 0"/><path d="M9 7h2"/><path d="M6 19v2M18 19v2"/></svg>;
    case 'cat-laundry': return <svg {...props}><rect x="4" y="3" width="16" height="18" rx="2"/><circle cx="12" cy="13" r="4"/><circle cx="8" cy="6" r=".75" fill={stroke} stroke="none"/></svg>;
    case 'cat-living': return <svg {...props}><path d="M4 11V9a2 2 0 0 1 4 0v2M16 11V9a2 2 0 0 1 4 0v2"/><path d="M2 11h20v5a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-5z"/><path d="M5 18v2M19 18v2"/></svg>;
    case 'cat-garden': return <svg {...props}><path d="M12 22V10"/><path d="M12 10c0-3 2-6 6-6 0 4-3 6-6 6z"/><path d="M12 13c0-3-2-5-5-5 0 4 2 5 5 5z"/></svg>;
    case 'cat-garage': return <svg {...props}><path d="M3 21V9l9-5 9 5v12"/><path d="M6 21v-7h12v7"/><path d="M6 17h12"/></svg>;
    case 'cat-general': return <svg {...props}><rect x="3" y="7" width="18" height="13" rx="2"/><path d="M8 7V5a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>;
    // document icons
    case 'doc-id': return <svg {...props}><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="12" r="2"/><path d="M14 10h4M14 14h3"/><path d="M6 17c0-1.7 1.3-3 3-3s3 1.3 3 3"/></svg>;
    case 'doc-car': return <svg {...props}><path d="M5 13l1.5-5a2 2 0 0 1 2-1.5h7a2 2 0 0 1 2 1.5L19 13"/><path d="M3 13h18v5h-2v2h-3v-2H8v2H5v-2H3z"/><circle cx="7" cy="16" r="1" fill={stroke} stroke="none"/><circle cx="17" cy="16" r="1" fill={stroke} stroke="none"/></svg>;
    case 'doc-house': return <svg {...props}><path d="M3 11l9-7 9 7"/><path d="M5 10v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-9"/><path d="M9 20v-6h6v6"/></svg>;
    default: return <svg {...props}><circle cx="12" cy="12" r="9"/></svg>;
  }
}

// ─────────────────────────────────────────────────────────────
// Phone shell — minimal Android-style; not the starter (we want tight control of inner chrome)
// ─────────────────────────────────────────────────────────────
function Phone({ theme, dark, children }) {
  return (
    <div style={{
      width: 392, height: 820, borderRadius: 44, position: 'relative',
      background: dark ? '#0a0907' : '#23211c',
      padding: 9,
      boxShadow: '0 50px 120px -20px rgba(35,33,28,0.45), 0 30px 60px -30px rgba(0,0,0,0.45), inset 0 0 0 1px rgba(255,255,255,0.06)',
    }}>
      {/* screen */}
      <div style={{
        width: '100%', height: '100%', borderRadius: 36, overflow: 'hidden',
        background: theme.bg, color: theme.text,
        fontFamily: theme.fontBody, fontWeight: theme.bodyWeight,
        position: 'relative', display: 'flex', flexDirection: 'column',
      }}>
        {/* status bar */}
        <StatusBar theme={theme} dark={dark} />
        {/* content fills remaining */}
        <div className="phone-scroll" style={{ flex: 1, overflow: 'auto', position: 'relative' }}>
          {children}
        </div>
        {/* gesture nav */}
        <div style={{ height: 22, display: 'flex', alignItems: 'flex-end', justifyContent: 'center', paddingBottom: 6, background: 'transparent' }}>
          <div style={{ width: 120, height: 4, borderRadius: 99, background: theme.text, opacity: 0.35 }} />
        </div>
      </div>
    </div>
  );
}

function StatusBar({ theme, dark }) {
  const c = theme.text;
  return (
    <div style={{
      height: 36, display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '0 22px 0 24px', fontSize: 14, fontWeight: 600, color: c,
      fontFamily: theme.fontBody, position: 'relative', flexShrink: 0,
    }}>
      <span style={{ fontVariantNumeric: 'tabular-nums' }}>9:41</span>
      {/* punch hole */}
      <div style={{
        position: 'absolute', left: '50%', top: 12, transform: 'translateX(-50%)',
        width: 18, height: 18, borderRadius: 99, background: '#0a0907',
      }} />
      <div style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
        {/* signal */}
        <svg width="16" height="12" viewBox="0 0 16 12"><path d="M1 11h2V8H1zM5 11h2V6H5zM9 11h2V3H9zM13 11h2V1h-2z" fill={c}/></svg>
        {/* wifi */}
        <svg width="15" height="12" viewBox="0 0 15 12"><path d="M7.5 2C4.5 2 2 3.4 0.4 5.4L1.7 6.5C3 4.9 5.1 4 7.5 4S12 4.9 13.3 6.5L14.6 5.4C13 3.4 10.5 2 7.5 2zM7.5 6C5.8 6 4.2 6.7 3 7.9L4.3 9C5.1 8.2 6.3 7.7 7.5 7.7S9.9 8.2 10.7 9L12 7.9C10.8 6.7 9.2 6 7.5 6zM7.5 9.4c-.9 0-1.7.3-2.3.9L7.5 12.4l2.3-2.1c-.6-.6-1.4-.9-2.3-.9z" fill={c}/></svg>
        {/* battery */}
        <svg width="22" height="11" viewBox="0 0 22 11"><rect x="0.5" y="0.5" width="19" height="10" rx="2.5" fill="none" stroke={c} strokeOpacity="0.4"/><rect x="2" y="2" width="16" height="7" rx="1.2" fill={c}/><rect x="20" y="3.5" width="1.5" height="4" rx="0.5" fill={c} fillOpacity="0.4"/></svg>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Reusable bits
// ─────────────────────────────────────────────────────────────
function Chip({ theme, children, active, onClick, tone }) {
  const palette = tone === 'danger' ? [theme.dangerSoft, theme.danger]
    : tone === 'warn' ? [theme.warnSoft, theme.warn]
    : tone === 'ok' ? [theme.okSoft, theme.ok]
    : tone === 'accent' ? [theme.accentSoft, theme.accent]
    : [theme.primarySoft, theme.primary];
  return (
    <button onClick={onClick} style={{
      padding: '6px 12px', borderRadius: theme.radiusChip, fontSize: 12.5, fontWeight: 600,
      background: active ? palette[1] : palette[0],
      color: active ? theme.onPrimary : palette[1],
      border: 'none', whiteSpace: 'nowrap', letterSpacing: 0.1,
    }}>{children}</button>
  );
}

function Btn({ theme, children, onClick, variant = 'primary', icon, full, size = 'md' }) {
  const pad = size === 'sm' ? '8px 14px' : size === 'lg' ? '16px 22px' : '13px 18px';
  const fs = size === 'sm' ? 13 : size === 'lg' ? 16 : 14.5;
  const styles = variant === 'primary' ? { background: theme.primary, color: theme.onPrimary }
    : variant === 'accent' ? { background: theme.accent, color: '#fff' }
    : variant === 'soft' ? { background: theme.primarySoft, color: theme.primary }
    : variant === 'ghost' ? { background: 'transparent', color: theme.text }
    : variant === 'outline' ? { background: 'transparent', color: theme.text, boxShadow: `inset 0 0 0 1px ${theme.border}` }
    : { background: theme.surface, color: theme.text, boxShadow: `inset 0 0 0 1px ${theme.border}` };
  return (
    <button onClick={onClick} style={{
      ...styles, padding: pad, borderRadius: theme.radiusBtn, fontSize: fs, fontWeight: 600,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      width: full ? '100%' : undefined, transition: 'transform .12s, opacity .15s',
      letterSpacing: theme.name === 'Editorial' ? 0.2 : 0,
    }}>
      {icon && <Icon name={icon} size={fs + 4} />}
      {children}
    </button>
  );
}

function Card({ theme, children, pad = 16, style }) {
  return (
    <div style={{
      background: theme.surface, borderRadius: theme.radiusCard, padding: pad,
      boxShadow: theme.cardShadow, border: theme.name === 'Editorial' ? `1px solid ${theme.border}` : 'none',
      ...style,
    }}>{children}</div>
  );
}

// Status pill with traffic-light color
function StatusPill({ theme, status, label }) {
  const pal = status === 'overdue' ? [theme.dangerSoft, theme.danger]
    : status === 'due' ? [theme.dangerSoft, theme.danger]
    : status === 'soon' ? [theme.warnSoft, theme.warn]
    : [theme.okSoft, theme.ok];
  return (
    <span style={{
      background: pal[0], color: pal[1], fontSize: 11.5, fontWeight: 700,
      padding: '4px 9px', borderRadius: theme.radiusChip, letterSpacing: 0.3,
      textTransform: theme.name === 'Editorial' ? 'uppercase' : 'none',
      display: 'inline-flex', alignItems: 'center', gap: 5,
    }}>
      <span style={{ width: 6, height: 6, borderRadius: 99, background: pal[1] }} />
      {label}
    </span>
  );
}

// Category visual — colored tile w/ icon. Each category gets a unique hue.
function CategoryTile({ theme, category, size = 56 }) {
  const map = {
    kitchen: { ic: 'cat-kitchen', hue: 28 }, // orange
    bath: { ic: 'cat-bath', hue: 210 }, // blue
    laundry: { ic: 'cat-laundry', hue: 260 }, // purple
    living: { ic: 'cat-living', hue: 180 }, // teal
    garden: { ic: 'cat-garden', hue: 140 }, // green
    garage: { ic: 'cat-garage', hue: 40 }, // amber
    general: { ic: 'cat-general', hue: 320 }, // pink
  };
  const c = map[category] || map.general;
  // Tints derived from theme
  const bg = theme.name === 'Editorial'
    ? theme.surfaceAlt
    : `oklch(94% 0.04 ${c.hue})`;
  const fg = theme.name === 'Editorial'
    ? theme.text
    : `oklch(40% 0.10 ${c.hue})`;
  return (
    <div style={{
      width: size, height: size, borderRadius: theme.name === 'Vibrant' ? 18 : theme.name === 'Editorial' ? 4 : 14,
      background: bg, color: fg,
      display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
    }}>
      <Icon name={c.ic} size={size * 0.5} sw={1.6} />
    </div>
  );
}

// Striped placeholder for photos
function PhotoSlot({ theme, label, height = 120, width = '100%', round, style }) {
  return (
    <div style={{
      width, height, borderRadius: round ?? theme.radiusCard,
      background: `repeating-linear-gradient(135deg, ${theme.placeholderStripe} 0 8px, transparent 8px 16px)`,
      border: `1px dashed ${theme.border}`,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      color: theme.textFaint, fontFamily: theme.fontMono, fontSize: 11, letterSpacing: 0.4,
      textTransform: 'uppercase',
      ...style,
    }}>{label}</div>
  );
}

Object.assign(window, {
  THEMES, STRINGS, getTheme,
  Icon, Phone, Chip, Btn, Card, StatusPill, CategoryTile, PhotoSlot,
});

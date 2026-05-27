// screens.jsx — all screens for HouseKeep prototype

// ─────────────────────────────────────────────────────────────
// SAMPLE DATA
// ─────────────────────────────────────────────────────────────
function makeItems() {
  return [
    { id: 'i1', name: { es: 'Caldera de gas', en: 'Gas boiler' }, brand: 'Vaillant ecoTEC', cat: 'bath', purchased: '2021-09-14', warrantyM: 84, nextMaint: 'Revisión anual', nextDays: -3, status: 'overdue', notes: 'Sala caldera' },
    { id: 'i2', name: { es: 'Lavadora', en: 'Washing machine' }, brand: 'Bosch Serie 6', cat: 'laundry', purchased: '2023-03-02', warrantyM: 24, nextMaint: { es: 'Limpiar filtro', en: 'Clean filter' }, nextDays: 4, status: 'soon' },
    { id: 'i3', name: { es: 'Aire acondicionado', en: 'Air conditioner' }, brand: 'Daikin Sensira', cat: 'living', purchased: '2022-06-18', warrantyM: 36, nextMaint: { es: 'Cambiar filtros', en: 'Replace filters' }, nextDays: 12, status: 'ok' },
    { id: 'i4', name: { es: 'Coche', en: 'Car' }, brand: 'SEAT León', cat: 'garage', purchased: '2020-11-04', warrantyM: 0, nextMaint: { es: 'Cambio de aceite', en: 'Oil change' }, nextDays: 21, status: 'ok' },
    { id: 'i5', name: { es: 'Lavavajillas', en: 'Dishwasher' }, brand: 'Balay 3VS', cat: 'kitchen', purchased: '2024-02-11', warrantyM: 36, nextMaint: { es: 'Limpieza profunda', en: 'Deep clean' }, nextDays: 30, status: 'ok' },
  ];
}

function makeDocs() {
  return [
    { id: 'd1', name: { es: 'Seguro del coche', en: 'Car insurance' }, kind: 'doc-car', expires: '2026-06-04', days: 9, status: 'soon' },
    { id: 'd2', name: { es: 'ITV — SEAT León', en: 'MOT — SEAT León' }, kind: 'doc-car', expires: '2026-07-22', days: 57, status: 'ok' },
    { id: 'd3', name: { es: 'DNI', en: 'ID card' }, kind: 'doc-id', expires: '2027-01-15', days: 234, status: 'ok' },
    { id: 'd4', name: { es: 'Seguro del hogar', en: 'Home insurance' }, kind: 'doc-house', expires: '2026-04-20', days: -36, status: 'overdue' },
  ];
}

function makeUpcoming(items, docs, t, lang) {
  const fromItems = items.map(i => ({
    id: 'm-' + i.id, kind: 'maint',
    title: typeof i.nextMaint === 'string' ? i.nextMaint : i.nextMaint[lang],
    sub: i.name[lang], cat: i.cat,
    days: i.nextDays, status: i.status,
  }));
  const fromDocs = docs.map(d => ({
    id: 'd-' + d.id, kind: 'doc',
    title: d.name[lang], sub: t.detail_until + ' ' + d.expires,
    docKind: d.kind, days: d.days, status: d.status,
  }));
  return [...fromItems, ...fromDocs].sort((a, b) => a.days - b.days);
}

function daysLabel(days, t) {
  if (days === 0) return t.today;
  if (days < 0) return t.days_overdue(-days);
  return t.days_short(days);
}

// ─────────────────────────────────────────────────────────────
// SHARED: tab bar
// ─────────────────────────────────────────────────────────────
function TabBar({ theme, current, onNav, t }) {
  const tabs = [
    { id: 'home', label: t.tab_home, icon: 'home' },
    { id: 'items', label: t.tab_items, icon: 'box' },
    { id: 'docs', label: t.tab_docs, icon: 'file' },
    { id: 'settings', label: t.tab_settings, icon: 'gear' },
  ];
  return (
    <div style={{
      position: 'absolute', left: 0, right: 0, bottom: 0,
      background: theme.surface, paddingTop: 6, paddingBottom: 12,
      borderTop: `1px solid ${theme.border}`,
      display: 'flex', justifyContent: 'space-around',
    }}>
      {tabs.map(tab => {
        const active = current === tab.id;
        return (
          <button key={tab.id} onClick={() => onNav(tab.id)} style={{
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
            padding: '6px 10px', minWidth: 60,
          }}>
            <div style={{
              padding: '4px 16px', borderRadius: 999,
              background: active ? theme.primarySoft : 'transparent',
              color: active ? theme.primary : theme.textMuted,
              transition: 'all .2s',
            }}>
              <Icon name={tab.icon} size={22} sw={active ? 2 : 1.6} />
            </div>
            <span style={{
              fontSize: 11, fontWeight: active ? 700 : 500,
              color: active ? theme.text : theme.textMuted,
              letterSpacing: 0.1,
            }}>{tab.label}</span>
          </button>
        );
      })}
    </div>
  );
}

// Bottom-of-screen FAB
function FAB({ theme, onClick, icon = 'plus' }) {
  return (
    <button onClick={onClick} style={{
      position: 'absolute', right: 20, bottom: 88,
      width: 56, height: 56, borderRadius: theme.name === 'Editorial' ? 8 : 18,
      background: theme.accent, color: '#fff',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      boxShadow: '0 8px 24px rgba(0,0,0,0.18)',
    }}>
      <Icon name={icon} size={26} sw={2.2} />
    </button>
  );
}

// ─────────────────────────────────────────────────────────────
// 1) ONBOARDING
// ─────────────────────────────────────────────────────────────
function OnboardingScreen({ theme, t, lang, go }) {
  const [page, setPage] = React.useState(0);
  const pages = [
    { t: t.onb_1_t, s: t.onb_1_s, icon: 'home', tone: theme.primary, art: 'home' },
    { t: t.onb_2_t, s: t.onb_2_s, icon: 'bell', tone: theme.accent, art: 'bell' },
    { t: t.onb_3_t, s: t.onb_3_s, icon: 'sparkle', tone: theme.primary, art: 'spark' },
  ];
  const p = pages[page];
  const isLast = page === pages.length - 1;
  return (
    <div style={{ display: 'flex', flexDirection: 'column', minHeight: '100%', padding: '24px 24px 36px' }}>
      <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
        {!isLast && (
          <button onClick={() => go('home')} style={{ color: theme.textMuted, fontSize: 14, fontWeight: 500 }}>
            {t.onb_skip}
          </button>
        )}
      </div>

      {/* Big art */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center', marginTop: 8 }}>
        <OnboardingArt theme={theme} kind={p.art} />
      </div>

      {/* Page dots */}
      <div style={{ display: 'flex', justifyContent: 'center', gap: 8, marginBottom: 20 }}>
        {pages.map((_, i) => (
          <div key={i} style={{
            width: i === page ? 24 : 6, height: 6, borderRadius: 99,
            background: i === page ? theme.primary : theme.border,
            transition: 'all .25s',
          }} />
        ))}
      </div>

      {/* Title */}
      <h1 style={{
        fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
        fontSize: theme.name === 'Editorial' ? 40 : 30, lineHeight: 1.1, margin: 0,
        color: theme.text, textWrap: 'pretty',
      }}>{p.t}</h1>
      <p style={{
        fontSize: 16, lineHeight: 1.5, color: theme.textMuted, marginTop: 12, marginBottom: 28, textWrap: 'pretty',
      }}>{p.s}</p>

      <div style={{ display: 'flex', gap: 12 }}>
        {page > 0 && (
          <Btn theme={theme} variant="outline" onClick={() => setPage(page - 1)} icon="chevron-left">
            {/* no label */}
          </Btn>
        )}
        <div style={{ flex: 1 }}>
          {isLast ? (
            <Btn theme={theme} full onClick={() => go('home')} icon="arrow-right" size="lg">{t.onb_start}</Btn>
          ) : (
            <Btn theme={theme} full onClick={() => setPage(page + 1)} icon="arrow-right" size="lg">{t.onb_next}</Btn>
          )}
        </div>
      </div>
    </div>
  );
}

function OnboardingArt({ theme, kind }) {
  // Stylized abstract compositions per page — kept simple (no SVG illustrations).
  const W = 280, H = 280;
  if (kind === 'home') {
    // Cluster of category tiles falling into one big "house" tile.
    return (
      <div style={{ width: W, height: H, position: 'relative' }}>
        {/* big tile */}
        <div style={{
          position: 'absolute', left: 60, top: 80, width: 180, height: 160,
          borderRadius: theme.radiusCard * 1.4, background: theme.primarySoft,
          color: theme.primary, display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icon name="home" size={92} sw={1.4} />
        </div>
        {/* floating mini-tiles */}
        {[
          { x: 0, y: 0, c: 'cat-kitchen', tone: 28 },
          { x: 220, y: 0, c: 'cat-laundry', tone: 260 },
          { x: 200, y: 200, c: 'cat-garden', tone: 140 },
          { x: 10, y: 160, c: 'cat-bath', tone: 210 },
        ].map((p, i) => (
          <div key={i} style={{
            position: 'absolute', left: p.x, top: p.y, width: 60, height: 60,
            borderRadius: theme.radiusCard * 0.6,
            background: theme.name === 'Editorial' ? theme.surfaceAlt : `oklch(92% 0.05 ${p.tone})`,
            color: theme.name === 'Editorial' ? theme.text : `oklch(40% 0.12 ${p.tone})`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            boxShadow: theme.cardShadow,
            transform: `rotate(${(i % 2 ? -1 : 1) * 6}deg)`,
          }}>
            <Icon name={p.c} size={30} sw={1.6} />
          </div>
        ))}
      </div>
    );
  }
  if (kind === 'bell') {
    return (
      <div style={{ width: W, height: H, position: 'relative' }}>
        {/* stack of nudge cards */}
        {[0, 1, 2].map(i => (
          <div key={i} style={{
            position: 'absolute', left: 30 + i * 8, top: 60 + i * 16, width: 220, height: 70,
            background: theme.surface, borderRadius: theme.radiusCard,
            boxShadow: theme.cardShadow,
            border: theme.name === 'Editorial' ? `1px solid ${theme.border}` : 'none',
            padding: 14, display: 'flex', alignItems: 'center', gap: 12,
            opacity: 1 - i * 0.18,
          }}>
            <div style={{
              width: 40, height: 40, borderRadius: theme.radiusCard * 0.5,
              background: i === 0 ? theme.dangerSoft : i === 1 ? theme.warnSoft : theme.okSoft,
              color: i === 0 ? theme.danger : i === 1 ? theme.warn : theme.ok,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Icon name="bell" size={20} />
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ height: 8, width: '70%', borderRadius: 4, background: theme.surfaceAlt, marginBottom: 6 }} />
              <div style={{ height: 6, width: '45%', borderRadius: 4, background: theme.surfaceAlt, opacity: 0.6 }} />
            </div>
          </div>
        ))}
        {/* big bell glyph */}
        <div style={{
          position: 'absolute', right: 0, bottom: 10, width: 100, height: 100,
          borderRadius: 99, background: theme.accent, color: '#fff',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 12px 30px rgba(0,0,0,0.18)',
        }}>
          <Icon name="bell" size={48} sw={1.6} />
        </div>
      </div>
    );
  }
  // sparkle: a single item card highlighted
  return (
    <div style={{ width: W, height: H, position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
      <div style={{
        width: 220, padding: 18, background: theme.surface, borderRadius: theme.radiusCard,
        boxShadow: theme.cardShadow, border: theme.name === 'Editorial' ? `1px solid ${theme.border}` : 'none',
        display: 'flex', flexDirection: 'column', gap: 14, position: 'relative',
      }}>
        <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
          <CategoryTile theme={theme} category="bath" size={48} />
          <div style={{ flex: 1 }}>
            <div style={{ height: 10, width: '80%', borderRadius: 4, background: theme.surfaceAlt, marginBottom: 6 }} />
            <div style={{ height: 7, width: '55%', borderRadius: 4, background: theme.surfaceAlt, opacity: 0.6 }} />
          </div>
        </div>
        <PhotoSlot theme={theme} label="appliance photo" height={70} />
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <StatusPill theme={theme} status="soon" label="•••" />
          <div style={{ height: 7, width: 60, borderRadius: 4, background: theme.surfaceAlt }} />
        </div>
        <div style={{
          position: 'absolute', top: -14, right: -14, color: theme.accent,
        }}>
          <Icon name="sparkle" size={44} fill={theme.accent} stroke={theme.accent} />
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 2) HOME DASHBOARD
// ─────────────────────────────────────────────────────────────
function HomeScreen({ theme, t, lang, items, docs, empty, plan, go, onAdd }) {
  if (empty) return <HomeEmpty theme={theme} t={t} go={go} onAdd={onAdd} />;
  const upcoming = makeUpcoming(items, docs, t, lang).slice(0, 6);
  const dueCount = upcoming.filter(u => u.status === 'overdue' || u.status === 'due').length;
  const soonCount = upcoming.filter(u => u.status === 'soon').length;
  const okCount = items.length + docs.length - dueCount - soonCount;

  return (
    <div style={{ paddingBottom: 100 }}>
      {/* Header */}
      <div style={{ padding: '12px 22px 18px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
          <div>
            <div style={{ fontSize: 13, color: theme.textMuted, fontWeight: 500, letterSpacing: 0.2 }}>{t.home_title},</div>
            <h1 style={{
              fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
              fontSize: theme.name === 'Editorial' ? 38 : 28, margin: '2px 0 0', lineHeight: 1.05,
            }}>{t.sample_greeting_name}</h1>
          </div>
          <div style={{
            width: 44, height: 44, borderRadius: 99, background: theme.primarySoft, color: theme.primary,
            display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 700, fontSize: 16,
            fontFamily: theme.fontDisplay,
          }}>
            {t.sample_greeting_name[0]}
          </div>
        </div>
        <p style={{ fontSize: 14, color: theme.textMuted, margin: 0 }}>{t.home_sub}</p>
      </div>

      {/* Summary triplet */}
      <div style={{ padding: '0 18px', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10, marginBottom: 22 }}>
        <SummaryStat theme={theme} n={dueCount} label={t.home_summary_due} tone="danger" />
        <SummaryStat theme={theme} n={soonCount} label={t.home_summary_soon} tone="warn" />
        <SummaryStat theme={theme} n={Math.max(0, okCount)} label={t.home_summary_ok} tone="ok" />
      </div>

      {/* Upcoming */}
      <div style={{ padding: '0 22px 4px', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <h2 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 24 : 18, margin: 0, letterSpacing: theme.name === 'Editorial' ? 0 : -0.2,
        }}>{t.home_upcoming}</h2>
        <button onClick={() => go('items')} style={{ color: theme.primary, fontSize: 13, fontWeight: 600 }}>
          {lang === 'es' ? 'Ver todo' : 'See all'} →
        </button>
      </div>

      {/* Timeline */}
      <div style={{ padding: '14px 18px 0', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {upcoming.map(u => <TimelineRow key={u.id} theme={theme} item={u} t={t} onClick={() => u.kind === 'maint' ? go('item:' + u.id.replace('m-', '')) : go('docs')} />)}
      </div>

      {/* Pro upsell card for free plan */}
      {plan === 'free' && (
        <div style={{ padding: '20px 18px 0' }}>
          <Card theme={theme} pad={16} style={{
            background: theme.name === 'Editorial' ? theme.surfaceAlt : `linear-gradient(135deg, ${theme.primary}, ${theme.primary} 60%, ${theme.accent})`,
            color: theme.name === 'Editorial' ? theme.text : '#fff',
            border: 'none',
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
              <div style={{
                width: 44, height: 44, borderRadius: theme.radiusCard * 0.5,
                background: 'rgba(255,255,255,0.18)', color: theme.name === 'Editorial' ? theme.accent : '#fff',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                <Icon name="sparkle" size={22} />
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14.5, fontWeight: 700, fontFamily: theme.fontDisplay }}>
                  {lang === 'es' ? 'Pásate a Pro por €5,99' : 'Go Pro for €5.99'}
                </div>
                <div style={{ fontSize: 12.5, opacity: 0.85, marginTop: 2 }}>
                  {lang === 'es' ? 'Sin límites · pago único · para siempre' : 'No limits · one-time · forever'}
                </div>
              </div>
              <button onClick={() => go('paywall')} style={{
                background: theme.name === 'Editorial' ? theme.accent : '#fff',
                color: theme.name === 'Editorial' ? '#fff' : theme.primary,
                padding: '8px 14px', borderRadius: theme.radiusBtn, fontWeight: 700, fontSize: 13,
              }}>{lang === 'es' ? 'Ver' : 'Open'}</button>
            </div>
          </Card>
        </div>
      )}
    </div>
  );
}

function SummaryStat({ theme, n, label, tone }) {
  const pal = tone === 'danger' ? [theme.dangerSoft, theme.danger]
    : tone === 'warn' ? [theme.warnSoft, theme.warn]
    : [theme.okSoft, theme.ok];
  return (
    <Card theme={theme} pad={14} style={{ borderRadius: theme.radiusCard * 0.8 }}>
      <div style={{
        width: 8, height: 8, borderRadius: 99, background: pal[1], marginBottom: 10,
      }} />
      <div style={{
        fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
        fontSize: 28, lineHeight: 1, color: theme.text,
      }}>{n}</div>
      <div style={{ fontSize: 12, color: theme.textMuted, marginTop: 6, fontWeight: 500 }}>{label}</div>
    </Card>
  );
}

function TimelineRow({ theme, item, t, onClick }) {
  return (
    <button onClick={onClick} style={{
      display: 'flex', alignItems: 'center', gap: 12, padding: '14px 16px',
      background: theme.surface, borderRadius: theme.radiusCard,
      boxShadow: theme.cardShadow,
      border: theme.name === 'Editorial' ? `1px solid ${theme.border}` : 'none',
      textAlign: 'left', width: '100%',
    }}>
      {item.kind === 'maint'
        ? <CategoryTile theme={theme} category={item.cat} size={44} />
        : <div style={{
            width: 44, height: 44, borderRadius: theme.name === 'Vibrant' ? 14 : theme.name === 'Editorial' ? 4 : 12,
            background: theme.primarySoft, color: theme.primary,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}><Icon name={item.docKind} size={22} sw={1.7} /></div>
      }
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14.5, fontWeight: 600, color: theme.text, textOverflow: 'ellipsis', overflow: 'hidden', whiteSpace: 'nowrap' }}>{item.title}</div>
        <div style={{ fontSize: 12.5, color: theme.textMuted, marginTop: 2 }}>{item.sub}</div>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: 4 }}>
        <StatusPill theme={theme} status={item.status} label={daysLabel(item.days, t)} />
      </div>
    </button>
  );
}

function HomeEmpty({ theme, t, go, onAdd }) {
  return (
    <div style={{ padding: '40px 28px 100px', display: 'flex', flexDirection: 'column', alignItems: 'center', textAlign: 'center', minHeight: '100%' }}>
      <div style={{ marginTop: 30, marginBottom: 26 }}>
        <OnboardingArt theme={theme} kind="home" />
      </div>
      <h1 style={{
        fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
        fontSize: theme.name === 'Editorial' ? 32 : 26, margin: 0, textWrap: 'pretty',
      }}>{t.home_empty_title}</h1>
      <p style={{ fontSize: 15, lineHeight: 1.45, color: theme.textMuted, marginTop: 12, marginBottom: 28, textWrap: 'pretty' }}>{t.home_empty_sub}</p>
      <Btn theme={theme} size="lg" icon="plus" onClick={() => onAdd()}>{t.home_empty_cta}</Btn>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 3) ITEMS LIST
// ─────────────────────────────────────────────────────────────
function ItemsScreen({ theme, t, lang, items, plan, go }) {
  const [filter, setFilter] = React.useState('all');
  const filters = [
    { id: 'all', label: t.items_filter_all },
    { id: 'kitchen', label: t.items_filter_kitchen },
    { id: 'bath', label: t.items_filter_bath },
    { id: 'laundry', label: t.items_filter_laundry },
    { id: 'living', label: t.items_filter_living },
    { id: 'garage', label: t.items_filter_garage },
    { id: 'garden', label: t.items_filter_garden },
  ];
  const filtered = filter === 'all' ? items : items.filter(i => i.cat === filter);

  if (items.length === 0) {
    return (
      <div style={{ padding: '24px 22px 100px' }}>
        <h1 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 36 : 26, margin: '0 0 20px',
        }}>{t.items_title}</h1>
        <Card theme={theme} pad={32} style={{ textAlign: 'center' }}>
          <div style={{ marginBottom: 16, color: theme.primary }}>
            <Icon name="box" size={48} sw={1.4} />
          </div>
          <div style={{ fontSize: 17, fontWeight: 600, color: theme.text, marginBottom: 6 }}>{t.items_empty}</div>
          <div style={{ fontSize: 13, color: theme.textMuted, marginBottom: 20, textWrap: 'pretty' }}>{t.items_empty_sub}</div>
          <Btn theme={theme} icon="plus" onClick={() => go('add')}>{t.items_add}</Btn>
        </Card>
      </div>
    );
  }

  return (
    <div style={{ paddingBottom: 100 }}>
      <div style={{ padding: '12px 22px 8px', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <h1 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 36 : 26, margin: 0,
        }}>{t.items_title}</h1>
        <div style={{ fontSize: 13, color: theme.textMuted, fontFamily: theme.fontMono }}>
          {plan === 'free' ? `${items.length}/5` : t.items_count(items.length)}
        </div>
      </div>

      {/* filter chips, horizontal scroll */}
      <div style={{
        padding: '4px 22px 12px',
        display: 'flex', gap: 7, overflowX: 'auto', scrollbarWidth: 'none',
      }} className="phone-scroll">
        {filters.map(f => (
          <Chip key={f.id} theme={theme} active={filter === f.id} onClick={() => setFilter(f.id)}>{f.label}</Chip>
        ))}
      </div>

      {/* Item cards */}
      <div style={{ padding: '4px 18px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {filtered.map(item => (
          <ItemCard key={item.id} theme={theme} item={item} t={t} lang={lang} onClick={() => go('item:' + item.id)} />
        ))}
      </div>
    </div>
  );
}

function ItemCard({ theme, item, t, lang, onClick }) {
  const warrantyOk = item.warrantyM > 0; // simple flag
  return (
    <button onClick={onClick} style={{
      display: 'flex', gap: 14, padding: 14,
      background: theme.surface, borderRadius: theme.radiusCard,
      boxShadow: theme.cardShadow,
      border: theme.name === 'Editorial' ? `1px solid ${theme.border}` : 'none',
      textAlign: 'left', width: '100%',
    }}>
      <CategoryTile theme={theme} category={item.cat} size={60} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 2 }}>
          <div style={{
            fontSize: 15.5, fontWeight: 600, color: theme.text,
            overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', flex: 1,
            fontFamily: theme.fontDisplay,
          }}>{item.name[lang]}</div>
          <Icon name="chevron-right" size={18} stroke={theme.textFaint} sw={1.6} />
        </div>
        <div style={{ fontSize: 13, color: theme.textMuted, marginBottom: 8 }}>{item.brand}</div>
        <div style={{ display: 'flex', gap: 6, alignItems: 'center', flexWrap: 'wrap' }}>
          <StatusPill theme={theme} status={item.status} label={daysLabel(item.nextDays, t)} />
          {warrantyOk && (
            <span style={{
              fontSize: 11.5, color: theme.textMuted, fontWeight: 500,
              display: 'inline-flex', alignItems: 'center', gap: 4,
            }}>
              <Icon name="lock" size={11} sw={2} />
              {lang === 'es' ? 'Garantía activa' : 'Warranty active'}
            </span>
          )}
        </div>
      </div>
    </button>
  );
}

// ─────────────────────────────────────────────────────────────
// 4) ITEM DETAIL
// ─────────────────────────────────────────────────────────────
function ItemDetail({ theme, t, lang, item, go, onMarkDone }) {
  if (!item) return null;
  const maint = [
    { id: 'm1', name: typeof item.nextMaint === 'string' ? item.nextMaint : item.nextMaint[lang], every: lang === 'es' ? 'cada 12 meses' : 'every 12 months', days: item.nextDays, status: item.status },
    { id: 'm2', name: lang === 'es' ? 'Limpieza profunda' : 'Deep clean', every: lang === 'es' ? 'cada 6 meses' : 'every 6 months', days: 92, status: 'ok' },
  ];
  const history = [
    { date: '2025-09-14', who: lang === 'es' ? 'Marta' : 'Sam', what: lang === 'es' ? 'Revisión anual' : 'Annual service' },
    { date: '2025-03-02', who: lang === 'es' ? 'Marta' : 'Sam', what: lang === 'es' ? 'Limpieza profunda' : 'Deep clean' },
    { date: '2024-09-15', who: lang === 'es' ? 'Marta' : 'Sam', what: lang === 'es' ? 'Revisión anual' : 'Annual service' },
  ];
  return (
    <div style={{ paddingBottom: 32 }}>
      {/* Hero image area */}
      <div style={{ position: 'relative', height: 220, overflow: 'hidden', background: theme.surfaceAlt }}>
        <PhotoSlot theme={theme} label={`${item.cat} hero photo`} height={220} round={0} style={{ border: 'none' }} />
        {/* back */}
        <button onClick={() => go('items')} style={{
          position: 'absolute', top: 14, left: 14,
          width: 40, height: 40, borderRadius: 99,
          background: 'rgba(255,255,255,0.92)', color: theme.text,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          backdropFilter: 'blur(8px)',
        }}><Icon name="arrow-left" size={20} sw={2} /></button>
        <button style={{
          position: 'absolute', top: 14, right: 14,
          width: 40, height: 40, borderRadius: 99,
          background: 'rgba(255,255,255,0.92)', color: theme.text,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}><Icon name="more" size={20} stroke={theme.text} /></button>
        {/* category tile bottom-left */}
        <div style={{ position: 'absolute', left: 18, bottom: -22 }}>
          <CategoryTile theme={theme} category={item.cat} size={64} />
        </div>
      </div>

      {/* Title block */}
      <div style={{ padding: '32px 22px 0' }}>
        <h1 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 32 : 24, margin: 0, lineHeight: 1.1,
        }}>{item.name[lang]}</h1>
        <div style={{ fontSize: 14, color: theme.textMuted, marginTop: 4 }}>{item.brand}</div>
      </div>

      {/* Warranty card */}
      <div style={{ padding: '18px 18px 0' }}>
        <Card theme={theme} pad={16}>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <div>
              <div style={{ fontSize: 12, color: theme.textMuted, fontWeight: 600, letterSpacing: 0.4, textTransform: 'uppercase' }}>{t.detail_warranty}</div>
              <div style={{ fontSize: 18, fontWeight: 700, color: theme.text, marginTop: 6, fontFamily: theme.fontDisplay }}>
                {item.warrantyM > 0 ? `${item.warrantyM} ${lang === 'es' ? 'meses' : 'months'}` : (lang === 'es' ? 'Sin garantía' : 'No warranty')}
              </div>
              <div style={{ fontSize: 12.5, color: theme.textMuted, marginTop: 4 }}>{t.detail_purchased} {item.purchased}</div>
            </div>
            {item.warrantyM > 0 && (
              <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', justifyContent: 'space-between' }}>
                <StatusPill theme={theme} status="ok" label={lang === 'es' ? 'Activa' : 'Active'} />
                <div style={{ fontSize: 11.5, color: theme.textFaint, fontFamily: theme.fontMono }}>
                  → 2028-09-14
                </div>
              </div>
            )}
          </div>
          {/* progress bar */}
          {item.warrantyM > 0 && (
            <div style={{ marginTop: 14, height: 6, borderRadius: 99, background: theme.surfaceAlt, overflow: 'hidden' }}>
              <div style={{ height: '100%', width: '38%', background: theme.primary, borderRadius: 99 }} />
            </div>
          )}
        </Card>
      </div>

      {/* Maintenances */}
      <div style={{ padding: '22px 22px 6px', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <h2 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 24 : 17, margin: 0,
        }}>{t.detail_maint_title}</h2>
        <button style={{ color: theme.primary, fontSize: 13, fontWeight: 600 }}>
          <Icon name="plus" size={14} sw={2.5} /> {lang === 'es' ? 'Añadir' : 'Add'}
        </button>
      </div>

      <div style={{ padding: '10px 18px 0', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {maint.map(m => (
          <Card key={m.id} theme={theme} pad={14}>
            <div style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
              <div style={{
                width: 38, height: 38, borderRadius: theme.radiusCard * 0.4,
                background: theme.primarySoft, color: theme.primary,
                display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
              }}>
                <Icon name="calendar" size={20} sw={1.8} />
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14.5, fontWeight: 600, color: theme.text }}>{m.name}</div>
                <div style={{ fontSize: 12.5, color: theme.textMuted, marginTop: 3 }}>{m.every} · {t.detail_maint_next} {daysLabel(m.days, t)}</div>
                <div style={{ marginTop: 12 }}>
                  <Btn theme={theme} variant="soft" size="sm" icon="check" onClick={() => onMarkDone(m)}>{t.detail_mark_done}</Btn>
                </div>
              </div>
              <StatusPill theme={theme} status={m.status} label={daysLabel(m.days, t)} />
            </div>
          </Card>
        ))}
      </div>

      {/* History */}
      <div style={{ padding: '22px 22px 6px' }}>
        <h2 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 24 : 17, margin: 0,
        }}>{t.detail_maint_history}</h2>
      </div>
      <div style={{ padding: '8px 22px 32px' }}>
        {history.map((h, i) => (
          <div key={i} style={{
            display: 'flex', alignItems: 'flex-start', gap: 14,
            padding: '12px 0', borderTop: i ? `1px solid ${theme.border}` : 'none',
          }}>
            <div style={{
              fontFamily: theme.fontMono, fontSize: 11.5, color: theme.textMuted,
              width: 78, paddingTop: 2,
            }}>{h.date}</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, color: theme.text, fontWeight: 500 }}>{h.what}</div>
              <div style={{ fontSize: 12, color: theme.textMuted, marginTop: 2 }}>{lang === 'es' ? 'por' : 'by'} {h.who}</div>
            </div>
            <div style={{ color: theme.ok }}>
              <Icon name="check-circle" size={18} sw={1.8} />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 5) ADD / EDIT ITEM
// ─────────────────────────────────────────────────────────────
function AddItemScreen({ theme, t, lang, go, gateRequired, onSave }) {
  const [name, setName] = React.useState('');
  const [brand, setBrand] = React.useState('');
  const [cat, setCat] = React.useState('kitchen');
  const cats = ['kitchen', 'bath', 'laundry', 'living', 'garden', 'garage', 'general'];
  const catLabel = {
    es: { kitchen: 'Cocina', bath: 'Baño', laundry: 'Lavandería', living: 'Salón', garden: 'Jardín', garage: 'Garaje', general: 'General' },
    en: { kitchen: 'Kitchen', bath: 'Bath', laundry: 'Laundry', living: 'Living', garden: 'Garden', garage: 'Garage', general: 'General' },
  };
  return (
    <div>
      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'center', padding: '8px 18px 12px', gap: 10 }}>
        <button onClick={() => go('items')} style={{
          width: 40, height: 40, borderRadius: 99,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icon name="arrow-left" size={22} sw={2} />
        </button>
        <h1 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 28 : 21, margin: 0, flex: 1,
        }}>{t.add_item_title}</h1>
      </div>

      <div style={{ padding: '0 22px 22px' }}>
        {/* Photo */}
        <div style={{ display: 'flex', gap: 12, marginBottom: 20 }}>
          <PhotoSlot theme={theme} label={t.add_photo} height={86} width={86} round={theme.radiusCard * 0.6} />
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: 6 }}>
            <Btn theme={theme} variant="soft" icon="camera" size="sm">{lang === 'es' ? 'Cámara' : 'Camera'}</Btn>
            <Btn theme={theme} variant="outline" size="sm">{lang === 'es' ? 'Galería' : 'Gallery'}</Btn>
          </div>
        </div>

        <FormField theme={theme} label={t.add_field_name}>
          <input type="text" placeholder={lang === 'es' ? 'Caldera, lavadora, coche…' : 'Boiler, washer, car…'}
            value={name} onChange={e => setName(e.target.value)}
            style={inputStyle(theme)} />
        </FormField>

        <FormField theme={theme} label={t.add_field_brand}>
          <input type="text" placeholder={lang === 'es' ? 'Vaillant ecoTEC plus' : 'Bosch Serie 6'}
            value={brand} onChange={e => setBrand(e.target.value)}
            style={inputStyle(theme)} />
        </FormField>

        <FormField theme={theme} label={t.add_field_category}>
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {cats.map(c => (
              <button key={c} onClick={() => setCat(c)} style={{
                display: 'flex', alignItems: 'center', gap: 6,
                padding: '8px 12px', borderRadius: theme.radiusChip,
                background: cat === c ? theme.primary : theme.surfaceAlt,
                color: cat === c ? theme.onPrimary : theme.text,
                fontSize: 13, fontWeight: 500,
              }}>
                <Icon name={`cat-${c}`} size={16} sw={1.8} />
                {catLabel[lang][c]}
              </button>
            ))}
          </div>
        </FormField>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          <FormField theme={theme} label={t.add_field_purchased}>
            <button style={{ ...inputStyle(theme), textAlign: 'left', display: 'flex', alignItems: 'center', gap: 8, color: theme.textMuted }}>
              <Icon name="calendar" size={16} sw={1.8} />
              <span style={{ fontFamily: theme.fontMono, fontSize: 13 }}>YYYY-MM-DD</span>
            </button>
          </FormField>
          <FormField theme={theme} label={t.add_field_warranty}>
            <input type="text" defaultValue="24" style={{ ...inputStyle(theme), fontFamily: theme.fontMono, textAlign: 'center' }} />
          </FormField>
        </div>

        <FormField theme={theme} label={t.add_field_notes}>
          <textarea placeholder={lang === 'es' ? 'Sala caldera, dejado en garantía hasta…' : 'Cellar, kept in warranty until…'}
            rows={2}
            style={{ ...inputStyle(theme), resize: 'none', minHeight: 60, padding: 12 }} />
        </FormField>
      </div>

      {/* Save bar */}
      <div style={{
        position: 'sticky', bottom: 0, padding: '14px 22px 22px',
        background: `linear-gradient(to top, ${theme.bg} 60%, transparent)`,
        display: 'flex', gap: 10,
      }}>
        <Btn theme={theme} variant="ghost" onClick={() => go('items')} full>{t.add_cancel}</Btn>
        <Btn theme={theme} onClick={() => gateRequired ? go('paywall') : onSave({ name, brand, cat })} full icon="check">
          {gateRequired ? (lang === 'es' ? 'Pro' : 'Pro') : t.add_save}
        </Btn>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 5b) ADD DOCUMENT
// ─────────────────────────────────────────────────────────────
function AddDocumentScreen({ theme, t, lang, go, gateRequired, onSave }) {
  const [kind, setKind] = React.useState('doc-id');
  const [name, setName] = React.useState('');
  const docTypes = [
    { id: 'doc-id', icon: 'doc-id', label: { es: 'DNI / Pasaporte', en: 'ID / Passport' } },
    { id: 'doc-car', icon: 'doc-car', label: { es: 'Coche / ITV', en: 'Car / MOT' } },
    { id: 'doc-house', icon: 'doc-house', label: { es: 'Hogar', en: 'Home' } },
    { id: 'doc-other', icon: 'file', label: { es: 'Otro', en: 'Other' } },
  ];
  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', padding: '8px 18px 12px', gap: 10 }}>
        <button onClick={() => go('docs')} style={{
          width: 40, height: 40, borderRadius: 99,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icon name="arrow-left" size={22} sw={2} />
        </button>
        <h1 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 28 : 21, margin: 0, flex: 1,
        }}>{lang === 'es' ? 'Nuevo documento' : 'New document'}</h1>
      </div>

      <div style={{ padding: '0 22px 22px' }}>
        <div style={{ display: 'flex', gap: 12, marginBottom: 20 }}>
          <PhotoSlot theme={theme} label={lang === 'es' ? 'escanear' : 'scan'} height={86} width={86} round={theme.radiusCard * 0.6} />
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: 6 }}>
            <Btn theme={theme} variant="soft" icon="camera" size="sm">{lang === 'es' ? 'Escanear' : 'Scan'}</Btn>
            <Btn theme={theme} variant="outline" size="sm">{lang === 'es' ? 'PDF / Galería' : 'PDF / Gallery'}</Btn>
          </div>
        </div>

        <FormField theme={theme} label={lang === 'es' ? 'TIPO DE DOCUMENTO' : 'DOCUMENT TYPE'}>
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {docTypes.map(d => (
              <button key={d.id} onClick={() => setKind(d.id)} style={{
                display: 'flex', alignItems: 'center', gap: 6,
                padding: '8px 12px', borderRadius: theme.radiusChip,
                background: kind === d.id ? theme.primary : theme.surfaceAlt,
                color: kind === d.id ? theme.onPrimary : theme.text,
                fontSize: 13, fontWeight: 500,
              }}>
                <Icon name={d.icon} size={16} sw={1.8} />
                {d.label[lang]}
              </button>
            ))}
          </div>
        </FormField>

        <FormField theme={theme} label={lang === 'es' ? 'NOMBRE' : 'NAME'}>
          <input type="text" placeholder={lang === 'es' ? 'Seguro del coche, DNI…' : 'Car insurance, ID…'}
            value={name} onChange={e => setName(e.target.value)}
            style={inputStyle(theme)} />
        </FormField>

        <FormField theme={theme} label={lang === 'es' ? 'FECHA DE CADUCIDAD' : 'EXPIRY DATE'}>
          <button style={{ ...inputStyle(theme), textAlign: 'left', display: 'flex', alignItems: 'center', gap: 8, color: theme.textMuted }}>
            <Icon name="calendar" size={16} sw={1.8} />
            <span style={{ fontFamily: theme.fontMono, fontSize: 13 }}>YYYY-MM-DD</span>
          </button>
        </FormField>

        <FormField theme={theme} label={lang === 'es' ? 'AVISARME' : 'REMIND ME'}>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            {['30', '15', '7', '1'].map((d, i) => (
              <button key={d} style={{
                padding: '6px 12px', borderRadius: theme.radiusChip,
                background: i < 2 ? theme.primarySoft : theme.surfaceAlt,
                color: i < 2 ? theme.primary : theme.textMuted,
                fontSize: 12.5, fontWeight: 600,
                border: i < 2 ? 'none' : `1px solid ${theme.border}`,
              }}>
                {d} {lang === 'es' ? 'd. antes' : 'd before'}
              </button>
            ))}
          </div>
        </FormField>

        <FormField theme={theme} label={lang === 'es' ? 'NOTAS' : 'NOTES'}>
          <textarea placeholder={lang === 'es' ? 'Número de póliza, contacto…' : 'Policy number, contact…'}
            rows={2}
            style={{ ...inputStyle(theme), resize: 'none', minHeight: 60, padding: 12 }} />
        </FormField>
      </div>

      <div style={{
        position: 'sticky', bottom: 0, padding: '14px 22px 22px',
        background: `linear-gradient(to top, ${theme.bg} 60%, transparent)`,
        display: 'flex', gap: 10,
      }}>
        <Btn theme={theme} variant="ghost" onClick={() => go('docs')} full>{t.add_cancel}</Btn>
        <Btn theme={theme} onClick={() => gateRequired ? go('paywall') : onSave({ name, kind })} full icon="check">
          {gateRequired ? 'Pro' : t.add_save}
        </Btn>
      </div>
    </div>
  );
}

function FormField({ theme, label, children }) {
  return (
    <div style={{ marginBottom: 14 }}>
      <label style={{
        display: 'block', fontSize: 12.5, fontWeight: 600,
        color: theme.textMuted, marginBottom: 7, letterSpacing: 0.2,
        textTransform: theme.name === 'Editorial' ? 'uppercase' : 'none',
      }}>{label}</label>
      {children}
    </div>
  );
}

function inputStyle(theme) {
  return {
    width: '100%', padding: '12px 14px', borderRadius: theme.radiusBtn,
    background: theme.surface, color: theme.text,
    border: `1px solid ${theme.border}`,
    fontSize: 15, outline: 'none',
    fontFamily: theme.fontBody,
  };
}

// ─────────────────────────────────────────────────────────────
// 6) DOCUMENTS LIST
// ─────────────────────────────────────────────────────────────
function DocumentsScreen({ theme, t, lang, docs, plan, go }) {
  if (docs.length === 0) {
    return (
      <div style={{ padding: '24px 22px 100px' }}>
        <h1 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 36 : 26, margin: '0 0 20px',
        }}>{t.docs_title}</h1>
        <Card theme={theme} pad={32} style={{ textAlign: 'center' }}>
          <div style={{ marginBottom: 16, color: theme.primary }}><Icon name="file" size={48} sw={1.4} /></div>
          <div style={{ fontSize: 17, fontWeight: 600, color: theme.text, marginBottom: 6 }}>{t.docs_empty}</div>
          <div style={{ fontSize: 13, color: theme.textMuted, marginBottom: 20, textWrap: 'pretty' }}>{t.docs_empty_sub}</div>
          <Btn theme={theme} icon="plus" onClick={() => go('add')}>{t.docs_add}</Btn>
        </Card>
      </div>
    );
  }

  // Group by urgency
  const expired = docs.filter(d => d.status === 'overdue');
  const soon = docs.filter(d => d.status === 'soon');
  const ok = docs.filter(d => d.status === 'ok');

  return (
    <div style={{ paddingBottom: 100 }}>
      <div style={{ padding: '12px 22px 16px', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <h1 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 36 : 26, margin: 0,
        }}>{t.docs_title}</h1>
        <div style={{ fontSize: 13, color: theme.textMuted, fontFamily: theme.fontMono }}>
          {plan === 'free' ? `${docs.length}/3` : `${docs.length}`}
        </div>
      </div>
      {expired.length > 0 && <DocSection theme={theme} title={t.docs_section_expired} tone="danger" docs={expired} t={t} lang={lang} />}
      {soon.length > 0 && <DocSection theme={theme} title={t.docs_section_soon} tone="warn" docs={soon} t={t} lang={lang} />}
      {ok.length > 0 && <DocSection theme={theme} title={t.docs_section_ok} tone="ok" docs={ok} t={t} lang={lang} />}
    </div>
  );
}

function DocSection({ theme, title, tone, docs, t, lang }) {
  const pal = tone === 'danger' ? theme.danger : tone === 'warn' ? theme.warn : theme.ok;
  return (
    <div style={{ padding: '8px 0 18px' }}>
      <div style={{ padding: '0 22px 8px', display: 'flex', alignItems: 'center', gap: 8 }}>
        <span style={{ width: 8, height: 8, borderRadius: 99, background: pal }} />
        <h2 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 22 : 14.5, margin: 0,
          textTransform: theme.name === 'Editorial' ? 'none' : 'uppercase',
          letterSpacing: theme.name === 'Editorial' ? 0 : 0.6,
          color: theme.textMuted,
        }}>{title}</h2>
        <span style={{ fontSize: 12, color: theme.textFaint, fontFamily: theme.fontMono }}>{docs.length}</span>
      </div>
      <div style={{ padding: '0 18px', display: 'flex', flexDirection: 'column', gap: 8 }}>
        {docs.map(d => <DocCard key={d.id} theme={theme} doc={d} t={t} lang={lang} />)}
      </div>
    </div>
  );
}

function DocCard({ theme, doc, t, lang }) {
  return (
    <div style={{
      display: 'flex', gap: 14, padding: 14,
      background: theme.surface, borderRadius: theme.radiusCard,
      boxShadow: theme.cardShadow,
      border: theme.name === 'Editorial' ? `1px solid ${theme.border}` : 'none',
      alignItems: 'center',
    }}>
      <div style={{
        width: 48, height: 48, borderRadius: theme.radiusCard * 0.5,
        background: theme.primarySoft, color: theme.primary,
        display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
      }}>
        <Icon name={doc.kind} size={24} sw={1.7} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 15, fontWeight: 600, color: theme.text, fontFamily: theme.fontDisplay }}>{doc.name[lang]}</div>
        <div style={{ fontSize: 12.5, color: theme.textMuted, marginTop: 2, fontFamily: theme.fontMono }}>{doc.expires}</div>
      </div>
      <StatusPill theme={theme} status={doc.status} label={daysLabel(doc.days, t)} />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 7) MARK MAINTENANCE DONE — modal sheet
// ─────────────────────────────────────────────────────────────
function MarkDoneSheet({ theme, t, lang, maint, onConfirm, onClose }) {
  const [when, setWhen] = React.useState('today');
  const [confirmed, setConfirmed] = React.useState(false);

  if (!maint) return null;

  const handleConfirm = () => {
    setConfirmed(true);
    setTimeout(() => { onConfirm(); }, 1200);
  };

  return (
    <div style={{
      position: 'absolute', inset: 0, background: 'rgba(0,0,0,0.4)',
      display: 'flex', alignItems: 'flex-end', zIndex: 20,
    }} onClick={onClose}>
      <div onClick={e => e.stopPropagation()} style={{
        width: '100%', background: theme.surface,
        borderTopLeftRadius: 28, borderTopRightRadius: 28,
        padding: '8px 22px 26px',
        animation: 'sheetIn .25s ease-out',
      }}>
        {/* drag handle */}
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 14 }}>
          <div style={{ width: 40, height: 4, borderRadius: 99, background: theme.border }} />
        </div>

        {confirmed ? (
          <div style={{ textAlign: 'center', padding: '30px 10px' }}>
            <div style={{
              width: 72, height: 72, borderRadius: 99,
              background: theme.okSoft, color: theme.ok,
              display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
              marginBottom: 18,
              animation: 'pop .35s cubic-bezier(.34,1.5,.64,1)',
            }}>
              <Icon name="check" size={36} sw={2.8} />
            </div>
            <h2 style={{
              fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
              fontSize: theme.name === 'Editorial' ? 28 : 22, margin: 0,
            }}>{lang === 'es' ? '¡Hecho!' : 'Done!'}</h2>
            <p style={{ color: theme.textMuted, fontSize: 14, marginTop: 8 }}>
              {lang === 'es' ? 'Próximo aviso en 365 días' : 'Next reminder in 365 days'}
            </p>
          </div>
        ) : (
          <>
            <h2 style={{
              fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
              fontSize: theme.name === 'Editorial' ? 28 : 22, margin: 0,
            }}>{t.maint_title}</h2>
            <div style={{ fontSize: 14, color: theme.textMuted, marginTop: 4, marginBottom: 18 }}>
              {maint.name}
            </div>

            <div style={{ fontSize: 12.5, color: theme.textMuted, fontWeight: 600, marginBottom: 8, letterSpacing: 0.3 }}>{t.maint_when}</div>
            <div style={{ display: 'flex', gap: 8, marginBottom: 18 }}>
              {[{ k: 'today', l: t.maint_today }, { k: 'yesterday', l: t.maint_yesterday }, { k: 'other', l: t.maint_other }].map(opt => (
                <button key={opt.k} onClick={() => setWhen(opt.k)} style={{
                  flex: 1, padding: '12px 8px', borderRadius: theme.radiusBtn,
                  background: when === opt.k ? theme.primary : theme.surfaceAlt,
                  color: when === opt.k ? theme.onPrimary : theme.text,
                  fontWeight: 600, fontSize: 13,
                  border: when === opt.k ? 'none' : `1px solid ${theme.border}`,
                }}>{opt.l}</button>
              ))}
            </div>

            <div style={{ fontSize: 12.5, color: theme.textMuted, fontWeight: 600, marginBottom: 8, letterSpacing: 0.3 }}>{t.maint_notes_opt}</div>
            <textarea rows={2} placeholder={lang === 'es' ? 'p.ej. cambié pieza X' : 'e.g. replaced part X'}
              style={{ ...inputStyle(theme), resize: 'none', marginBottom: 18 }} />

            <div style={{ background: theme.primarySoft, borderRadius: theme.radiusBtn, padding: 12, display: 'flex', alignItems: 'center', gap: 10, marginBottom: 18, color: theme.primary }}>
              <Icon name="bell" size={18} />
              <div style={{ fontSize: 12.5, flex: 1 }}>
                <b>{t.maint_next}:</b> {lang === 'es' ? 'en 12 meses' : 'in 12 months'}
              </div>
            </div>

            <Btn theme={theme} full size="lg" icon="check" onClick={handleConfirm}>{t.maint_confirm}</Btn>
          </>
        )}
      </div>
      <style>{`
        @keyframes sheetIn { from { transform: translateY(100%); } to { transform: translateY(0); } }
        @keyframes pop { from { transform: scale(0.4); opacity: 0; } to { transform: scale(1); opacity: 1; } }
      `}</style>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 8) PAYWALL
// ─────────────────────────────────────────────────────────────
function PaywallScreen({ theme, t, lang, gate, go, onUpgrade }) {
  const benefits = [
    { icon: 'box', text: t.paywall_b1 },
    { icon: 'bell', text: t.paywall_b2 },
    { icon: 'sparkle', text: t.paywall_b3 },
    { icon: 'share', text: t.paywall_b4 },
    { icon: 'cat-garden', text: t.paywall_b5 },
  ];
  return (
    <div style={{ minHeight: '100%', display: 'flex', flexDirection: 'column', position: 'relative' }}>
      {/* Hero band */}
      <div style={{
        padding: '18px 22px 36px',
        background: theme.name === 'Editorial' ? theme.surfaceAlt
          : `linear-gradient(160deg, ${theme.primary}, ${theme.primary} 50%, ${theme.accent})`,
        color: theme.name === 'Editorial' ? theme.text : '#fff',
      }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 22 }}>
          <button onClick={() => go('items')} style={{
            width: 36, height: 36, borderRadius: 99,
            background: theme.name === 'Editorial' ? theme.surface : 'rgba(255,255,255,0.18)',
            color: 'inherit', display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}><Icon name="arrow-left" size={20} sw={2} /></button>
          <div style={{
            background: theme.name === 'Editorial' ? theme.accent : 'rgba(255,255,255,0.18)',
            color: theme.name === 'Editorial' ? '#fff' : '#fff',
            padding: '4px 10px', borderRadius: 99, fontSize: 11, fontWeight: 700, letterSpacing: 0.5,
          }}>PRO</div>
        </div>

        {gate && (
          <div style={{
            background: theme.name === 'Editorial' ? theme.accentSoft : 'rgba(255,255,255,0.15)',
            color: theme.name === 'Editorial' ? theme.accent : '#fff',
            padding: '10px 14px', borderRadius: theme.radiusBtn, fontSize: 13, marginBottom: 16,
            display: 'flex', alignItems: 'center', gap: 10,
          }}>
            <Icon name="lock" size={16} sw={2} />
            <div>
              <div style={{ fontWeight: 700 }}>{t.paywall_gate}</div>
              <div style={{ opacity: 0.85, marginTop: 2, fontSize: 12 }}>{t.paywall_gate_sub}</div>
            </div>
          </div>
        )}

        <h1 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 42 : 32, lineHeight: 1.05, margin: 0,
          textWrap: 'balance',
        }}>{t.paywall_title}</h1>
        <p style={{ opacity: 0.85, fontSize: 15, marginTop: 8 }}>{t.paywall_sub}</p>

        {/* Price */}
        <div style={{ marginTop: 22, display: 'flex', alignItems: 'baseline', gap: 8 }}>
          <span style={{
            fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
            fontSize: theme.name === 'Editorial' ? 52 : 44,
          }}>{t.paywall_price}</span>
          <span style={{ opacity: 0.85, fontSize: 14 }}>· {t.paywall_once}</span>
        </div>
      </div>

      {/* Benefits */}
      <div style={{ padding: '22px 22px 8px', flex: 1 }}>
        {benefits.map((b, i) => (
          <div key={i} style={{ display: 'flex', gap: 14, padding: '12px 0', alignItems: 'flex-start' }}>
            <div style={{
              width: 36, height: 36, borderRadius: theme.radiusCard * 0.45,
              background: theme.primarySoft, color: theme.primary,
              display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
            }}>
              <Icon name={b.icon} size={18} sw={1.8} />
            </div>
            <div style={{ flex: 1, paddingTop: 6 }}>
              <div style={{ fontSize: 14.5, color: theme.text, fontWeight: 500, lineHeight: 1.4 }}>{b.text}</div>
            </div>
            <div style={{ color: theme.ok, paddingTop: 6 }}>
              <Icon name="check" size={18} sw={2.2} />
            </div>
          </div>
        ))}
      </div>

      {/* CTA bar */}
      <div style={{
        padding: '14px 22px 22px',
        background: theme.bg,
        borderTop: `1px solid ${theme.border}`,
        display: 'flex', flexDirection: 'column', gap: 10,
      }}>
        <Btn theme={theme} full size="lg" icon="sparkle" onClick={() => { onUpgrade(); }}>{t.paywall_cta}</Btn>
        <div style={{ display: 'flex', justifyContent: 'space-between', padding: '0 4px' }}>
          <button style={{ color: theme.textMuted, fontSize: 12.5 }}>{t.paywall_restore}</button>
          <button onClick={() => go('items')} style={{ color: theme.textMuted, fontSize: 12.5 }}>{t.paywall_skip}</button>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 9) SETTINGS
// ─────────────────────────────────────────────────────────────
function SettingsScreen({ theme, t, lang, plan, go, dark, onToggleLang, onToggleDark }) {
  return (
    <div style={{ paddingBottom: 100 }}>
      <div style={{ padding: '14px 22px 18px' }}>
        <h1 style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: theme.name === 'Editorial' ? 36 : 26, margin: 0,
        }}>{t.settings_title}</h1>
      </div>

      {/* Plan card */}
      <div style={{ padding: '0 18px 18px' }}>
        <Card theme={theme} pad={18} style={
          plan === 'pro'
            ? { background: theme.name === 'Editorial' ? theme.surfaceAlt : `linear-gradient(135deg, ${theme.primary}, ${theme.accent})`,
                color: theme.name === 'Editorial' ? theme.text : '#fff', border: 'none' }
            : {}
        }>
          <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
            <div style={{
              width: 48, height: 48, borderRadius: theme.radiusCard * 0.5,
              background: plan === 'pro'
                ? (theme.name === 'Editorial' ? theme.accent : 'rgba(255,255,255,0.18)')
                : theme.primarySoft,
              color: plan === 'pro' ? '#fff' : theme.primary,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Icon name="sparkle" size={22} />
            </div>
            <div style={{ flex: 1 }}>
              <div style={{
                fontSize: 16, fontWeight: 700, fontFamily: theme.fontDisplay,
                color: plan === 'pro' ? (theme.name === 'Editorial' ? theme.text : '#fff') : theme.text,
              }}>{plan === 'pro' ? t.settings_plan_pro : t.settings_plan_free}</div>
              <div style={{
                fontSize: 12.5, marginTop: 2,
                color: plan === 'pro' ? (theme.name === 'Editorial' ? theme.textMuted : 'rgba(255,255,255,0.85)') : theme.textMuted,
              }}>{plan === 'pro'
                ? (lang === 'es' ? 'Todas las funciones desbloqueadas' : 'All features unlocked')
                : (lang === 'es' ? '5 cosas · 3 documentos' : '5 things · 3 documents')}</div>
            </div>
            {plan === 'free' ? (
              <Btn theme={theme} variant="accent" size="sm" onClick={() => go('paywall')}>{t.settings_upgrade}</Btn>
            ) : (
              <span style={{
                background: theme.name === 'Editorial' ? theme.accent : 'rgba(255,255,255,0.25)',
                color: '#fff', padding: '5px 10px', borderRadius: 99, fontSize: 11, fontWeight: 700, letterSpacing: 0.4,
              }}>{t.settings_pro_badge}</span>
            )}
          </div>
        </Card>
      </div>

      <SettingsSection theme={theme} title={t.settings_notifs}>
        <SettingsRow theme={theme} icon="bell" label={t.settings_notifs_on} value={<Toggle theme={theme} on={true} />} />
        <SettingsRow theme={theme} icon="calendar" label={t.settings_notifs_lead} value={
          <span style={{ color: theme.textMuted, fontFamily: theme.fontMono, fontSize: 13 }}>30 · 7 · 1</span>
        } />
      </SettingsSection>

      <SettingsSection theme={theme} title={t.settings_pref}>
        <SettingsRow theme={theme} icon="globe" label={t.settings_lang} value={
          <button onClick={onToggleLang} style={{
            display: 'flex', gap: 4, background: theme.surfaceAlt, padding: '4px', borderRadius: 99,
          }}>
            {['es','en'].map(l => (
              <span key={l} style={{
                padding: '4px 10px', borderRadius: 99,
                background: lang === l ? theme.primary : 'transparent',
                color: lang === l ? theme.onPrimary : theme.textMuted,
                fontWeight: 600, fontSize: 12, textTransform: 'uppercase', letterSpacing: 0.5,
              }}>{l}</span>
            ))}
          </button>
        } />
        <SettingsRow theme={theme} icon={dark ? 'moon' : 'sun'} label={t.settings_theme} value={
          <Toggle theme={theme} on={dark} onClick={onToggleDark} />
        } />
      </SettingsSection>

      <SettingsSection theme={theme} title={lang === 'es' ? 'Información' : 'Info'}>
        <SettingsRow theme={theme} icon="file" label={t.settings_about} value={
          <span style={{ color: theme.textFaint, fontFamily: theme.fontMono, fontSize: 12 }}>v1.0.0</span>
        } />
        <SettingsRow theme={theme} icon="lock" label={t.settings_privacy} chevron />
        <SettingsRow theme={theme} icon="share" label={t.settings_contact} chevron />
      </SettingsSection>

      <div style={{ textAlign: 'center', padding: '12px 22px 24px', color: theme.textFaint, fontSize: 11, fontFamily: theme.fontMono }}>
        HOUSEKEEP · MADE WITH CARE
      </div>
    </div>
  );
}

function SettingsSection({ theme, title, children }) {
  return (
    <div style={{ padding: '0 0 18px' }}>
      <div style={{
        padding: '6px 22px 6px', fontSize: 11.5, fontWeight: 700,
        color: theme.textMuted, letterSpacing: 0.7, textTransform: 'uppercase',
      }}>{title}</div>
      <div style={{ padding: '0 18px' }}>
        <Card theme={theme} pad={0}>
          {children}
        </Card>
      </div>
    </div>
  );
}

function SettingsRow({ theme, icon, label, value, chevron }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 14, padding: '14px 16px',
      borderBottom: `1px solid ${theme.border}`,
    }}>
      <div style={{
        width: 32, height: 32, borderRadius: theme.radiusCard * 0.4,
        background: theme.primarySoft, color: theme.primary,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}><Icon name={icon} size={16} sw={1.8} /></div>
      <div style={{ flex: 1, fontSize: 14.5, color: theme.text, fontWeight: 500 }}>{label}</div>
      {value}
      {chevron && <Icon name="chevron-right" size={16} stroke={theme.textFaint} sw={1.8} />}
    </div>
  );
}

function Toggle({ theme, on, onClick }) {
  return (
    <button onClick={onClick} style={{
      width: 44, height: 26, borderRadius: 99,
      background: on ? theme.primary : theme.border,
      position: 'relative', transition: 'background .2s',
    }}>
      <div style={{
        position: 'absolute', top: 3, left: on ? 21 : 3,
        width: 20, height: 20, borderRadius: 99,
        background: '#fff', boxShadow: '0 1px 3px rgba(0,0,0,0.2)', transition: 'left .2s',
      }} />
    </button>
  );
}

// ─────────────────────────────────────────────────────────────
// 10) WIDGET — Android home-screen widget prototype, 3 sizes
// ─────────────────────────────────────────────────────────────
function WidgetScreen({ theme, t, lang, items, docs, dark }) {
  const upcoming = makeUpcoming(items, docs, t, lang);
  const dueCount = upcoming.filter(u => u.status === 'overdue' || u.status === 'due').length;
  const soonCount = upcoming.filter(u => u.status === 'soon').length;

  // Stylized Android launcher background — soft mesh
  const wallpaper = dark
    ? 'radial-gradient(at 20% 20%, #1a3540 0%, #0a0e15 60%), radial-gradient(at 80% 80%, #2a1f3a 0%, transparent 60%)'
    : 'linear-gradient(160deg, #cfd8d3 0%, #d8c9b4 50%, #e8c4a8 100%)';

  return (
    <div style={{
      minHeight: '100%',
      background: wallpaper,
      padding: '20px 16px 110px',
      display: 'flex', flexDirection: 'column', gap: 16,
      position: 'relative',
    }}>
      {/* Clock / launcher widget cluster */}
      <div style={{ paddingTop: 6, textAlign: 'center', color: dark ? '#fff' : '#1a1a1a' }}>
        <div style={{
          fontFamily: theme.fontDisplay, fontWeight: 200, fontSize: 64, lineHeight: 1,
          letterSpacing: -2,
        }}>9:41</div>
        <div style={{ fontSize: 13, opacity: 0.75, marginTop: 4, fontWeight: 500 }}>
          {lang === 'es' ? 'Martes, 27 de mayo' : 'Tuesday, May 27'}
        </div>
      </div>

      {/* Picker label */}
      <div style={{
        fontSize: 10.5, fontWeight: 700, letterSpacing: 1, textTransform: 'uppercase',
        color: dark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.55)',
        textAlign: 'center', marginTop: -4,
      }}>{lang === 'es' ? 'Widgets de HouseKeep' : 'HouseKeep widgets'}</div>

      {/* 4x2 — the recommended one */}
      <Widget4x2 theme={theme} t={t} lang={lang} upcoming={upcoming} dueCount={dueCount} soonCount={soonCount} />

      {/* Row with 2x2 + 2x2 */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
        <Widget2x2Counts theme={theme} t={t} lang={lang} dueCount={dueCount} soonCount={soonCount} />
        <Widget2x2Next theme={theme} t={t} lang={lang} upcoming={upcoming} />
      </div>

      {/* App row at bottom — sells the "tap to open" idea */}
      <div style={{
        marginTop: 'auto', padding: '0 14px',
        display: 'flex', justifyContent: 'space-around',
      }}>
        {['Phone', 'HouseKeep', 'Camera', 'Messages'].map((name, i) => (
          <div key={i} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6 }}>
            <div style={{
              width: 48, height: 48, borderRadius: 14,
              background: name === 'HouseKeep' ? theme.primary : 'rgba(0,0,0,0.18)',
              backdropFilter: 'blur(8px)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              color: '#fff',
              boxShadow: name === 'HouseKeep' ? '0 4px 12px rgba(0,0,0,0.18)' : 'none',
            }}>
              {name === 'HouseKeep' && <Icon name="home" size={26} sw={2} stroke="#fff" />}
            </div>
            <div style={{
              fontSize: 10.5, color: dark ? '#fff' : '#1a1a1a',
              fontWeight: 500, opacity: 0.85,
            }}>{name}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

// 4×2 — Hero widget: next item + 2 micro-rows
function Widget4x2({ theme, t, lang, upcoming, dueCount, soonCount }) {
  const next = upcoming[0];
  const more = upcoming.slice(1, 3);
  return (
    <div style={{
      borderRadius: 28,
      background: theme.surface,
      padding: 14,
      boxShadow: '0 4px 16px rgba(0,0,0,0.10)',
      display: 'flex', flexDirection: 'column', gap: 10,
    }}>
      {/* Top row: branding + counts */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <div style={{
          width: 22, height: 22, borderRadius: 7, background: theme.primary, color: '#fff',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icon name="home" size={13} sw={2.4} stroke="#fff" />
        </div>
        <div style={{
          fontSize: 12.5, fontWeight: 700, color: theme.text, letterSpacing: -0.1,
          fontFamily: theme.fontDisplay,
        }}>HouseKeep</div>
        <div style={{ flex: 1 }} />
        {dueCount > 0 && (
          <span style={{
            background: theme.dangerSoft, color: theme.danger,
            fontSize: 10.5, fontWeight: 700, padding: '2px 8px', borderRadius: 99,
          }}>{dueCount} {lang === 'es' ? 'pendiente' + (dueCount === 1 ? '' : 's') : 'due'}</span>
        )}
        {soonCount > 0 && (
          <span style={{
            background: theme.warnSoft, color: theme.warn,
            fontSize: 10.5, fontWeight: 700, padding: '2px 8px', borderRadius: 99,
          }}>{soonCount} {lang === 'es' ? 'pronto' : 'soon'}</span>
        )}
      </div>

      {/* Hero next item */}
      {next && (
        <div style={{
          display: 'flex', alignItems: 'center', gap: 12,
          padding: '8px 0',
        }}>
          {next.kind === 'maint'
            ? <CategoryTile theme={theme} category={next.cat} size={44} />
            : <div style={{
                width: 44, height: 44, borderRadius: 12,
                background: theme.primarySoft, color: theme.primary,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}><Icon name={next.docKind} size={22} sw={1.7} /></div>
          }
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{
              fontSize: 14, fontWeight: 600, color: theme.text,
              overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
              fontFamily: theme.fontDisplay,
            }}>{next.title}</div>
            <div style={{
              fontSize: 11.5, color: theme.textMuted, marginTop: 1,
              overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
            }}>{next.sub}</div>
          </div>
          <StatusPill theme={theme} status={next.status} label={daysLabel(next.days, t)} />
        </div>
      )}

      {/* Two micro rows */}
      {more.length > 0 && (
        <div style={{
          paddingTop: 8, borderTop: `1px solid ${theme.border}`,
          display: 'flex', flexDirection: 'column', gap: 6,
        }}>
          {more.map(m => (
            <div key={m.id} style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <span style={{
                width: 6, height: 6, borderRadius: 99,
                background: m.status === 'overdue' || m.status === 'due' ? theme.danger
                  : m.status === 'soon' ? theme.warn : theme.ok,
                flexShrink: 0,
              }} />
              <span style={{
                fontSize: 12, color: theme.text, fontWeight: 500,
                overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', flex: 1,
              }}>{m.title}</span>
              <span style={{ fontSize: 11, color: theme.textMuted, fontFamily: theme.fontMono }}>
                {daysLabel(m.days, t)}
              </span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

// 2×2 — just the counts
function Widget2x2Counts({ theme, t, lang, dueCount, soonCount }) {
  return (
    <div style={{
      borderRadius: 24, background: theme.surface,
      padding: 14, boxShadow: '0 4px 16px rgba(0,0,0,0.10)',
      display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
      minHeight: 130,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
        <div style={{
          width: 18, height: 18, borderRadius: 5, background: theme.primary, color: '#fff',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icon name="home" size={11} sw={2.4} stroke="#fff" />
        </div>
        <div style={{ fontSize: 10.5, fontWeight: 700, color: theme.textMuted, letterSpacing: 0.3 }}>HouseKeep</div>
      </div>
      <div>
        <div style={{
          fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
          fontSize: 44, lineHeight: 1, color: dueCount > 0 ? theme.danger : theme.ok,
        }}>{dueCount}</div>
        <div style={{ fontSize: 11.5, color: theme.textMuted, fontWeight: 600, marginTop: 4 }}>
          {dueCount === 0 ? (lang === 'es' ? 'Todo al día' : 'All caught up') : (lang === 'es' ? (dueCount === 1 ? 'cosa pendiente' : 'cosas pendientes') : (dueCount === 1 ? 'thing due' : 'things due'))}
        </div>
        {soonCount > 0 && (
          <div style={{
            fontSize: 11, color: theme.warn, fontWeight: 600, marginTop: 6,
            display: 'flex', alignItems: 'center', gap: 4,
          }}>
            <span style={{ width: 5, height: 5, borderRadius: 99, background: theme.warn }} />
            {soonCount} {lang === 'es' ? 'esta semana' : 'this week'}
          </div>
        )}
      </div>
    </div>
  );
}

// 2×2 — next single event, image-forward
function Widget2x2Next({ theme, t, lang, upcoming }) {
  const next = upcoming[0];
  if (!next) return null;
  return (
    <div style={{
      borderRadius: 24, background: theme.surface,
      padding: 14, boxShadow: '0 4px 16px rgba(0,0,0,0.10)',
      display: 'flex', flexDirection: 'column', minHeight: 130,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 8 }}>
        {next.kind === 'maint'
          ? <CategoryTile theme={theme} category={next.cat} size={28} />
          : <div style={{
              width: 28, height: 28, borderRadius: 8,
              background: theme.primarySoft, color: theme.primary,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}><Icon name={next.docKind} size={16} sw={1.7} /></div>
        }
        <div style={{ fontSize: 10, fontWeight: 700, color: theme.textMuted, letterSpacing: 0.4, textTransform: 'uppercase' }}>
          {lang === 'es' ? 'Próximo' : 'Up next'}
        </div>
      </div>
      <div style={{
        fontFamily: theme.fontDisplay, fontWeight: theme.displayWeight,
        fontSize: 16, lineHeight: 1.15, color: theme.text,
        overflow: 'hidden', display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical',
      }}>{next.title}</div>
      <div style={{ fontSize: 11, color: theme.textMuted, marginTop: 2,
        overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
      }}>{next.sub}</div>
      <div style={{ flex: 1 }} />
      <StatusPill theme={theme} status={next.status} label={daysLabel(next.days, t)} />
    </div>
  );
}

Object.assign(window, {
  makeItems, makeDocs, makeUpcoming, daysLabel,
  TabBar, FAB,
  OnboardingScreen, HomeScreen, ItemsScreen, ItemDetail, AddItemScreen, AddDocumentScreen,
  DocumentsScreen, MarkDoneSheet, PaywallScreen, SettingsScreen, WidgetScreen,
});

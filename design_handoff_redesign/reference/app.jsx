// app.jsx — HouseKeep prototype root

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "direction": "cozy",
  "language": "es",
  "plan": "free",
  "state": "populated",
  "dark": false,
  "screen": "onboarding"
}/*EDITMODE-END*/;

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  const theme = React.useMemo(() => getTheme(t.direction, t.dark), [t.direction, t.dark]);
  const strings = STRINGS[t.language];

  // App state
  const [screen, setScreen] = React.useState(t.screen);
  const [openItem, setOpenItem] = React.useState(null);
  const [items, setItems] = React.useState(makeItems());
  const [docs, setDocs] = React.useState(makeDocs());
  const [markDone, setMarkDone] = React.useState(null);
  const [paywallGate, setPaywallGate] = React.useState(false);

  // Reset items/docs when state tweak changes
  React.useEffect(() => {
    if (t.state === 'empty') {
      setItems([]); setDocs([]);
    } else {
      setItems(makeItems()); setDocs(makeDocs());
    }
  }, [t.state]);

  // Sync screen <- tweak (allow user to jump via panel)
  React.useEffect(() => { setScreen(t.screen); }, [t.screen]);

  // Push screen up so tweak panel reflects it
  const go = (s) => {
    if (s.startsWith('item:')) {
      setOpenItem(s.slice(5));
      setScreen('detail');
      setTweak('screen', 'detail');
    } else if (s === 'add') {
      // gate check on free plan with 5+ items
      if (t.plan === 'free' && items.length >= 5) {
        setPaywallGate(true);
        setScreen('paywall');
        setTweak('screen', 'paywall');
      } else {
        setScreen('add');
        setTweak('screen', 'add');
      }
    } else {
      setScreen(s);
      setTweak('screen', s);
    }
  };

  const tabFor = (s) => ({ home: 'home', items: 'items', docs: 'docs', settings: 'settings' }[s] || (s === 'detail' || s === 'add' ? 'items' : 'home'));

  const activeItem = items.find(i => i.id === openItem) || items[0];

  // Screens that DON'T show the tab bar
  const hideTabs = ['onboarding', 'add', 'paywall', 'detail'].includes(screen);
  const showFAB = ['home', 'items', 'docs'].includes(screen) && t.state !== 'empty';

  let body = null;
  switch (screen) {
    case 'onboarding':
      body = <OnboardingScreen theme={theme} t={strings} lang={t.language} go={go} />; break;
    case 'home':
      body = <HomeScreen theme={theme} t={strings} lang={t.language} items={items} docs={docs} empty={t.state === 'empty'} plan={t.plan} go={go} onAdd={() => go('add')} />; break;
    case 'items':
      body = <ItemsScreen theme={theme} t={strings} lang={t.language} items={items} plan={t.plan} go={go} />; break;
    case 'detail':
      body = <ItemDetail theme={theme} t={strings} lang={t.language} item={activeItem} go={go}
              onMarkDone={(m) => setMarkDone({ ...m, itemId: activeItem.id })} />; break;
    case 'add':
      body = <AddItemScreen theme={theme} t={strings} lang={t.language} go={go}
              gateRequired={t.plan === 'free' && items.length >= 5}
              onSave={(it) => { setItems([...items, { id: 'new', name: { es: it.name || 'Sin nombre', en: it.name || 'Untitled' }, brand: it.brand, cat: it.cat, purchased: '2026-05-26', warrantyM: 24, nextMaint: 'Revisión', nextDays: 365, status: 'ok' }]); go('items'); }} />; break;
    case 'docs':
      body = <DocumentsScreen theme={theme} t={strings} lang={t.language} docs={docs} plan={t.plan} go={go} />; break;
    case 'paywall':
      body = <PaywallScreen theme={theme} t={strings} lang={t.language} gate={paywallGate} go={(s) => { setPaywallGate(false); go(s); }}
              onUpgrade={() => { setTweak('plan', 'pro'); setPaywallGate(false); go('home'); }} />; break;
    case 'settings':
      body = <SettingsScreen theme={theme} t={strings} lang={t.language} plan={t.plan} go={go} dark={t.dark}
              onToggleLang={() => setTweak('language', t.language === 'es' ? 'en' : 'es')}
              onToggleDark={() => setTweak('dark', !t.dark)} />; break;
    default:
      body = <HomeScreen theme={theme} t={strings} lang={t.language} items={items} docs={docs} empty={false} plan={t.plan} go={go} onAdd={() => go('add')} />;
  }

  return (
    <>
      <Phone theme={theme} dark={t.dark}>
        {body}
        {showFAB && !hideTabs && <FAB theme={theme} onClick={() => go('add')} />}
        {!hideTabs && <TabBar theme={theme} current={tabFor(screen)} onNav={go} t={strings} />}
        {markDone && (
          <MarkDoneSheet theme={theme} t={strings} lang={t.language}
            maint={markDone}
            onConfirm={() => { setMarkDone(null); }}
            onClose={() => setMarkDone(null)} />
        )}
      </Phone>

      <TweaksPanel title="Tweaks">
        <TweakSection label="Visual direction" />
        <TweakRadio value={t.direction} options={[
          { value: 'cozy', label: 'Cozy' },
          { value: 'editorial', label: 'Editorial' },
          { value: 'vibrant', label: 'Vibrant' },
        ]} onChange={(v) => setTweak('direction', v)} />

        <TweakSection label="State" />
        <TweakRadio label="Plan" value={t.plan} options={['free', 'pro']} onChange={(v) => setTweak('plan', v)} />
        <TweakRadio label="Library" value={t.state} options={['populated', 'empty']} onChange={(v) => setTweak('state', v)} />
        <TweakToggle label="Dark mode" value={t.dark} onChange={(v) => setTweak('dark', v)} />
        <TweakRadio label="Language" value={t.language} options={['es', 'en']} onChange={(v) => setTweak('language', v)} />

        <TweakSection label="Jump to screen" />
        <TweakSelect value={t.screen} options={[
          { value: 'onboarding', label: 'Onboarding' },
          { value: 'home', label: 'Home dashboard' },
          { value: 'items', label: 'Items list' },
          { value: 'detail', label: 'Item detail' },
          { value: 'add', label: 'Add item form' },
          { value: 'docs', label: 'Documents' },
          { value: 'paywall', label: 'Paywall' },
          { value: 'settings', label: 'Settings' },
        ]} onChange={(v) => setTweak('screen', v)} />

        <TweakSection label="Actions" />
        <TweakButton onClick={() => {
          // demo mark-done sheet from anywhere
          const sample = activeItem || items[0];
          if (sample) setMarkDone({ id: 'demo', name: typeof sample.nextMaint === 'string' ? sample.nextMaint : sample.nextMaint[t.language], itemId: sample.id });
        }}>Show mark-done sheet</TweakButton>
      </TweaksPanel>
    </>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);

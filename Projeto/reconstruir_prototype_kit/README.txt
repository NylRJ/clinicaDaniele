# 🧠 Reconstruir – Prototype Kit (Light & Dark + Animations)

Este pacote inclui:
- `design-tokens.json` (light/dark, grid, motion)
- `flutter_theme.dart` (ThemeData claro/escuro pronto)
- `web/` (HTML+CSS simples para visualizar comportamento e animações)
- `tailwind.config.cjs` (se preferir React/Tailwind)

## Como aplicar no Figma
1. Crie as páginas: 01 Foundations, 02 Components, 03 Patterns, 04 Admin, 05 Terapeuta, 06 Recepção, 07 Auth, 99 Prototype.
2. Em **Foundations**: crie Styles (Cores/Texto/Efeitos) usando os valores do `design-tokens.json`.
3. Em **Components**: crie componentes com Auto Layout e Variants:
   - Buttons (Primary/Secondary/Tertiary; estados hover/pressed/disabled)
   - Inputs (focus border no brand; helper/erro)
   - Cards (Base, Métrica, Lista)
   - Nav (Topbar, Sidebar desktop; Bottom nav mobile)
   - Tabela (header sticky, filtros em chips)
   - Modais/Drawers (640px desktop; full-height no mobile)
   - Chips de Status (Pago, Pendente, Cancelado, Em curso)
4. Em **Patterns**: Formulários, Tabelas, Empty states.
5. Em **Templates** (04–07): monte as telas-chaves (desktop e mobile).

## Frames & Grids
- Desktop: Frame 1440x1024, container 1200, grid 12 col (gutter 24, margin 24)
- Mobile: Frame 390x844, grid 4 col (gutter 16, margin 16)

## Interações & Animações (Figma Prototype)
Use **Prototype panel** com estes padrões:
- **On Click** → **Navigate To** (tela destino) + **Smart Animate** (220ms, Easing: Ease In-Out custom `cubic-bezier(0.2,0,0,1)`).
- **Hover**: Variant switch (Primary → Hover) com **Smart Animate** 180ms.
- **Pressed**: Variant switch 120ms.
- **Modal/Drawer**: **Open Overlay** (Dim 40–60%) com **Move In** de 16px (220ms).
- **Toast**: **After Delay** 120ms → **Smart Animate** Opacity 0→1 (180ms), auto-dismiss em 2.5s.

### Rotas principais
- Login → Dashboard Admin → (Relatórios | Configurações)
- Dashboard → Agenda Terapeuta → (+ Nova Sessão | Detalhe)
- Dashboard → Agendamento Recepção → (Check-in, Pagamentos)
- Global: Perfil/Preferências, Notificações, Toggle Tema

## Acessibilidade
- Contraste AA para texto normal, AAA para pequenos componentes quando possível.
- Área de toque mínima 44x44px.
- Focus ring visível (2px) na cor Info.

## Como visualizar rapidamente
- Abra `web/src/index.html` no navegador e use o botão “Tema” para alternar claro/escuro.
- Os cartões e botões têm hover/lift e transições suaves (180–220ms).

---
Qualquer ajuste de rótulos, textos e fluxos, edite `index.html`/`styles.css` ou replique os padrões no Figma.

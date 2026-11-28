# Graph Report - Lapak jajanan  (2026-11-27)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 1034 nodes · 1444 edges · 58 communities (49 shown, 9 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 4 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f4010be5`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Community 0
- Community 1
- Community 2
- Community 3
- Community 4
- Community 5
- Community 6
- Community 7
- Community 8
- Community 9
- Community 10
- Community 11
- Community 12
- Community 13
- Community 14
- Community 15
- Community 16
- Community 17
- Community 18
- Community 19
- Community 20
- Community 21
- Community 22
- Community 23
- Community 24
- Community 25
- Community 26
- Community 27
- Community 28
- Community 29
- Community 30
- Community 31
- Community 32
- Community 33
- Community 34
- Community 35
- Community 36
- Community 37
- Community 38
- Community 39
- Community 40
- Community 41
- Community 42
- Community 43
- Community 44
- Community 45
- Community 46
- Community 47
- Community 48
- Community 49
- Community 50
- Community 51
- Community 52
- Community 54

## God Nodes (most connected - your core abstractions)
1. `_` - 45 edges
2. `CartPage()` - 21 edges
3. `compilerOptions` - 18 edges
4. `formatRupiah()` - 15 edges
5. `CheckoutPage()` - 15 edges
6. `compilerOptions` - 15 edges
7. `react` - 14 edges
8. `dependencies` - 12 edges
9. `_` - 11 edges
10. `_` - 11 edges

## Surprising Connections (you probably didn't know these)
- `MenuPage()` --indirect_call--> `toCatalogMenu()`  [INFERRED]
  web_qr/src/pages/MenuPage.tsx → web_qr/src/data/mockCatalog.ts
- `MenuCardProps` --references--> `CatalogMenu`  [EXTRACTED]
  web_qr/src/components/catalog/MenuCard.tsx → web_qr/src/data/mockCatalog.ts
- `MenuDetailSheetProps` --references--> `CartItem`  [EXTRACTED]
  web_qr/src/components/catalog/MenuDetailSheet.tsx → web_qr/src/types/index.ts
- `MenuPage()` --calls--> `MenuCard()`  [EXTRACTED]
  web_qr/src/pages/MenuPage.tsx → web_qr/src/components/catalog/MenuCard.tsx
- `MenuDetailSheet()` --calls--> `formatRupiah()`  [EXTRACTED]
  web_qr/src/components/catalog/MenuDetailSheet.tsx → web_qr/src/lib/supabase.ts

## Import Cycles
- None detected.

## Communities (58 total, 9 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.03
Nodes (60): addon, _addonCard, _AddonEditResult, _addons, allowFixedPrice, build, _categories, _category (+52 more)

### Community 1 - "Community 1"
Cohesion: 0.04
Nodes (39): _addLine, build, _cart, _cartPanel, _cartTile, _cashCtrl, _cashPanel, _category (+31 more)

### Community 2 - "Community 2"
Cohesion: 0.04
Nodes (43): aov, cashier, customer, DailySalesData, dayLabel, discount, fullDate, gatewayRef (+35 more)

### Community 3 - "Community 3"
Cohesion: 0.05
Nodes (38): _, AppTheme, borderColor, canvasColor, light, seedColor, surfaceColor, error (+30 more)

### Community 4 - "Community 4"
Cohesion: 0.07
Nodes (34): oxlint, react-dom, react-router-dom, @supabase/supabase-js, @types/node, @types/react, @types/react-dom, typescript (+26 more)

### Community 5 - "Community 5"
Cohesion: 0.06
Nodes (33): dependencies, cupertino_icons, flutter, flutter_localizations, flutter_riverpod, go_router, image_picker, intl (+25 more)

### Community 6 - "Community 6"
Cohesion: 0.06
Nodes (31): _, action, AdminColors, background, border, build, canvas, child (+23 more)

### Community 7 - "Community 7"
Cohesion: 0.07
Nodes (29): build, _categories, CategoriesPage, _CategoriesPageState, category, _CategoryEntry, _clearForm, createState (+21 more)

### Community 8 - "Community 8"
Cohesion: 0.07
Nodes (30): addon, _AddonEntry, _addons, build, _clearForm, createState, dispose, _editingAddon (+22 more)

### Community 9 - "Community 9"
Cohesion: 0.07
Nodes (26): addons, category, choiceGroups, copyForEditing, copyWith, createPreviewMenus, description, extraPrice (+18 more)

### Community 10 - "Community 10"
Cohesion: 0.07
Nodes (26): _addressController, build, _buildForm, _closeTime, createState, _days, dispose, _formatTime (+18 more)

### Community 11 - "Community 11"
Cohesion: 0.08
Nodes (20): _advanceOrder, amount, build, code, copyWith, createState, _DashboardOrder, detail (+12 more)

### Community 12 - "Community 12"
Cohesion: 0.16
Nodes (21): MenuCard(), MenuCardProps, MenuDetailSheetProps, VariantId, VARIANTS, CatalogMenu, mockCategories, mockMenus (+13 more)

### Community 13 - "Community 13"
Cohesion: 0.12
Nodes (18): SetupNotice(), useToast(), isSupabaseConfigured, key, supabase, url, DEMO_ACTIVE, DEMO_COMPLETED (+10 more)

### Community 14 - "Community 14"
Cohesion: 0.09
Nodes (19): build, _buildHeaderBanner, _buildLeftPaymentAndOrderColumn, _buildRecentTransactionsCard, _buildTop5MenuCard, _buildTrendChartSection, createState, _isRefreshing (+11 more)

### Community 15 - "Community 15"
Cohesion: 0.08
Nodes (21): available, badge, buffer, CartLine, category, digits, icon, item (+13 more)

### Community 16 - "Community 16"
Cohesion: 0.10
Nodes (19): error, errorContainer, onSecondaryContainer, onSurface, onSurfaceVariant, outline, PosAppColors, primary (+11 more)

### Community 17 - "Community 17"
Cohesion: 0.10
Nodes (18): build, CatalogPage, _CatalogPageState, createState, _deleteMenu, dispose, _editMenu, menu (+10 more)

### Community 18 - "Community 18"
Cohesion: 0.17
Nodes (14): Icon(), SectionCard(), getLocationId(), getLocationLabel(), calculateGrandTotal(), calculatePb1(), PB1_RATE, CheckoutPage() (+6 more)

### Community 19 - "Community 19"
Cohesion: 0.10
Nodes (19): compilerOptions, allowArbitraryExtensions, allowImportingTsExtensions, erasableSyntaxOnly, jsx, lib, module, moduleDetection (+11 more)

### Community 20 - "Community 20"
Cohesion: 0.12
Nodes (6): Flutter, AppDelegate, SceneDelegate, RunnerTests, Testing, UIKit

### Community 21 - "Community 21"
Cohesion: 0.11
Nodes (17): AppShell, build, child, _DesktopSidebar, _Destination, _destinations, icon, isSelected (+9 more)

### Community 22 - "Community 22"
Cohesion: 0.19
Nodes (16): MenuDetailSheet(), toCatalogMenu(), ArrowIcon(), BoltIcon(), BowlIcon(), CartPage(), addSuggestion(), InfoIcon() (+8 more)

### Community 23 - "Community 23"
Cohesion: 0.12
Nodes (15): build, centerSubtitle, centerTitle, data, _DonutPainter, DonutPaymentChart, paint, primaryColor (+7 more)

### Community 24 - "Community 24"
Cohesion: 0.12
Nodes (14): build, createState, dineIn, dispose, item, lines, method, _noteCtrl (+6 more)

### Community 25 - "Community 25"
Cohesion: 0.12
Nodes (16): compilerOptions, allowImportingTsExtensions, erasableSyntaxOnly, lib, module, moduleDetection, noEmit, noFallthroughCasesInSwitch (+8 more)

### Community 26 - "Community 26"
Cohesion: 0.17
Nodes (14): AppBootstrap, _AppBootstrapState, AdminDashboardPage, _AdminDashboardPageState, AddonEditorDialog, _AddonEditorDialogState, ChoiceGroupDialog, _ChoiceGroupDialogState (+6 more)

### Community 27 - "Community 27"
Cohesion: 0.22
Nodes (10): App(), CartIcon(), Layout(), MenuIcon(), OrdersIcon(), PersonIcon(), useCart(), MenuPage() (+2 more)

### Community 28 - "Community 28"
Cohesion: 0.13
Nodes (13): badgeSubtext, badgeText, build, footerLeft, footerRight, footerRightColor, icon, iconBgColor (+5 more)

### Community 30 - "Community 30"
Cohesion: 0.14
Nodes (13): build, _buildMapPreview, _configureOutlet, createState, LocationsPage, _LocationsPageState, onConfigure, onOpenChanged (+5 more)

### Community 31 - "Community 31"
Cohesion: 0.15
Nodes (11): build, ClockText, _ClockTextState, createState, dispose, initState, _now, onMenu (+3 more)

### Community 32 - "Community 32"
Cohesion: 0.14
Nodes (13): _CategoryEditor, _CategoryRow, _EditableOptionRow, _EmptySectionMessage, _TimePickerField, _AddonEditor, _AddonRow, AdminMetricCard (+5 more)

### Community 33 - "Community 33"
Cohesion: 0.15
Nodes (9): build, createState, error, _initializationError, _initializeSupabase, initState, _isReady, _StartupErrorApp (+1 more)

### Community 34 - "Community 34"
Cohesion: 0.15
Nodes (12): address, branch, closeTime, copy, createDemoOutlets, isOpen, isPublic, latitude (+4 more)

### Community 35 - "Community 35"
Cohesion: 0.17
Nodes (7): MenuItem, build, item, MenuCard, onTap, build, PosSidebar

### Community 36 - "Community 36"
Cohesion: 0.18
Nodes (6): main, _hideKeyboard, pumpAndSettle, _scrollCatalogItemIntoView, _useMobileViewport, viewport

### Community 37 - "Community 37"
Cohesion: 0.20
Nodes (10): TransactionRecord, build, _buildDetailPanel, _buildTransactionTable, createState, _searchText, _selectedOrderType, _selectedTrx (+2 more)

### Community 38 - "Community 38"
Cohesion: 0.18
Nodes (8): build, _buildSidebarContent, _buildTopHeader, child, onLogout, onSelectMenu, OwnerShell, selectedIndex

### Community 39 - "Community 39"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 40 - "Community 40"
Cohesion: 0.35
Nodes (8): react, CartContext, CartContextValue, CartAction, CartProvider(), cartReducer(), loadCart(), CartItem

### Community 41 - "Community 41"
Cohesion: 0.24
Nodes (4): build, OrderTypePage, build, PaymentMethodPage

### Community 42 - "Community 42"
Cohesion: 0.20
Nodes (7): _, apiKey, AppConfig, isConfigured, supabaseAnonKey, supabasePublishableKey, supabaseUrl

### Community 43 - "Community 43"
Cohesion: 0.22
Nodes (6): build, description, FeaturePlaceholder, frCodes, icon, title

### Community 44 - "Community 44"
Cohesion: 0.22
Nodes (5): _client, fetchOrders, supabaseClientProvider, SupabaseService, watchOrders

### Community 45 - "Community 45"
Cohesion: 0.22
Nodes (7): dot, posIconBox, posPill, posSegmented, posShadow, seg, small

### Community 46 - "Community 46"
Cohesion: 0.25
Nodes (5): build, PosHistoryPage, TransactionHistoryPage, build, OrdersPage

### Community 47 - "Community 47"
Cohesion: 0.33
Nodes (5): build, createState, SalesReportPage, _SalesReportPageState, _searchQuery

### Community 48 - "Community 48"
Cohesion: 0.33
Nodes (5): analyzer, exclude, include, linter, rules

### Community 50 - "Community 50"
Cohesion: 0.33
Nodes (5): plugins, rules, react/only-export-components, react/rules-of-hooks, $schema

## Knowledge Gaps
- **532 isolated node(s):** `addon`, `_addonCard`, `_AddonEditResult`, `_addons`, `allowFixedPrice` (+527 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 714 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **9 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_` connect `Community 6` to `Community 32`, `Community 35`, `Community 36`, `Community 38`, `Community 43`, `Community 15`, `Community 16`, `Community 28`?**
  _High betweenness centrality (0.034) - this node is a cross-community bridge._
- **What connects `addon`, `_addonCard`, `_AddonEditResult` to the rest of the system?**
  _532 weakly-connected nodes found - possible missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.03076923076923077 - nodes in this community are weakly interconnected._
- **Why does `_` connect `Community 3` to `Community 36`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.041666666666666664 - nodes in this community are weakly interconnected._
- **Why does `Outlet` connect `Community 34` to `Community 10`, `Community 30`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.044444444444444446 - nodes in this community are weakly interconnected._
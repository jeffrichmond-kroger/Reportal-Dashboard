# Reportal Dashboard Implementation Checklist

Updated: 2026-11-18

Stop at each phase until all its exit checks pass. Static checks do not prove
Desktop rendering, refresh, DAX evaluation, or data accuracy. Phase 4 must pass
before final visual recreation. Do not mark a phase complete based only on edits.

## Confirmed Decisions

- Baseline: `761683e` (`docs`); reference files committed.
- User confirmed the baseline opens and refreshes with intended credentials.
- Source profiles establish the common YTD endpoint rule recorded in Phase 3.
  Phase 4 runtime checks confirm global fact-grain uniqueness; historical orphan
  metric references remain unresolved. The current-goal contract supersedes
  historical screenshot goal equality and passed validation on 2026-11-18.
- Organization remains disconnected; use supplied ALL/DIV/DIST/SITE results.
- Never sum Site results to produce broader scopes or recalculate supplied scores.
- Annual Goal from reportal.factYTDGoals_vw supplies the report Goal column.
  Use the latest row for the selected year/scope/metric even for earlier periods.
  LatestGoalDate/LatestGoalWeek are metadata, not as-of filters. YTD GoalValue
  and the old YTD Goal Text measure remain snapshot diagnostics only.
- Weekly GoalText is authoritative text; preserve supplied formatting.
- Organization scope is strictly parent-first: Division All means ALL; selected
  Division with District All means DIV; selected District with Site All means
  DIST. Irrelevant lower-level selections are ignored. Invalid or ambiguous
  selections at an active level return blank. Native dropdowns remain selectable.
- Preserve source connections, types, identifiers, and unrelated user changes.

## Phase Status

- [x] Phase 0: baseline and project safety established before implementation.
- [x] Phase 1: semantic-model cleanup (user accepted 2026-11-17).
- [x] Phase 2: organization-scope logic (runtime gate passed 2026-11-17).
- [x] Phase 3: base retrieval measures (runtime gate passed 2026-11-17).
- [x] Phase 4: semantic-model data validation (accepted 2026-11-18 with approved historical-data exception).
- [ ] Phase 5: report shell (rendering and scope regressions pass; final native interaction acceptance pending).
- [ ] Phase 6: header score visuals.
- [ ] Phase 7: main score matrix.
- [ ] Phase 8: period navigation.
- [ ] Phase 9: visual comparison and refinement.
- [ ] Phase 10: final validation and release readiness.

## Phase 0: Baseline

- [x] Clean working tree verified at baseline `761683e` before implementation.
- [x] Baseline commit and reference screenshot/playbook available.
- [x] User confirmed Desktop open and refresh succeeds.
- [x] Desktop closed before external model edits.
- [x] Five business relationship endpoints documented; Organization disconnected.
- [x] Rollback anchor recorded; preserve unrelated changes and user work.

The current working tree intentionally contains Phase 1 changes. Do not reset it
to the baseline merely to satisfy the historical clean-tree check above.

## Phase 1: Semantic-Model Cleanup

- [x] Hide selected technical keys, sorting fields, and source audit metadata.
- [x] Disable implicit sum/count defaults across the six business tables.
- [x] Preserve source queries, column types, and identifiers in metadata edits.
- [x] User disabled Auto date/time in Desktop and saved the project.
- [x] Saved model records `__PBI_TimeIntelligenceEnabled = 0`.
- [x] Desktop removed the template and all 17 local date tables and references.
- [x] Verify remaining relationships are active many-to-one, single direction (Q6).
- [x] Assess period/week label-to-sort mappings against loaded data; conflicts recorded below.
- [x] Review metric order using SortNumber and SubSortNumber, including ties.
- [x] Configure period and dashboard metric sorting supported by exported data.
- [x] Configure WeekColumnLabel by FiscalWeekNumber; 2026 sample check passed.
- [x] Confirm full-calendar week mapping and calculated dashboard columns in Desktop (Q5: 0/0/17).
- [x] Review existing names/formats; preserve source masks and types without inventing metric units.
- [x] Confirm latest edits open, refresh, save, and reopen in Desktop (user acceptance).
- [x] Review saved model diff; Desktop normalization preserves calculated columns and sorting.
- [x] Accept Phase 1 before starting Phase 2 (user: "Phase 1 checks passed").

The user ran [PHASE_1_VALIDATION.dax](PHASE_1_VALIDATION.dax) in Desktop.
Results are retained in [PHASE_1_Q1.txt](PHASE_1_Q1.txt),
[PHASE_1_Q2.txt](PHASE_1_Q2.txt), [PHASE_1_Q3.txt](PHASE_1_Q3.txt),
and [PHASE_1_Q4.txt](PHASE_1_Q4.txt). Follow-up runtime evidence is retained in
[PHASE_1_Q5.txt](PHASE_1_Q5.txt) and [PHASE_1_Q6.txt](PHASE_1_Q6.txt).
These queries do not validate score facts.

### Phase 1 Validation Findings

| Proposed mapping/check | Result | Decision |
| --- | --- | --- |
| Fiscal Period PeriodLabel -> PeriodSort | 0 conflicts | Applied; checked against 117 exported period rows. |
| Fiscal Week WeekColumnLabel -> WeekSort | 53 conflicting labels | Do not configure this mapping. |
| Fiscal Week WeekDateLabel -> WeekSort | 103 conflicting labels | Do not configure this mapping. |
| Metric MetricName -> SortNumber | 8 conflicting names | Do not sort the existing MetricName by SortNumber. |
| Metric MetricName -> SubSortNumber | 0 conflicts | Technically compatible, but not a global metric order. |
| Metric duplicate SortNumber/SubSortNumber pairs | 2 excess rows | Ties belong to three excluded workflow metrics. |
| Fiscal Week WeekColumnLabel -> FiscalWeekNumber | 0 conflicts (Q5) | Applied; full loaded calendar mapping passed in Desktop. |
| Dashboard Metric -> DashboardMetricSort | 0 conflicts (Q5) | Applied; calculated dashboard label mapping passed in Desktop. |
| Nonblank Dashboard Metric labels | 17 (Q5) | Matches the current dashboard-visible source metrics. |
| Business relationship state | Five active Many -> One, OneDirection, Ready (Q6) | Expected endpoints confirmed; Organization disconnected. |

- Period labels include the fiscal year. The calendar spans 2022-2030 and
  supplies previous/next keys across year boundaries; first/last keys are blank.
- Weekly captions omit the year, so different years reuse captions with
  different WeekSort values. A single-period filter does not make an invalid
  model-level sort-by mapping valid. WeekColumnLabel now sorts by FiscalWeekNumber;
  all 52 exported 2026 captions agree with this ordering. Q5 also confirms zero
  mapping conflicts across the entire loaded calendar.
- Keep WeekDateLabel as a caption associated with a unique fiscal-week column;
  do not use the repeated date-range text as a standalone chronological axis.
- Repeated metric names occur among hidden detail metrics under different parents.
  Preserve MetricKey identity; a report filter does not fix a model sort conflict.
- Dashboard-visible, non-hidden metrics have distinct SortNumber values in Q2.
  Their order is Total Overall, Care and its details, Service and its details,
  then Share and its details. New calculated columns Dashboard Metric and hidden
  DashboardMetricSort expose these source labels and their source order. Both
  return blank for excluded metrics, avoiding blank-label sort conflicts.
  Their logic passed both a projection check against all exported metric rows
  and actual Desktop evaluation in Q5. Desktop saved the columns after the
  imported columns; this normalization preserves their expressions and sorting.
  Original MetricName and MetricKey are unchanged. Report visuals must exclude
  blank Dashboard Metric rows; revalidate label uniqueness after source changes.
- Keys 57/58/59 (Verification/Other/Clinical Workflows) share sort pair 50100/1.
  All have DashboardVisibleFlag=false; do not change source order to resolve an
  irrelevant tie. Use MetricKey as a deterministic diagnostic tie-breaker.
- Confirmed headline metric keys: Total Overall=17, Care=3, Service=2, Share=4.
  Representative details: Auto Refill=87, Completed Clinical Interactions [NS]=90,
  Rx Sold=12. Preserve source names; do not strip [NS] without presentation rules.
- In 2026, Period 10 weeks are 202637-202640, with labels P10 W1 (W37) through
  P10 W4 (W40) and date captions 10/11-10/17, 10/18-10/24, 10/25-10/31,
  and 11/01-11/07. Q4 has four weeks per period in 2026; it does not establish
  whether five-week periods exist in other years.
- Desktop was closed and saved before applying these sort changes. No supplied
  scores, goals, values, source partitions, or relationships were changed.

### Phase 1 Acceptance

Q5 and Q6 passed. The user confirmed "Phase 1 checks passed" on 2026-11-17,
accepting the refresh/save/reopen and visual sorting checks for periods, weeks,
and dashboard metrics. The saved definitions retain the calculated columns and
sort properties. Phase 1 is complete. Final layout and score-data correctness
remain subject to their later gates; this acceptance does not validate facts.

The original Q1 conflict counts remain expected: original labels/fields were
preserved. Queries 5 and 6 validate the replacement sorting and relationships;
there is no need to rerun or overwrite the four historical result files.

Do not create a measure table until actual measures justify one. No daily date
table is required solely for this weekly, supplied-result retrieval design.

## Phase 2: Organization-Scope Logic

- [x] Add Selected Organization Scope Key to the disconnected Organization table.
- [x] Implement explicit-filter detection; do not infer scope depth from child counts.
- [x] Add read-only Phase 2 validation queries and retain runtime results.
- [x] Resolve All/All/All to ALL.
- [x] Resolve one Division to its exact DIV key.
- [x] Resolve one Division/District to its exact DIST key.
- [x] Resolve one Division/District/Site to its exact SITE key.
- [x] Preserve leading zeros and verify tested keys against both fact tables.
- [x] Test explicit selections versus cascading single-value contexts.
- [x] Return blank for tested invalid, conflicting, and multi-value selections; guard ambiguous ancestry.
- [x] Pass scope tests without adding organization-to-fact relationships.

### Phase 2 Implementation And Validation

The following records the original accepted Phase 2 behavior and evidence.
Its child-only ancestry inference is superseded by the explicitly approved
Phase 5 parent-first contract below. Use PHASE_5_FILTER_VALIDATION.dax for that
new behavior; do not treat historical child-only expectations as current tests.

- Measure: Organization[Selected Organization Scope Key], in display folder
  Organization Scope. No new measure table, source query, or relationship.
- Supported report slicers: DivisionDisplay, DistrictDisplay, SiteDisplay.
  The matching Number fields and OrganizationSiteKey also support direct filters.
- Scope is the deepest directly filtered supported field. A parent selection
  never escalates merely because only one child remains visible. A child-only
  selection can infer its parents only when its ancestry is unambiguous.
- All means cleared filters at that level. Native slicer Select All must leave
  that level unfiltered; explicitly enumerating multiple values is not treated
  as All. Verify the actual slicer state in Phase 5, including single-child cases.
- Direct multi-value filters, empty intersections, missing identifiers needed by
  the selected scope, and ambiguous ancestry return blank. Do not silently fall
  back to ALL. Other Organization attributes are not supported score scopes.
- Keys concatenate source strings without numeric conversion or padding guesses.
- The measure resolves a candidate scope key, not data availability at a selected
  period/week/metric. Phase 3 retrieval will filter the facts by this key.
- Run both queries in [PHASE_2_VALIDATION.dax](PHASE_2_VALIDATION.dax) after reopening
  Desktop. Keep DEFINE and its first EVALUATE together. Run the second EVALUATE
  separately if needed. No measures are created by the validation queries.
- Query 1 selects an actual organization row and tests 12 contexts. Require PASS
  for all applicable cases and true Weekly/YTD key-existence results for valid
  nonblank scopes. Missing keys require investigation, not score aggregation.
  NOT TESTED is an unresolved coverage item, never a pass.
- Query 2 checks every division resolves to DIV rather than a child scope;
  inspect any single-district/single-site divisions in particular.
- Runtime evidence: [PHASE_2_Q1.txt](PHASE_2_Q1.txt) has 12/12 applicable PASS
  results. ALL, DIV|011, DIST|011|P1, and SITE|011|P1|259 resolve exactly and
  exist in both score facts. Invalid/conflicting/multi-value contexts return blank.
- Key-existence flags are false on the four blank-result cases; these are not
  failures because no fact lookup is required for an invalid selection.
- [PHASE_2_Q2.txt](PHASE_2_Q2.txt) confirms all 21 divisions return their DIV keys.
  Division 705 has one district and 34 sites but correctly returns DIV|705,
  proving that a single remaining child does not incorrectly escalate scope.
- Phase 2 runtime gate passed on 2026-11-17. This validates the tested scope
  resolver, not period-specific availability or numerical scores. Source changes
  and the actual slicer Select All interaction remain future regression tests.
- No score-retrieval measures or final report visuals were added during Phase 2.

## Phase 3: Base Retrieval Measures

- [x] Prepare source profiling queries and review Q1-Q4 loaded results.
- [x] Define YTD endpoint from source evidence; confirm measure evaluation in Q5/Q6.
- [x] Implement retrieval of YTD score, display value, underlying value, goal, and color.
- [x] Implement retrieval of weekly score, display value, underlying value, goal text, color, and arrow.
- [x] Add selected period, week, and date labels.
- [x] Guard retrieval by one metric, one resolved scope, and an applicable single time endpoint.
- [x] Add row-count diagnostics and require exactly one row before value retrieval.
- [x] Preserve blank scores, independent display values, and valid zero in measure logic.
- [x] Add literal-percent, count, and Rx Sold million display-text formatting.
- [x] Confirm Q5/Q6 retrieval and formatting match the exported source rows.
- [x] Confirm Q7 blank-context guards pass.
- [x] Compile and evaluate DAX in Desktop before Phase 4.
- [x] Confirm corrected Q5 emits exactly the 28 intended metric/week groups.

### Phase 3 Source Profiling Gate

The first four EVALUATE blocks in [PHASE_3_VALIDATION.dax](PHASE_3_VALIDATION.dax)
were evaluated by the user. Source evidence is retained in
[PHASE_3_Q1.txt](PHASE_3_Q1.txt), [PHASE_3_Q2.txt](PHASE_3_Q2.txt),
[PHASE_3_Q3.txt](PHASE_3_Q3.txt), and [PHASE_3_Q4.txt](PHASE_3_Q4.txt).
Each block is independently runnable; no DEFINE section is required.

1. Q1: Period 10 2026 / ALL raw YTD rows for the four headline metrics, Auto
  Refill, Completed Clinical Interactions, and Rx Sold. Inspect fiscal endpoint
  weeks, snapshot dates, load dates, goals, scores, display values, and colors.
2. Q2: corresponding weekly raw rows, with authoritative GoalText and ArrowCode.
3. Q3: source format masks, rounding settings, thresholds, and descriptions for
  the 17 dashboard metrics. Do not assume source masks are DAX-compatible or
  that stored percentages need multiplication by 100.
4. Q4: row/grain counts and duplicate-grain counts for both facts at Period 10 / ALL.
  Require nonzero source rows and zero duplicate grains. This scoped check does
  not establish uniqueness across all organizations or periods.

### Phase 3 Source Findings And Retrieval Contract

- Q4: Period 10 / ALL has 156 weekly rows and 144 YTD rows, each with zero
  duplicate grains and four endpoint weeks. This is scoped evidence, not proof
  of global uniqueness across all organizations and periods.
- Q1: four independent YTD snapshots exist at 202637-202640. At endpoint 202640,
  Total Overall/Care/Service/Share scores are 65/72/83/45.
- Selected YTD Endpoint Week Key chooses the maximum available YTD FiscalWeekKey
  within the explicitly selected period and resolved scope, independent of the
  metric and weekly column. This is a key lookup, never aggregation of scores.
  It does not choose a different endpoint per metric or fall back to another
  period. Missing metrics at the common endpoint remain blank. Future periods
  without snapshots remain blank rather than silently showing an earlier period.
- Each value measure requires exactly one matching source row. Row-count helpers
  return 0 for missing valid contexts, >1 for duplicates, and blank for invalid
  contexts; value measures return blank unless the count is exactly 1.
- Weekly retrieval requires one fiscal week and one metric. YTD retrieval requires
  one selected Fiscal Period and one metric; weekly filters are removed for YTD.
- No default period is silently selected. Selected Period Label is blank unless
  exactly one Fiscal Period is in context. Navigation must set an actual selection.
- Q2: weekly headline targets and the three representative detail patterns match
  the legacy expectations in the raw rows. Q5 confirms actual measure retrieval
  for all 28 intended metric/week rows.
- Auto Refill DisplayValue is approximately 61.2 percentage points, not 0.612.
  SummaryFormatMask is a source indicator (%, 0, or blank), not a ready-to-use
  DAX format string. Display text uses SummaryRoundingNumber and a literal percent
  suffix; it never applies DAX percent scaling. Numeric source measures stay raw.
- DetailFormatMask is preserved for future detail views; it does not override the
  dashboard summary format. Raw UnderlyingValue is not substituted for DisplayValue.
- Rx Sold display and numeric YTD goal use two-decimal millions when magnitude is
  at least one million; smaller organizational values remain grouped numbers.
  Count-only Clinical Interactions uses grouped integers with no invented score.
- Weekly GoalText remains byte-for-byte source text. Blank YTD GoalValue remains
  blank, even when the weekly row has a goal. Several sampled YTD goals are blank,
  including Auto Refill; assess any legacy Goal-column discrepancy during Phase 4
  rather than silently substituting a weekly goal.
- ColorCode (red/yellow/green in sampled rows) and ArrowCode (up/down/side) are
  retrieved unchanged. No thresholds, statuses, or arrows are recalculated.
- Measures are housed in their existing owning tables using display folders;
  Metric Numeric Format is a hidden formatting helper. No measure table, source
  query changes, relationship changes, or report visuals are required.

### Phase 3 Runtime Findings And Acceptance

Desktop results were reviewed on 2026-11-17:
[PHASE_3_Q5.txt](PHASE_3_Q5.txt), [PHASE_3_Q6.txt](PHASE_3_Q6.txt), and
[PHASE_3_Q7.txt](PHASE_3_Q7.txt). These establish actual DAX evaluation, not just
static reference checks.

1. Q5: all 28 intended Period 10 metric/week rows have Weekly rows=1 and exactly
  match Q2 scores, display values, underlying values, goal text, colors, and
  arrows. Week labels match the grouped source labels. Auto Refill, Rx Sold,
  and Clinical Interactions display text matches the expected patterns.
  Endpoint 202640 and each metric's YTD score remain constant across weeks.
2. Q6: seven rows have YTD rows=1, scope ALL, period label Period 10 2026, and
  endpoint 202640. All five retrieved raw fields match Q1's endpoint rows.
  Headline scores are 65/72/83/45. Clinical Interactions retains a blank score
  and display 459,526. Rx Sold displays 248.24M with goal 232.72M; Auto Refill
  displays 61.2%. Blank goals and colors remain blank.
3. Q7: all six invalid/ambiguous-context guards return blank and PASS.

The original Q5 emitted 3,290 groups, including 3,262 unrelated calendar groups
with blank weekly fields. SUMMARIZECOLUMNS grouping is not constrained by the
related Fiscal Period filter under SelfValue semantics; nonblank scope/YTD
expressions keep the extra groups in the output. This is a validation-query
grouping defect, not incorrect weekly retrieval. Query 5 now also filters
Fiscal Week[FiscalPeriodKey] directly. No model changes were needed.

The user reran corrected EVALUATE block 5 in
[PHASE_3_VALIDATION.dax](PHASE_3_VALIDATION.dax) and updated
[PHASE_3_Q5.txt](PHASE_3_Q5.txt). The 2026-11-17 rerun contains exactly 28 unique
groups: seven metrics across weeks 202637-202640, all at scope ALL and with
Weekly rows=1. All 168 source-field comparisons match Q2; display text and
week/date labels match expectations. YTD endpoint 202640 and each metric's YTD
score remain unchanged across all four weekly columns. The grouping defect is
resolved in Desktop. The passing Q6/Q7 evidence remains applicable.

Phase 3 runtime gate passed on 2026-11-17. Phase 4 remains the formal exact
comparison gate, including broader metric coverage, fact uniqueness,
missing-row behavior, goal discrepancies, and organization regressions. This
acceptance does not authorize final visual recreation before Phase 4 passes.

## Phase 4: Data Validation

Required comparison columns: Legacy expected | Power BI actual | Difference |
Pass/Fail. Use exact equality for integer scores/counts. For unrounded percentage
values, use absolute difference <= 0.000001 where source precision permits.
Rounded screenshot percentages and million values are display checks, not exact
raw numeric expectations.

- [x] Confirm Period 10, fiscal year 2026, scope ALL, and correct YTD endpoint.
- [x] YTD Total Overall/Care/Service/Share = 65/72/83/45.
- [x] Weekly Total Overall W37-W40 = 64/65/66/65.
- [x] Weekly Care W37-W40 = 66/69/70/69.
- [x] Weekly Service W37-W40 = 86/86/87/87.
- [x] Weekly Share W37-W40 = 45/45/45/44.
- [x] Auto Refill scores = 94/94/94/94; display = 61.2%/61.2%/61.1%/61.1%.
- [x] Completed Clinical Interactions = 13,853/15,165/16,263/15,062; no score.
- [x] Rx Sold scores = 90/90/90/88; display = 6.79M/6.75M/6.79M/6.93M.
- [x] Verify raw precision, red Care/Share scores, and visible status colors for all 17 metrics.
- [x] Verify all 17 source metrics follow screenshot row order in metadata.
- [x] Validate scores/displays for all 17 dashboard metrics; classify every goal comparison.
- [x] Validate actual numerical retrieval for representative DIV/DIST/SITE scopes.
- [x] Verify global fact uniqueness and missing/zero behavior; retain comparison evidence.
- [x] Supersede the 13 snapshot-goal mismatches with the approved current-goal contract.
- [x] Validate Annual Goal uniqueness, raw/display retrieval, year/scope selection, and period independence.
- [x] User completed Desktop goal tests and saved the PBIP project (2026-11-18).
- [x] Explicitly disposition historical orphan metric references before gate acceptance.
- [x] User approved the documented historical-data exception and proceeding to Phase 5 (2026-11-18).
- [x] Accept the data gate with that exception before final report visuals.

### Phase 4 Automated Evidence

Run the repeatable validator from the project root:

```powershell
& './Docs/PHASE_4_VALIDATION.ps1'
```

[PHASE_4_VALIDATION.ps1](PHASE_4_VALIDATION.ps1) reads saved Desktop exports and
writes [PHASE_4_COMPARISON.csv](PHASE_4_COMPARISON.csv). It does not refresh or
query the live model. The CSV records legacy expected, source/contract expected,
Power BI actual, difference, and Pass/Fail for every check. Screenshot targets
were transcribed from the committed Period 10 image, including all 17 metrics.
Screenshot percentages/millions are text comparisons; integer scores/counts
use exact numeric equality. Raw fractional values use at most 0.000001 tolerance.
Blank and zero are distinct; omitted trailing TSV cells normalize to blank.

The initial 2026-11-17 snapshot-goal comparison had 1,137 PASS and 15 FAIL.
The approved current-goal contract was implemented by the user in Desktop;
the user confirmed tests passed and the project was saved on 2026-11-18.
All ten runtime queries were then executed against that saved Desktop model.
Current results: **1,595 PASS, 2 FAIL, 0 NOT TESTED** across 1,597 records:

- All 170 screenshot score/display checks pass for all 17 metrics, including
  blank unscored rows and true numeric zero scores.
- All 85 visible status-color checks pass. The source token `hide` means no
  visible status color for Left Nav's weekly rows; raw source comparisons still
  require the literal token unchanged. No source token or measure was rewritten.
- All 493 raw source-field retrieval checks pass (408 weekly and 85 YTD).
- All 340 time/scope/row-count checks and six blank-context checks pass.
- Four export structure checks and the 17-metric source-order check pass.
- All 86 current-goal checks pass: the 17-row export count, unique source rows,
  exact raw text, independent display formatting, selected year, and scope.
- All 144 goal year/scope cases pass across the nine selectable years, four
  representative scopes, and four metrics, plus their result-count check.
  Missing source rows are verified as blank, never substituted from another year.
- All 221 goal period/week independence cases pass (17 metrics x 13 periods in
  2026), plus three invalid-context guards and their result-count check.
- All six Annual Goal integrity checks pass: 145,784 source rows have distinct
  year/scope/metric grains, no missing grain keys, and no orphan MetricKeys.
- All 16 scope/metric retrieval cases pass, plus their result-count check.
- All three missing/zero runtime cases pass, plus their result-count check.
- Global integrity has 13 passing checks and two orphan-key failures.

These are comparison checks, not 1,597 independent model rows. The comparison
runner's negative controls also verified blank-versus-zero separation, exact
integer equality, bounded fractional tolerance, and unavailable-evidence handling;
synthetic probes were not exported as model evidence. Source metadata order is
validated; rendered matrix ordering and exact visual colors are later UI checks.

### Phase 4 Approved Current-Goal Contract

Approved 2026-11-18: the Goal column uses Annual Goal, not a YTD score snapshot.
The source view supplies exactly one latest row per GoalYear, organization
scope, and MetricKey. The selected Fiscal Period determines the year only.
Earlier periods intentionally show that year's current goal, even when the
goal's audit date/week is later. Do not select by YTD endpoint or apply an
as-of date. Do not fall back to another year, scope, or score-fact goal.

The user's saved model has an active single-direction Metric-to-Annual Goal
relationship. Organization remains disconnected; TREATAS applies the selected
year and scope. No period/week relationship was added. Current Goal Raw Text
requires one matching row; Current Goal Display Text separately formats mixed
percent strings, percentage-point numbers, counts, and Rx Sold millions.
Null goals remain blank. Date/week are audit metadata only.

| Metric | Legacy screenshot goal reference | Approved current goal display | Result |
| --- | --- | --- | --- |
| Total Overall / Care / Service / Share | 85 | 85 | PASS |
| Auto Refill | 75.0% | 75.0% | PASS |
| Rx Sold | 6.51M | 6.51M | PASS |
| Vaccines | 3.24M | 134,702 | PASS against current source; intentional historical difference |
| Clinical Interactions | blank | blank | PASS |

The comparison CSV keeps the original goal under Legacy goal reference (not
authoritative), while expected raw/display goals come from the current source
and metric formatting metadata. This does not overwrite or pretend to match
the old screenshot. The 13 earlier snapshot-goal failures are superseded, not
fixed with constants. Existing snapshot-goal measures remain diagnostics.

Annual Goal also retains 2020 source rows outside the selectable 2022-2030
calendar. This is coverage information, not an invalid key relationship: goals
have no physical calendar relationship, and year selection never falls back.
The outside-year count remains visible in Q9 for audit.

### Phase 4 Executed Runtime Checks

Desktop was initially closed. The assistant opened this project's existing
cache and connected to its local analysis engine using the installed
Microsoft.PowerBI.AdomdClient client and Windows integrated authentication.
The initial six EVALUATE blocks were executed on 2026-11-17. On 2026-11-18,
after the user's Annual Goal implementation and successful Desktop tests, all
ten blocks in [PHASE_4_VALIDATION.dax](PHASE_4_VALIDATION.dax) compiled and
executed directly. The assistant did not refresh sources, save/change the live
model, or change source connections. Results validate the user's loaded cache,
not an independently refreshed database snapshot. Desktop remains open.

1. [PHASE_4_Q1.txt](PHASE_4_Q1.txt): 68 actual weekly metric/week rows with
  independent source fields, all 17 visible metrics, scope ALL, endpoint 202640.
2. [PHASE_4_Q2.txt](PHASE_4_Q2.txt): 17 actual YTD metric rows at endpoint 202640,
  including independent raw source values and formatted goals.
3. [PHASE_4_Q3.txt](PHASE_4_Q3.txt): global fact-grain/key checks on 23,671,000
  loaded fact rows. Grain uniqueness, nonblank grain keys, week references, and
  fact/calendar period agreement pass. Metric references fail as detailed below.
4. [PHASE_4_Q4.txt](PHASE_4_Q4.txt): all 16 ALL/DIV/DIST/SITE retrieval cases
  pass against actual source rows for Total Overall, Auto Refill, Clinical
  Interactions, and Rx Sold. Fixtures are ALL, DIV|011, DIST|011|P1, and
  SITE|011|P1|259 at week/endpoint 202640. No broader scope is aggregated.
5. [PHASE_4_Q5.txt](PHASE_4_Q5.txt): all three cases pass. Missing valid week
  202201 returns zero rows and blank values; unloaded period 203013 has no YTD
  endpoint/fallback; an actual zero at week 202637 stays numeric zero.
6. [PHASE_4_Q6.txt](PHASE_4_Q6.txt): orphan metric-key drilldown with affected
  row counts, first/last week, and Period 10 / ALL impact.
7. [PHASE_4_Q7.txt](PHASE_4_Q7.txt): all 17 current goals at year 2026 / ALL,
  with raw/display measures, independent source text/counts, and audit date/week.
8. [PHASE_4_Q8.txt](PHASE_4_Q8.txt): 144 year/scope/metric cases, all PASS,
  including known missing-year results remaining blank.
9. [PHASE_4_Q9.txt](PHASE_4_Q9.txt): 145,784 unique annual-goal grains, zero
  duplicate/missing keys, zero orphan MetricKeys; one audit-only year outside
  the calendar (2020).
10. [PHASE_4_Q10.txt](PHASE_4_Q10.txt): all 224 period/week independence and
  invalid-context cases PASS. A week-key filter cannot change the current goal.

### Phase 4 Historical Integrity Findings

| Fact | Loaded rows / unique grains | Orphan MetricKeys | Affected rows | Period 10 / ALL affected rows |
| --- | --- | --- | --- | --- |
| Weekly Score | 12,314,272 | 10, 15, 24, 44, 47, 67 | 682,765 | 0 |
| YTD Score | 11,356,728 | 10, 15, 24, 44, 67 | 697,762 | 0 |

These 1,380,527 historical rows span fiscal weeks 202249-202446 across the two
facts. Their MetricKeys do not exist in the loaded Metric dimension. They can
disappear under metric grouping or surface as unknown/blank members; do not
silently delete them, invent metric names, or assume they are harmless retired
metrics. The tested Period 10 2026 / ALL screenshot is unaffected, but broader
period navigation requires source-owner remediation or an explicit documented
scope/exception decision. No model or source changes have been applied.

### Phase 4 Acceptance Status

The planned runtime checks are executed; no additional manual export is needed
for this evidence set. Reproduce the comparisons with the PowerShell validator;
the ten DAX blocks remain independently runnable for a future refreshed model.
The validator prefers full Phase 4 exports and retains all failures. A successful
process exit means evidence generation succeeded, not that the data gate passed.

The goal contract is approved and its implementation passed runtime validation.
On 2026-11-18 the user explicitly selected "Approve a documented historical-data
exception and proceed to Phase 5." Phase 4 is accepted with that exception.
Report scope is not silently restricted to 2026. Historical navigation can still
omit or surface unknown members for the documented missing MetricKeys; remediation
remains a source-owner follow-up, not a completed data repair. No rows were removed
and no metric names, scores, or replacement keys were fabricated.

Raw evidence remains 1,595 PASS and two FAIL. The CSV's separate Gate decision
column records the approved historical exception only when the exact keys,
affected-row totals, orphan-key counts, and zero Period 10 / ALL impact still
match this approval. A changed or additional finding blocks a future gate.

## Phase 5: Report Shell

- [x] Establish 1920 x 1080 layout, background, and left filters.
- [x] Configure Division/District/Site native single-select dropdowns; clear selection means All.
- [x] Add a single-period selector initialized to Period 10 2026 and an inert help placeholder.
- [x] Define unique visual names, accessible labels, and tab order.
- [x] Move Period below Site in the left sidebar and verify its rendered placement.
- [x] Enforce the approved parent-first scope policy with source-backed runtime tests.
- [ ] Test filter behavior and layout before adding header visuals.

### Phase 5 Shell Implementation

New Dashboard page: 6f1c890de7344ce092a1, 1920 x 1080, FitToPage. The existing
Page 1 and its goal-validation table/year filter are preserved unchanged.
Dashboard is registered first and opens as the active page. Seven native
visuals provide a neutral left filter band, Reportal title, three organization
dropdowns, a fiscal-period dropdown, and a noninteractive question-mark help
placeholder. No score/header/matrix visuals were added during this phase.

Organization dropdowns bind DivisionDisplay, DistrictDisplay, and SiteDisplay
on the disconnected Organization table, with default native interactions.
Each permits one selected value; clearing that selection represents All rather
than enumerating multiple values. Period is at x=24, y=496, width=252, height=96,
aligned below Site with a 24-pixel gap. The period dropdown binds PeriodLabel and
stores Period 10 2026 as its actual initial slicer selection, not a page filter
that prevents later changes. No year restriction was introduced by the approved
historical-data exception. Help has no fabricated link or action.

Local checks pass for JSON parsing, model field bindings, unique visual IDs,
accessible names, distinct tab order, selection settings, canvas bounds, and
initial period state. The earlier Desktop-loading blocker is resolved. On
2026-11-18 the updated model loaded successfully; the native Dashboard render
was inspected and shows all four dropdowns aligned in the sidebar, initial
Period 10 2026, readable labels, and no clipping or visual errors. No custom
visual or hierarchy-slicer replacement was introduced. Local structural checks
are not full JSON Schema validation; Desktop loading/rendering is actual runtime
evidence. The validation page files were not edited.

### Phase 5 Parent-First Scope Contract

The user explicitly chose to retain three separate native Organization slicers
with normal cascading interactions, not automatic reset/disable or a custom
visual. The approved DAX behavior is:

| Explicit parent state | Scope result | Lower-level filters |
| --- | --- | --- |
| Division cleared / All | ALL | District and Site ignored |
| One Division; District cleared / All | DIV key | Site ignored |
| One Division and District; Site cleared / All | DIST key | No Site required |
| One valid Division, District, and Site | SITE key | All active selections must agree |
| Invalid/ambiguous active parent or active Site | blank | Never silently broaden the scope |

Selected Organization Scope Key resolves Division after removing District/Site
filters and District after removing Site filters. This prevents a stale child
selection, including an empty or conflicting child intersection, from changing
an otherwise valid higher-level scope. It no longer infers parents from a
child-only filter. The existing measure name and lineage are unchanged; score
and current-goal measures reuse the revised resolver without source changes.

This changes calculation semantics, not native slicer state. A child dropdown
can still be opened and may retain a selected caption while its parent is All;
that selection is ignored by score/goal retrieval until its parent levels are
explicitly selected. No automatic clearing or disabled UI state is claimed.

[PHASE_5_FILTER_VALIDATION.dax](PHASE_5_FILTER_VALIDATION.dax) contains shared
DEFINE fixtures and two EVALUATE blocks. Execute DEFINE with either block.
Actual Desktop results are retained in
[PHASE_5_FILTER_Q1.txt](PHASE_5_FILTER_Q1.txt) (20/20 PASS) and
[PHASE_5_FILTER_Q2.txt](PHASE_5_FILTER_Q2.txt) (6/6 PASS). They cover stale,
invalid, conflicting, and multi-selected ignored children; valid display/number
scopes; invalid active levels; and native SUMMARIZECOLUMNS filter semantics.
All ten Phase 4 queries were rerun: 1,595 PASS, only the same two explicitly
approved historical exceptions, and no new unapproved gate failures.

Final manual/native interaction acceptance still needs cascading dropdown
choices, clearing selections, and period changes checked on the actual shell.
Do not start Phase 6 until that remaining Phase 5 exit check is complete.

## Phase 6: Header Scores

- [ ] Display supplied Total Overall, Care, Service, and Share scores/colors.
- [ ] Confirm change-badge meaning/source before implementing badges.
- [ ] Match ring presentation, tooltip content, and blank states.
- [ ] Test organization filters and protect fixed KPI metrics from matrix clicks.
- [ ] Validate data and appearance in Desktop.

## Phase 7: Main Matrix

- [ ] Prove the least complex native visual approach with representative rows.
- [ ] Show YTD, neutral Goal, and four/five dynamic weekly columns.
- [ ] Keep score and underlying display independently formatted and colored.
- [ ] Use supplied Total Overall/group rows, never calculated subtotals.
- [ ] Verify indentation, visibility flags, order, mixed formats, and missing data.
- [ ] Verify scrolling/alignment, interactions, and export behavior.

## Phase 8: Period Navigation

- [ ] Implement a supported single-period selection mechanism.
- [ ] Keep selected label, fiscal filter, and weekly columns synchronized.
- [ ] Test previous/next, first/latest period, and fiscal-year boundaries.
- [ ] Test four-week and available five-week periods.
- [ ] Confirm buttons do not reset organization filters.

## Phase 9: Visual Refinement

- [ ] Compare against Screenshot Dashboard Period 10.png at equivalent scaling.
- [ ] Check values, labels, row/week order, formats, and colors.
- [ ] Check typography, spacing, borders, alignment, and canvas dimensions.
- [ ] Check help, filters, navigation, and clipping after Desktop save/reopen.
- [ ] Retain screenshots and document remaining differences.

## Phase 10: Release Readiness

- [ ] Pass Desktop open/save/reopen and refresh tests.
- [ ] Verify TMDL/PBIR references, unique IDs, and encoding.
- [ ] Regress ALL, Division, District, and Site scopes.
- [ ] Review performance and accessibility.
- [ ] Review Git diff; document deployment credentials/access requirements.
- [ ] Record release commit/tag and non-destructive rollback procedure.
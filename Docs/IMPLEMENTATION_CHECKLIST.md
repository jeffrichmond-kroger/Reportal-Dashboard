# Reportal Dashboard Implementation Checklist

Updated: 2026-11-17

Stop at each phase until all its exit checks pass. Static checks do not prove
Desktop rendering, refresh, DAX evaluation, or data accuracy. Phase 4 must pass
before final visual recreation. Do not mark a phase complete based only on edits.

## Confirmed Decisions

- Baseline: `761683e` (`docs`); reference files committed.
- User confirmed the baseline opens and refreshes with intended credentials.
- User confirmed the source can verify fact-grain uniqueness and the YTD endpoint;
  query results and the exact endpoint rule still need to be recorded.
- Organization remains disconnected; use supplied ALL/DIV/DIST/SITE results.
- Never sum Site results to produce broader scopes or recalculate supplied scores.
- YTD GoalValue is numeric and supplies the legacy Goal column.
- Weekly GoalText is authoritative text; preserve supplied formatting.
- Invalid, ambiguous, or conflicting organization selections return blank.
- Preserve source connections, types, identifiers, and unrelated user changes.

## Phase Status

- [x] Phase 0: baseline and project safety established before implementation.
- [x] Phase 1: semantic-model cleanup (user accepted 2026-11-17).
- [x] Phase 2: organization-scope logic (runtime gate passed 2026-11-17).
- [ ] Phase 3: base retrieval measures (source endpoint/format profiling in progress).
- [ ] Phase 4: semantic-model data validation (major gate).
- [ ] Phase 5: report shell.
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

- [x] Prepare read-only source profiling queries; loaded results pending.
- [ ] Define and verify the selected-period YTD endpoint rule.
- [ ] Retrieve YTD score, display value, goal, and color from supplied rows.
- [ ] Retrieve weekly score, display value, goal text, color, and arrow.
- [ ] Add selected period, week, and date labels.
- [ ] Require one metric, one scope, and one applicable time endpoint per result.
- [ ] Detect duplicate rows rather than masking them with MAX or SELECTEDVALUE.
- [ ] Retain display-only results when ScoreValue is blank; preserve valid zero.
- [ ] Compile and evaluate DAX in Desktop before Phase 4.

### Phase 3 Source Profiling Gate

Run the four EVALUATE blocks in [PHASE_3_VALIDATION.dax](PHASE_3_VALIDATION.dax)
and retain outputs as PHASE_3_Q1.txt through PHASE_3_Q4.txt in Docs.
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

These are raw-row/metadata diagnostics, not score aggregation or final Phase 4
comparisons. No retrieval measure has yet selected an assumed YTD endpoint.
If Q1 has multiple snapshots, establish the business endpoint before retrieving
a single one; never average or sum them. If rows are missing, investigate before
introducing fallbacks. Source availability and current-period cutoff rules must
be distinguished from the maximum week present in the fiscal calendar.

## Phase 4: Data Validation

Required comparison columns: Legacy expected | Power BI actual | Difference |
Pass/Fail. Use exact equality for integer scores/counts. For unrounded percentage
values, use absolute difference <= 0.000001 where source precision permits.
Rounded screenshot percentages and million values are display checks, not exact
raw numeric expectations.

- [ ] Confirm Period 10, fiscal year 2026, scope ALL, and correct YTD endpoint.
- [ ] YTD Total Overall/Care/Service/Share = 65/72/83/45.
- [ ] Weekly Total Overall W37-W40 = 64/65/66/65.
- [ ] Weekly Care W37-W40 = 66/69/70/69.
- [ ] Weekly Service W37-W40 = 86/86/87/87.
- [ ] Weekly Share W37-W40 = 45/45/45/44.
- [ ] Auto Refill scores = 94/94/94/94; display = 61.2%/61.2%/61.1%/61.1%.
- [ ] Completed Clinical Interactions = 13,853/15,165/16,263/15,062; no score.
- [ ] Rx Sold scores = 90/90/90/88; display = 6.79M/6.75M/6.79M/6.93M.
- [ ] Verify percentage precision, one red metric, goals, colors, and row order.
- [ ] Verify fact uniqueness and missing-row behavior; retain comparison evidence.
- [ ] Explicitly accept the data gate before final report visuals.

## Phase 5: Report Shell

- [ ] Establish 1920 x 1080 layout, background, and left filters.
- [ ] Configure cascading Division/District/Site filters: All or one.
- [ ] Add period area and help placeholder without invented behavior.
- [ ] Define unique visual names, accessible labels, and tab order.
- [ ] Test filter behavior and layout before adding header visuals.

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
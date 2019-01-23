# ToDo list and notepad for "Fernerkundung für Global Ökologie" course (SS2019 update)

## Items

- Update command cheatsheets (in lyx): create incremental versions for each day
- Extend R-introduction docs (2-day setup): writing and reading files, some plotting, aggregation etc., ...
- Create one file structure for everyone and select regions (should fit 1GB max and will stay on everyones machine)
- choose best regions for topics (see below)
- homework (easy to parse and check, Lückentext, questions that check understanding of topic, create dedicated skeleton homework R-files that will also receive the text answers as comments)
- add 10min each session to discuss homework in detail
- end of day 2 we do a test reporting (us) from what we saw during the first two days
- day2: demonstrate how to pull data from MODIS servers (example only?)

## New file structure:

```
coursedir
   +- data/topic/region
   +- plots/ (names: hw_ for homework)
   +- script<1, …>.R (all scripts etc.) 
   +- fe_functions.R (helper script)
```

## Selected regions per topic

- PHENO: some temperate/ tropical for comparison
- NPP/GPP: EUROPE (should have many land uses)
- LUC: BORNEO (deforestation, …)
- LAI: ???
- FIRE: SAFRICA

## Next steps

1. improve intro section (2 days of R)
2. decide on regions and create new file structure
3. improve each session in order
	- update command cheatsheets
	- enhance homework and course questions
	- introduce more code fragments that need to be filled
	- create homework skeleton R files
4. download new fire data

let
    Source = Csv.Document(File.Contents("C:\Users\ASUS\Desktop\Uncleaned_DS_jobs.csv"),[Delimiter=",", Columns=15, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"index", Int64.Type}, {"Job Title", type text}, {"Salary Estimate", type text}, {"Job Description", type text}, {"Rating", Int64.Type}, {"Company Name", type text}, {"Location", type text}, {"Headquarters", type text}, {"Size", type text}, {"Founded", Int64.Type}, {"Type of ownership", type text}, {"Industry", type text}, {"Sector", type text}, {"Revenue", type text}, {"Competitors", type text}}),
    #"Extracted Text Before Delimiter (salary estimate)" = Table.TransformColumns(#"Changed Type", {{"Salary Estimate", each Text.BeforeDelimiter(_, " ("), type text}}),
    #"Inserted Min Sale" = Table.AddColumn(#"Extracted Text Before Delimiter (salary estimate)", "Min Sale", each Text.BetweenDelimiters([Salary Estimate], "$", "K"), type text),
    #"Inserted Max Sale" = Table.AddColumn(#"Inserted Min Sale", "Max Sale", each Text.BetweenDelimiters([Salary Estimate], "$", "K", 1, 0), type text),
    #"Added Role Type (M Language)" = Table.AddColumn(#"Inserted Max Sale", "Role Type", each if Text.Contains([Job Title], "Data Analyst") then "Data Analyst"
else if Text.Contains([Job Title], "Data Scientist") then "Data Scientist"
else if Text.Contains([Job Title], "Data Engineer") then "Data Engineer"
else if Text.Contains([Job Title], "Machine Learning Engineer") then "Machine Learning Engineer"
else "Other"),
    #"Role Type Changed to the Text" = Table.TransformColumnTypes(#"Added Role Type (M Language)",{{"Role Type", type text}}),
    #"Filtered -1 and ""Unknown"" in the Size" = Table.SelectRows(#"Role Type Changed to the Text", each ([Size] <> "-1" and [Size] <> "Unknown")),
    #"Added ""Location Correction""" = Table.AddColumn(#"Filtered -1 and ""Unknown"" in the Size", "Location Correction", each if [Location] = "California" then ", CA"
else if [Location] = "New Jersey" then ", NJ"
else if [Location] = "Remote" then ", Other"
else if [Location] = "United States" then ", Other"
else if [Location] = "Texas" then ", TX"
else if [Location] = "Utah" then ", UT"
else [Location]),
    #"Split ""Location Correction"" by Delimiter" = Table.SplitColumn(#"Added ""Location Correction""", "Location Correction", Splitter.SplitTextByDelimiter(", ", QuoteStyle.Csv), {"Location Correction.1", "State Abbreviation"}),
    #"Changed Type of Splitted Columns" = Table.TransformColumnTypes(#"Split ""Location Correction"" by Delimiter",{{"Location Correction.1", type text}, {"State Abbreviation", type text}}),
    #"Anne Arundel Replaced with MD in State Abbreviation" = Table.ReplaceValue(#"Changed Type of Splitted Columns","Anne Arundel","MD",Replacer.ReplaceText,{"State Abbreviation"}),
    #"Type of Min Sale and Max Sale changed to Currency" = Table.TransformColumnTypes(#"Anne Arundel Replaced with MD in State Abbreviation",{{"Min Sale", Currency.Type}, {"Max Sale", Currency.Type}}),
    #"Min Sale multiplied with 1000" = Table.TransformColumns(#"Type of Min Sale and Max Sale changed to Currency", {{"Min Sale", each _ * 1000, Currency.Type}}),
    #"Max Sale multiplied with 1000" = Table.TransformColumns(#"Min Sale multiplied with 1000", {{"Max Sale", each _ * 1000, Currency.Type}}),
    #"State names and abbreviations matched by states query" = Table.NestedJoin(#"Max Sale multiplied with 1000", {"State Abbreviation"}, states, {"2-letter USPS"}, "states", JoinKind.LeftOuter),
    #"State name indicated by expanding" = Table.ExpandTableColumn(#"State names and abbreviations matched by states query", "states", {"Full Name"}, {"State Long Name"}),
    #"Filtered null values in the State Long Name" = Table.SelectRows(#"State name indicated by expanding", each ([State Long Name] <> null)),
    #"Removed unnecessary columns" = Table.RemoveColumns(#"Filtered null values in the State Long Name",{"Location Correction.1"})
in
    #"Removed unnecessary columns"

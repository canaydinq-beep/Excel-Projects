let
    Source = Uncleaned_DS_jobs,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Min Sale", "Max Sale", "State Long Name"}),
    #"Grouped Rows" = Table.Group(#"Removed Other Columns", {"State Long Name"}, {{"Job Count", each Table.RowCount(_), Int64.Type}, {"Average Min Salary", each List.Average([Min Sale]), type number}, {"Average Max Salary", each List.Average([Max Sale]), type number}, {"AllRows", each _, type table [Min Sale=number, Max Sale=number, State Long Name=nullable text]}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Grouped Rows",{{"Average Min Salary", Currency.Type}, {"Average Max Salary", Currency.Type}}),
    #"Sorted Rows" = Table.Sort(#"Changed Type",{{"Average Max Salary", Order.Descending}})
in
    #"Sorted Rows"

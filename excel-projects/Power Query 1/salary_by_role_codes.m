let
    Source = Uncleaned_DS_jobs,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Min Sale", "Max Sale", "Role Type"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Removed Other Columns",{{"Min Sale", Currency.Type}, {"Max Sale", Currency.Type}}),
    #"Multiplied Min Sale with 1000" = Table.TransformColumns(#"Changed Type", {{"Min Sale", each _ * 1000, Currency.Type}}),
    #"Multiplied Max Sale with 1000" = Table.TransformColumns(#"Multiplied Min Sale with 1000", {{"Max Sale", each _ * 1000, Currency.Type}}),
    #"Grouped by Role Type" = Table.Group(#"Multiplied Max Sale with 1000", {"Role Type"}, {{"Job Count", each Table.RowCount(_), Int64.Type}, {"Average Min Sale", each List.Average([Min Sale]), type number}, {"Average Max Sale", each List.Average([Max Sale]), type number}, {"AllRows", each _, type table [Min Sale=number, Max Sale=number, Role Type=nullable text]}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Grouped by Role Type",{{"Average Min Sale", Currency.Type}, {"Average Max Sale", Currency.Type}}),
    #"Sorted Rows" = Table.Sort(#"Changed Type1",{{"Average Max Sale", Order.Descending}})
in
    #"Sorted Rows"

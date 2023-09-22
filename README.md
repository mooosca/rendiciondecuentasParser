# rendiciondecuentasParser
Parser.raku

Parse a serie of html files from

    Estado de liquidación del presupuesto
        Liquidación del Presupuesto de Gastos/Ingresos
            Por aplicaciones presupuestarias
                Detalle
                
extracting the contained table from each page (html file) and
returning a CSV file of all accumulated values.

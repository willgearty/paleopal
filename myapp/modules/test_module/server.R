occs <- metaReactive2({
  req(input$genus)
  isolate(metaExpr({
    pbdb_occurrences(taxon_name = ..(input$genus),
                     vocab = "pbdb", show = "coords")
  }))
}, varname = "occs")
# make a map of occs with ggplot
output$map <- metaRender(renderPlot, {
  ggplot(..(occs()), aes(x = lng, y = lat)) +
    borders("world") +
    geom_point(color = "red") +
    coord_sf()
})
code_chain <- append(code_chain, quote(invisible(occs())))
code_chain <- append(code_chain, quote(c()))
code_chain <- append(code_chain, quote(output$map()))
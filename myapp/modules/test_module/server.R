# add libraries to load at the beginning of the report
libraries_chain <- append(libraries_chain, quote(quote(library(paleobioDB))))

occs <- metaReactive2({
  req(input$genus)
  isolate(metaExpr({
    pbdb_occurrences(taxon_name = ..(input$genus),
                     vocab = "pbdb", show = "coords")
  }))
}, varname = "occs")
# make a map of occs with ggplot
output$map1 <- metaRender(renderPlot, {
  ggplot(..(occs()), aes(x = lng, y = lat)) +
    borders("world") +
    geom_point(color = "red") +
    coord_sf()
})
output$code1 <- renderPrint({
  expandChain(
    invisible(occs()),
    output$map1()
  )
})
code_chain <- append(code_chain, quote(invisible(occs())))
code_chain <- append(code_chain, quote(c()))
code_chain <- append(code_chain, quote(output$map1()))

-module (web_samples_viewsource).
-include ("wf.inc").
-compile(export_all).

main() ->
    Module = wf:q(module),

    % Only show code to a web module...
    Module1 = case Module of
        "web_samples" ++ _ -> list_to_atom(Module);
        _ -> web_samples
    end,
    get_source(Module1).

get_source(undefined) -> "";
get_source(Module) ->		
    CompileInfo = Module:module_info(compile),
    Source = proplists:get_value(source, CompileInfo),
    {ok, B} = file:read_file(Source),
    [
        "<pre>",
        replacements(wf:to_list(B)),
        "</pre>"
    ].

replacements([]) -> [];
replacements([$<|T]) -> [$&,$l,$t,$;|replacements(T)];
replacements([$\t|T]) -> [$\s, $\s|replacements(T)];
replacements([H|T]) -> [H|replacements(T)].

event(_) -> ok.

use mlua::prelude::*;
use pulldown_cmark::{Parser, html};

#[mlua::lua_module]
fn liblego(lua: &Lua) -> LuaResult<LuaTable> {
    let m = lua.create_table()?;
    m.set("md_to_html", lua.create_function(md_to_html)?)?;
    Ok(m)
}

fn md_to_html(_: &Lua, markdown: String) -> LuaResult<String> {
    let parser = Parser::new(&markdown);
    let mut html_output = String::new();
    html::push_html(&mut html_output, parser);
    if html_output.is_empty() {
        return Err("html_output is empty".into_lua_err());
    }

    Ok(html_output)
}

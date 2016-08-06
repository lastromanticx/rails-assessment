module ListsHelper
  def format_search_query_text(query_hash)
    str = "You searched for: \"#{query_hash["query"]}\" in " 
    str += query_hash["list_id"].match(/\S/) ? "list #{query_hash["list_id"]}" : "all your lists"
    str + "."
  end
end

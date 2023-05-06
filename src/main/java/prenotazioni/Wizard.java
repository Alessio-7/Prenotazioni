package prenotazioni;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

public class Wizard {

	public static String generateTabsObject( TreeStep<ArrayList<Campo>> step ) {
		String ritorno = "var oTabs = {\n";

		ritorno += rGenerateTabsObject( step );
		ritorno = ritorno.substring( 0, ritorno.length() - 1 );// rimuove la virgola in più

		ritorno += "};";
		return ritorno;
	}

	private static String rGenerateTabsObject( TreeStep<ArrayList<Campo>> step ) {
		String ritorno = "";

		if ( step.isRoot() ) {
			ritorno += "\"root\":[\"\", [";
		} else {
			ritorno += "\"tab-"
					+ step.getIdName()
					+ "\":[\""
					+ ( !step.getParent().isRoot() ? "tab-"
							+ step.getParent().getIdName() : "root" )
					+ "\", [";
		}
		if ( step.getChilds().size() > 0 ) {
			for ( TreeStep<ArrayList<Campo>> child : step.getChilds() ) {
				ritorno += "\"tab-"
						+ child.getIdName()
						+ "\",";
			}
			ritorno = ritorno.substring( 0, ritorno.length() - 1 );// rimuove la virgola in più
		}
		ritorno += "]],";

		for ( TreeStep<ArrayList<Campo>> child : step.getChilds() ) {
			ritorno += rGenerateTabsObject( child );
		}

		return ritorno;
	}

	public static String generateTreeTabs( TreeStep<ArrayList<Campo>> step ) {

		String ritorno = "";

		ritorno += "<div class=\"tab\" id=\""
				+ ( !step.isRoot() ? "tab-"
						+ step.getIdName() : "root" )
				+ "\"><h3>"
				+ step.getName()
				+ "</h3>";

		for ( int i = 0; i < step.getValue().size(); i++ ) {
			ritorno += step.getValue().get( i ).generaCampo( i );
		}

		ritorno += "</div>\n";

		for ( TreeStep<ArrayList<Campo>> child : step.getChilds() ) {
			ritorno += generateTreeTabs( child );
		}

		return ritorno;
	}

	public static String generateLinearTabs( LinkedHashMap<String, ArrayList<Campo>> tabs ) {

		String ritorno = "";

		for ( Map.Entry<String, ArrayList<Campo>> tab : tabs.entrySet() ) {
			ritorno += "<div class=\"tab\"><h3>"
					+ tab.getKey()
					+ "</h3>";

			for ( Campo campo : tab.getValue() ) {
				ritorno += campo.generaCampo( 0 );
			}

			ritorno += "</div>\n";
		}

		return ritorno;
	}

	public static class Campo {
		String type;
		String nome;
		String label;

		public Campo( String type, String nome, String label ) {
			this.type = type;
			this.nome = nome;
			this.label = label;
		}

		public String generaCampo( int i ) {
			switch ( type ) {
				case "branchSelector":
					return "<button type=\"button\" class=\"branchBtn\" id=\""
							+ nome
							+ "\"onclick=\"nextPrev("
							+ i
							+ ")\">"
							+ label
							+ "</button><br>";
				case "select":
					return "<div class=\"form-group\"><label class=\"form-label\" for=\""
							+ nome
							+ "\">"
							+ label
							+ "</label><select class=\"form-select\" id=\""
							+ nome
							+ "\" name=\""
							+ nome
							+ "\"></select></div>";
				case "multiSelect":
					return "<div class=\"form-group\"><label class=\"form-label\" for=\""
							+ nome
							+ "\">"
							+ label
							+ "</label><select multiple class=\"form-select\" id=\""
							+ nome
							+ "\" name=\""
							+ nome
							+ "\"></select></div>";
				case "hidden":
					return "<input type=\"hidden\" name=\""
							+ nome
							+ "\" id=\""
							+ nome
							+ "\"></input>";
				default:
					return "<div class=\"form-group\"><label class=\"form-label\" for=\""
							+ nome
							+ "\">"
							+ label
							+ "</label><input class=\"form-control\" type=\""
							+ type
							+ "\" id=\""
							+ nome
							+ "\" name=\""
							+ nome
							+ "\" required></div>";
			}
		}
	}
}

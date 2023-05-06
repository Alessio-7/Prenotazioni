package prenotazioni;

import java.util.ArrayList;
import java.util.List;

public class TreeStep<T> {
	private List<TreeStep<T>> childs;
	private TreeStep<T> parent;

	private String name;
	private T value;
	private int id;

	public TreeStep( String name, T value ) {
		this( null, name, value );
	}

	private TreeStep( TreeStep<T> parent, String name, T value ) {
		childs = new ArrayList<TreeStep<T>>();
		this.parent = parent;
		this.name = name;
		this.value = value;
		id = -1;
	}

	public boolean isRoot() {
		return parent == null;
	}

	public TreeStep<T> addChild( String name, T value ) {
		TreeStep<T> child = new TreeStep<T>( this, name, value );
		childs.add( child );
		return child;
	}

	public List<TreeStep<T>> getChilds() {
		return childs;
	}

	public TreeStep<T> getParent() {
		return parent;
	}

	public String getName() {
		return name;
	}

	public T getValue() {
		return value;
	}

	public String getIdName() {
		return name + ( id == -1 ? ""
				: ""
						+ id );
	}

	public void addIdToName() {
		IdCounter id = new IdCounter();
		for ( TreeStep<T> child : childs ) {
			child.rAddIdToName( id );
		}
	}

	private void rAddIdToName( IdCounter id ) {
		this.id = id.next();

		if ( childs.isEmpty() ) {
			return;
		}

		for ( TreeStep<T> child : childs ) {
			child.rAddIdToName( id );
		}
	}

	private class IdCounter {
		int id;

		public IdCounter() {
			id = 0;
		}

		public int next() {
			return id++ ;
		}
	}
}
package tr.edu.gsu.peralab.mobilesensing.web.entity;

import java.io.Serializable;

public enum Activity implements Serializable {

	BICYCLE("Bisikletli"), WALKING("Y�r�yor"), STATIONARY("Hareketsiz"), NEITHER("Hi�biri"), CHILLING("Titriyor");
	
	private String label;

	private Activity(String label) {
		this.label = label;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

}

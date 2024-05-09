import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Selector implements ActionListener {

    public JFrame frame;
    JTextField textfield;
    JButton calc, chem;
    JPanel buttonpanel;

    Font font = new Font("Arial",Font.PLAIN,25);

    Selector () {
        
        frame = new JFrame("Selection Menu");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(420, 820);
        frame.setLayout(null);

        textfield = new JTextField();
        textfield.setBounds(40, 300, 310, 50);
        textfield.setFont(font);
        textfield.setText("Select your choice operation");
        textfield.setEditable(false);

        buttonpanel = new JPanel();
        buttonpanel.setBounds(40, 360, 310, 75);
        buttonpanel.setLayout(new GridLayout(1, 2, 10, 10));

        calc = new JButton("Calculator");
        calc.addActionListener(this);
        calc.setFont(font);
        calc.setFocusable(false);
        buttonpanel.add(calc);

        chem = new JButton("Chemistry");
        chem.addActionListener(this);
        chem.setFont(font);
        chem.setFocusable(false);
        buttonpanel.add(chem);

        frame.add(buttonpanel);
        frame.add(textfield);
        frame.setVisible(true);
    }

    public void reset () {
        frame.setVisible(true);
    }

    private static Calculator calculator;
    private static chemistry chemistry;
    public static void main(String[] args) {
        Selector sel = new Selector();
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if(e.getSource() == calc) {
            calculator = new Calculator();
            frame.setVisible(false);
        }
        if(e.getSource() == chem) {
            chemistry = new chemistry();
            frame.setVisible(false);
        }
    }
}

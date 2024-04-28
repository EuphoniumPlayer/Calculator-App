import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Selector implements ActionListener{

    JFrame frame;
    JTextField textfield;
    JButton calc, chem;
    JPanel buttonpanel;

    Font font = new Font("Arial",Font.PLAIN,30);

    Selector () {
        
        frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(420, 800);
        frame.setLayout(null);

        textfield = new JTextField();
        textfield.setBounds(50, 25, 300, 50);
        textfield.setFont(font);
        textfield.setEditable(false);

        calc = new JButton("Calculator");
        calc.addActionListener(this);
        calc.setFont(font);
        calc.setFocusable(false);
        chem = new JButton("Chemistry");
        chem.addActionListener(this);
        calc.setFont(font);
        chem.setFocusable(false);

        frame.setVisible(true);
    }

    private static Calculator calculator;
    public static void main(String[] args) {
        Selector sel = new Selector();
    }

    @Override
    public void actionPerformed(ActionEvent e) {

    }
}

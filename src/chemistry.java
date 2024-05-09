import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class chemistry implements ActionListener {
    JFrame frame;
    JTextField textfield;
    JButton returnbut;
    //TODO: Add buttons and panel
    private Selector sel = new Selector();

    chemistry () {

        frame = new JFrame("Under Contruction");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(420, 820);
        frame.setLayout(null);

        textfield = new JTextField();
        textfield.setBounds(40, 300, 310, 50);
        textfield.setFont(new Font("Arial",Font.ITALIC,30));
        textfield.setText("Under Construction");
        textfield.setEditable(false);

        returnbut = new JButton("Return");
        returnbut.setBounds(40, 360, 310, 74);
        returnbut.setFont(new Font("Arial",Font.BOLD,30));
        returnbut.addActionListener(this);
        returnbut.setFocusable(false);

        frame.add(returnbut);
        frame.add(textfield);
        frame.setVisible(true);

    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if(e.getSource() == returnbut) {
            sel.reset();
            frame.setVisible(false);
        }
    }
}

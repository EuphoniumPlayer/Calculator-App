import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class App implements ActionListener{

    JFrame frame;
    JTextField textfield;
    JButton[] numberbutton = new JButton[10];
    JButton[] functionbutton = new JButton[9];
    JButton addbutton,subbutton,mulbutton,divbutton;
    JButton decbutton, equbutton, delbutton, clrbutton, negbutton;
    JPanel panel;

    Font font = new Font("Arial",Font.PLAIN,30);

    double num1 = 0, num2 = 0, rslt = 0;
    char operator;

    App (){

        frame = new JFrame("Calculator");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(420, 550);
        frame.setLayout(null);

        textfield = new JTextField();
        textfield.setBounds(50, 25, 300, 50);
        textfield.setFont(font);
        textfield.setEditable(false);

        addbutton = new JButton("+");
        subbutton = new JButton("-");
        mulbutton = new JButton("x");
        divbutton = new JButton("/");
        decbutton = new JButton(".");
        equbutton = new JButton("=");
        delbutton = new JButton("del");
        clrbutton = new JButton("clr");
        negbutton = new JButton("+/-");

        functionbutton[0] = addbutton;
        functionbutton[1] = subbutton;
        functionbutton[2] = mulbutton;
        functionbutton[3] = divbutton;
        functionbutton[4] = decbutton;
        functionbutton[5] = equbutton;
        functionbutton[6] = delbutton;
        functionbutton[7] = clrbutton;
        functionbutton[8] = negbutton;

        for(int i =0;i<9;i++) {
            functionbutton[i].addActionListener(this);
            functionbutton[i].setFont(font);
            functionbutton[i].setFocusable(false);
        }

        for(int i =0;i<10;i++) {
            numberbutton[i] = new JButton(String.valueOf(i));
            numberbutton[i].addActionListener(this);
            numberbutton[i].setFont(font);
            numberbutton[i].setFocusable(false);
        }

        negbutton.setBounds(50,430,100,50);
        delbutton.setBounds(150,430,100,50);
        clrbutton.setBounds(250,430,100,50);

        panel = new JPanel();
        panel.setBounds(50, 100, 300, 300);
        panel.setLayout(new GridLayout(4,4,10,10));

        panel.add(numberbutton[1]);
        panel.add(numberbutton[2]);
        panel.add(numberbutton[3]);
        panel.add(addbutton);
        panel.add(numberbutton[4]);
        panel.add(numberbutton[5]);
        panel.add(numberbutton[6]);
        panel.add(subbutton);
        panel.add(numberbutton[7]);
        panel.add(numberbutton[8]);
        panel.add(numberbutton[9]);
        panel.add(mulbutton);
        panel.add(decbutton);
        panel.add(numberbutton[0]);
        panel.add(equbutton);
        panel.add(divbutton);

        frame.add(panel);
        frame.add(negbutton);
        frame.add(delbutton);
        frame.add(clrbutton);
        frame.add(textfield);
        frame.setVisible(true);

    }

    public static void main(String[] args) {
        App app = new App();
    }

    @Override
    public void actionPerformed(ActionEvent e) {

        for(int i=0;i<10;i++) {
            if(e.getSource() == numberbutton[i]) {
                textfield.setText(textfield.getText().concat(String.valueOf(i)));
            }
        }
        if(e.getSource() == decbutton) {
            textfield.setText(textfield.getText().concat("."));
        }
        if(e.getSource() == addbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = '+';
            textfield.setText("");
        }
        if(e.getSource() == subbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = '-';
            textfield.setText("");
        }
        if(e.getSource() == mulbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = '*';
            textfield.setText("");
        }
        if(e.getSource() == divbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = '/';
            textfield.setText("");
        }
        if(e.getSource() == equbutton) {
            num2 = Double.parseDouble(textfield.getText());
            switch (operator) {
                case '+':
                    rslt = num1 + num2;
                    break;
                case '-':
                    rslt = num1 - num2;
                    break;
                case '*':
                    rslt = num1 * num2;
                    break;
                case '/':
                    rslt = num1 / num2;
            }
            textfield.setText(String.valueOf(rslt));
            num1=rslt;
        }
        if (e.getSource() == clrbutton) {
            textfield.setText("");
        }
        if (e.getSource() == delbutton) {
            String string = textfield.getText();
            textfield.setText("");
            for(int i = 0; i<string.length() - 1; i++) {
                textfield.setText(textfield.getText() + string.charAt(i));
            }
        }
        if (e.getSource() == negbutton) {
            double temp = Double.parseDouble(textfield.getText());
            temp*= -1;
            textfield.setText(String.valueOf(temp));
        }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Perfumaria
{
    public partial class Main : Form
    {
        private String path;

        private SqlConnection cn;
        public Main()
        {
            InitializeComponent();
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            if (verifySGBDConnection())
            {
                Console.WriteLine("Conexão");
            }
            else
            {
                DialogResult result;
                result = MessageBox.Show("Sem conexão à Base de Dados", "Erro!", MessageBoxButtons.OK);
                if (result == DialogResult.OK)
                {
                    System.Environment.Exit(1);
                }

            }

            cn.Close();

        }

        private SqlConnection getSGBDConnection()
        {
            String dbServer = "tcp:mednat.ieeta.pt\\SQLSERVER,8101";
            String dbName = "p6g1";
            String userName = "p6g1";
            String userPass = "almeidapaiva1@Bd";
            return new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + ";" + "password = " + userPass);
        }

        private bool verifySGBDConnection()
        {
            if (cn == null)
                cn = getSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }

        //LOGIN
        private void button1_Click(object sender, EventArgs e)
        {
            bool type = false;
            String rm = null;
            DialogResult result;

            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("perf.Login", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@email", emaillogin.Text);
            cmd.Parameters.AddWithValue("@password", pwlogin.Text);
            cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;
            cmd.Parameters.Add("@type", SqlDbType.Bit).Direction = ParameterDirection.Output;



            try
            {
                cmd.ExecuteNonQuery();
                rm = cmd.Parameters["@responseMessage"].Value.ToString();
                type = (bool)cmd.Parameters["@type"].Value;

            }
            catch (Exception ex)
            {
                throw new Exception("Failed to login. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                if (!rm.Equals("Invalid login") && !rm.Equals("Incorrect password"))
                {
                    // Funcionário
                    if (type)
                    {
                        result = MessageBox.Show(rm, "caption", MessageBoxButtons.OK);
                        if (result == DialogResult.OK)
                        {
                            Program.FuncMail = emaillogin.Text;
                            Program.OpenFunc = true;
                            this.Close();
                        }
                    }
                    // Cliente
                    else
                    {
                        result = MessageBox.Show(rm, "caption", MessageBoxButtons.OK);
                        if (result == DialogResult.OK)
                        {
                            Program.ClientMail = emaillogin.Text;
                            Program.OpenClient = true;
                            this.Close();
                        }
                    }
                }
                else
                {
                    MessageBox.Show(rm);
                }

                cn.Close();
            }
        }

        //REGISTO
        private void button2_Click(object sender, EventArgs e)
        {
           
            Registo.Visible = true;
             var myDate = DateTime.Now;
            nascimento.MaxDate = myDate.AddYears(-18);
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void label6_Click(object sender, EventArgs e)
        {

        }

        private void label8_Click(object sender, EventArgs e)
        {

        }

        private void label8_Click_1(object sender, EventArgs e)
        {

        }

        private void label9_Click(object sender, EventArgs e)
        {

        }

        private void newsletter_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void Registo_Paint(object sender, PaintEventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void back_Click(object sender, EventArgs e)
        {
            Registo.Visible = false;
        }

        private void sex_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        // Registrar
        private void Registrar_Click(object sender, EventArgs e)
        {

            if (!verifySGBDConnection())
                return;

            String rm = null;
            DialogResult result;

            SqlCommand cmd = new SqlCommand("perf.RegisterClient", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@email", email.Text);
            if (pw.Text.Equals(confirmpw.Text))
            {
                cmd.Parameters.AddWithValue("@password", pw.Text);
            }
            cmd.Parameters.AddWithValue("@contribuinte", contribuinte.Text);
            cmd.Parameters.AddWithValue("@fname", fname.Text);
            cmd.Parameters.AddWithValue("@lname", lname.Text);
            if (newsletter.Checked)
                cmd.Parameters.AddWithValue("@newsletter", 1);
            else
                cmd.Parameters.AddWithValue("@newsletter", 0);
            if (sex.SelectedIndex == 0)
                cmd.Parameters.AddWithValue("@sexo", 1);
            else if (sex.SelectedIndex == 1)
                cmd.Parameters.AddWithValue("@sexo", 0);
            else
                return;

            cmd.Parameters.AddWithValue("@dataNasc", nascimento.Value.ToString("yyyy-MM-dd"));

            cmd.Parameters.AddWithValue("@foto", path);

            cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

            try
            {
                cmd.ExecuteNonQuery();
                rm = cmd.Parameters["@responseMessage"].Value.ToString();
                Console.WriteLine(rm);

            }
            catch (Exception ex)
            {
                throw new Exception("Failed to Register. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                if (rm.Equals("Success"))
                {
                    result = MessageBox.Show(rm, "caption", MessageBoxButtons.OK);
                    if (result == DialogResult.OK)
                        Registo.Visible = false;
                }
                else
                {
                    MessageBox.Show(rm);
                }

                cn.Close();
            }

        }

        private void button3_Click(object sender, EventArgs e)
        {
            OpenFileDialog open = new OpenFileDialog();
            open.Filter = "Images (*.BMP;*.JPG;*.JPEG;*.GIF,*.PNG,*.TIFF)|*.BMP;*.JPEG;*.JPG;*.GIF;*.PNG;*.TIFF";
            open.FilterIndex = 1;
            open.Multiselect = false;
            open.RestoreDirectory = true;
            open.CheckPathExists = true;
            open.CheckFileExists = true;
            open.Title = "Escolher uma imagem de perfil";
            DialogResult result = open.ShowDialog();
            if (result == DialogResult.OK)
            {
                path = open.FileName;

            }
        }

        private void nascimento_ValueChanged(object sender, EventArgs e)
        {
           
        }
    }
}

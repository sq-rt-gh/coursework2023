using Npgsql;
using System;
using System.Data;
using System.Windows.Forms;

namespace ClientApp
{
    public partial class LoginForm : Form
    {
        NpgsqlConnection conn = new NpgsqlConnection("Server=localhost;Port=5432;User Id=client;Password=123;Database=airplanes");
        User user;

        public LoginForm()
        {
            InitializeComponent();
        }

        private bool GetUser()
        {
            try 
            { 
                conn.Open();
                NpgsqlCommand cmd = new NpgsqlCommand($"select * from get_passenger('{psprtMaskedTextBox.Text}');", conn);
                
                var dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                if (dt.Rows.Count != 0)
                {
                    user = new User();
                    user.Id = (int)dt.Rows[0][0];
                    user.FIO = dt.Rows[0][1].ToString();
                    user.Passport = dt.Rows[0][2].ToString();

                    return true;
                }
            } 
            catch (Exception ex)
            { 
                MessageBox.Show(ex.Message);
            }
            finally 
            { 
                conn.Close(); 
            }
            return false;
        }

        private void PsprtMaskedTextBox_TextChanged(object sender, EventArgs e)
        {
            if (psprtMaskedTextBox.MaskCompleted)
            {
                if (GetUser())
                {
                    fullNameTextBox.Text = user.FIO;
                    userBtn.Enabled = true;
                    userBtn.Text = "Log in";
                }
                else
                {
                    fullNameTextBox.Enabled = true;
                    fullNameTextBox.Focus();
                    userBtn.Text = "Sign up";
                }
                userBtn.Select();
            }
            else
            {
                userBtn.Enabled = false;
                fullNameTextBox.Enabled = false;
                fullNameTextBox.Text = "";
            }
        }

        private void FullNameTextBox_TextChanged(object sender, EventArgs e)
        {
            userBtn.Enabled = fullNameTextBox.Text.Trim().Length > 2;
        }

        private void UserBtn_Click(object sender, EventArgs e)
        {
            if (fullNameTextBox.Enabled)
            {
                user = new User();
                user.FIO = fullNameTextBox.Text;
                user.Passport = psprtMaskedTextBox.Text;

                if (DialogResult.OK == MessageBox.Show($"New user will be created, please check if your personal data is correct: \n\nFull Name: {user.FIO} \nPassport: {user.Passport}",
                    "Creating a new user", MessageBoxButtons.OKCancel, MessageBoxIcon.Information))
                {
                    try
                    {
                        conn.Open();
                        NpgsqlCommand cmd = new NpgsqlCommand($"select add_passenger('{user.FIO}','{user.Passport}');", conn);
                        cmd.ExecuteNonQuery();

                        cmd.CommandText = $"select * from get_passenger('{user.Passport}');";
                        var dt = new DataTable();
                        dt.Load(cmd.ExecuteReader());

                        if (dt.Rows.Count != 0)
                        {
                            user.Id = (int)dt.Rows[0][0];
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message, "Database error");
                    }
                    finally
                    {
                        conn.Close();
                    }
                }
                else
                    return;
            }
            
            new UserForm(user, conn).Show();
            this.Hide();
        }

        private void Label4_Click(object sender, EventArgs e)
        {
            panel1.Visible = false;
            panel1.Enabled = false;

            panel2.Visible = true;
            panel2.Enabled = true;
            pswdTextBox.Focus();
            adminBtn.Select();
        }

        private void Label6_Click(object sender, EventArgs e)
        {
            panel2.Visible = false;
            panel2.Enabled = false;

            panel1.Visible = true;
            panel1.Enabled = true;
            psprtMaskedTextBox.Focus();
            userBtn.Select();
        }

        private void PswdTextBox_TextChanged(object sender, EventArgs e)
        {
            adminBtn.Enabled = pswdTextBox.Text.Length > 0;
        }

        private void AdminBtn_Click(object sender, EventArgs e)
        {
            NpgsqlConnection cn = new NpgsqlConnection
            {
                ConnectionString = $"Server=localhost; Port=5432; User Id=admin; Password={pswdTextBox.Text}; Database=airplanes"
            };
            try
            {
                cn.Open();
                cn.Close();
                new AdminForm(cn).Show();
                this.Hide();
            }
            catch
            {
                MessageBox.Show("Incorrect password", "Connection error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            { 
                cn.Close(); 
            }
        }
    }
}

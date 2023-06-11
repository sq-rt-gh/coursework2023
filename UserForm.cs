using Npgsql;
using System;
using System.Data;
using System.Text;
using System.Windows.Forms;

namespace ClientApp
{
    public partial class UserForm : Form
    {
        User user;
        NpgsqlConnection conn;

        public UserForm(User usr, NpgsqlConnection connection)
        {
            InitializeComponent();

            user = usr;
            conn = connection;
        }

        private void GroupBox1_SizeChanged(object sender, EventArgs e)
        {
            groupBox2.Left = groupBox1.Left + groupBox1.Width + 6;
        }

        private void UserForm_Load(object sender, EventArgs e)
        {
            labelName.Text = user.FIO;
            labelPassport.Text = user.Passport;
            RefreshDGVs();
        }

        private void RefreshDGVs()
        {
            RefreshToolStripMenuItem_Click(null, null);
            ButtonRefresh_Click(null, null);
        }

        private void UserForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

        private DataTable ExecuteQuery(string sql)
        {
            if (string.IsNullOrWhiteSpace(sql)) return null;

            try
            {
                conn.Open();
                NpgsqlCommand cmd = new NpgsqlCommand(sql, conn);
                
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                return dt;
            }
            catch(Exception ex) 
            {
                MessageBox.Show(ex.Message, "Database error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                conn.Close();
            }
            return null;
        }

        private int ExecuteNonQuery(string sql)
        {
            if (string.IsNullOrWhiteSpace(sql)) return -1;

            try
            {
                conn.Open();
                NpgsqlCommand cmd = new NpgsqlCommand(sql, conn);
                return cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Database error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                conn.Close();
            }
            return -1;
        }

        private void ButtonRefresh_Click(object sender, EventArgs e)
        {
            dgvProfile.DataSource = ExecuteQuery($"select * from get_tickets_exp({user.Id});");
            if (dgvProfile.ColumnCount > 0)
                dgvProfile.Columns[0].Visible = false; //hide the "id" column
        }

        private void RefreshToolStripMenuItem_Click(object sender, EventArgs e)
        {
            dgvMain.DataSource = ExecuteQuery("select * from get_flights_exp();");
            if (dgvMain.ColumnCount > 0) 
                dgvMain.Columns[0].Visible = false; //hide the "id" column

            toolStripTextBox1.Text = toolStripTextBox2.Text = "";
        }

        private void BuyTicketToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (dgvMain.SelectedCells.Count == 0)
                return;

            try
            {
                string info = "Do you wish to continue purchasing this ticket?\n";
                for (int i = 1; i < dgvMain.SelectedCells.Count; i++)
                {
                    info += $"\n{dgvMain.SelectedCells[i].OwningColumn.Name}: {dgvMain.SelectedCells[i].Value}";
                }

                if (DialogResult.Yes == MessageBox.Show(info, "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Question))
                {
                    int flightId = (int)dgvMain.SelectedCells[0].Value;
                    ExecuteNonQuery($"call buy_ticket({flightId}, {user.Id}, 'via app');");
                    RefreshDGVs();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error");
            }
        }

        private void ButtonRefund_Click(object sender, EventArgs e)
        {
            if (dgvProfile.SelectedCells.Count == 0)
                return;

            try
            {
                string info = "Do you wish to refund this ticket?\n";
                for (int i = 1; i < dgvProfile.SelectedCells.Count; i++)
                {
                    info += $"\n{dgvProfile.SelectedCells[i].OwningColumn.Name}: {dgvProfile.SelectedCells[i].Value}";
                }

                if (DialogResult.Yes == MessageBox.Show(info, "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Question))
                {
                    int Id = (int)dgvProfile.SelectedCells[0].Value;
                    ExecuteNonQuery($"select refund_ticket({Id});");
                    RefreshDGVs();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error");
            }
        }

        private void FilterDgvMain()
        {
            StringBuilder filter = new StringBuilder();

            if (!string.IsNullOrWhiteSpace(toolStripTextBox1.Text))
            {
                filter.Append($"[departure_city] LIKE '%{toolStripTextBox1.Text}%'");
            }

            if (!string.IsNullOrWhiteSpace(toolStripTextBox2.Text))
            {
                if (filter.Length != 0)
                {
                    filter.Append(" AND ");
                }
                filter.Append($"[arrival_city] LIKE '%{toolStripTextBox2.Text}%'");
            }
            
            (dgvMain.DataSource as DataTable).DefaultView.RowFilter = filter.ToString();
        }

        private void ToolStripTextBox_TextChanged(object sender, EventArgs e)
        {
            FilterDgvMain();
        }
        
    }
}

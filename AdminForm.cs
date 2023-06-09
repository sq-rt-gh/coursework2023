using Npgsql;
using System;
using System.Windows.Forms;

namespace ClientApp
{
    public partial class AdminForm : Form
    {
        NpgsqlConnection conn;

        string ActiveTable
        {
            get
            {
                return tablesToolStripComboBox1.SelectedItem.ToString()?.ToLower().Replace(' ', '_');
            }
        }


        public AdminForm(NpgsqlConnection cn)
        {
            InitializeComponent();
            conn = cn;
        }

        private void AdminForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

        private void AdminForm_Load(object sender, EventArgs e)
        {
            tablesToolStripComboBox1.SelectedItem = tablesToolStripComboBox1.Items[0];
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
            catch (Exception ex)
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

        private void TablesToolStripComboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            RefreshToolStripMenuItem_Click(null, null);

            updateToolStripMenuItem.Enabled = tablesToolStripComboBox1.SelectedIndex > 1;
            insertToolStripMenuItem.Enabled = tablesToolStripComboBox1.SelectedIndex != 0;
        }

        private void RefreshToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Cursor = Cursors.WaitCursor;
            dgv.DataSource = ExecuteQuery($"select * from get_{ActiveTable}();");
            Cursor = Cursors.Default;
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var form = new InsertForm(tablesToolStripComboBox1.SelectedIndex);
            
            if (form.ShowDialog() == DialogResult.OK)
            {
                ExecuteNonQuery(form.Sql);
                RefreshToolStripMenuItem_Click(null, null);
            }
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (dgv.SelectedCells.Count == 0)
                return;

            try
            {
                string info = "Do you wish to delete folowing row?\n";
                for (int i = 1; i < dgv.SelectedCells.Count; i++)
                {
                    info += $"\n{dgv.SelectedCells[i].OwningColumn.Name}: {dgv.SelectedCells[i].Value}";
                }

                if (DialogResult.Yes == MessageBox.Show(info, "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Question))
                {
                    int Id = (int)dgv.SelectedCells[0].Value;
                    string func;

                    if (tablesToolStripComboBox1.SelectedIndex == 2)
                        func = "del_passenger";
                    else if (tablesToolStripComboBox1.SelectedIndex == 3)
                        func = "del_flight";
                    else if (tablesToolStripComboBox1.SelectedIndex == 4)
                        func = "del_plane";
                    else
                        func = "refund_ticket";

                    ExecuteNonQuery($"select {func}({Id});");
                    RefreshToolStripMenuItem_Click(null, null);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error");
            }
        }

        private void UpdateToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var form = new UpdateForm(tablesToolStripComboBox1.SelectedIndex, dgv.SelectedRows?[0]);

            if (form.ShowDialog() == DialogResult.OK)
            {
                ExecuteNonQuery(form.Sql);
                RefreshToolStripMenuItem_Click(null, null);
            }
        }

    }
}

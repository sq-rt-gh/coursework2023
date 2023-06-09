using System;
using System.Windows.Forms;

namespace ClientApp
{
    public partial class UpdateForm : Form
    {
        public string Sql;

        string funcName;
        bool[] isString;

        public UpdateForm(int table, DataGridViewRow row)
        {
            InitializeComponent();

            for (int i = 0; i < row.DataGridView.Columns.Count; i++)
            {
                dgv.Columns.Add(row.DataGridView.Columns[i].Name, row.DataGridView.Columns[i].HeaderText);
            }

            dgv.Rows.Add();

            for (int i = 0; i < row.Cells.Count; i++)
            {
                dgv[i,0].Value = row.Cells[i].Value;
            }

            dgv.Columns[0].Visible = false;

            if (table == 2)
            {
                funcName = "upd_passenger";
                isString = new bool[] { false, true, true };
            }
            else if (table == 3)
            {
                funcName = "upd_flight";
                isString = new bool[] { false, true, true, true, true, false, false };
            }
            else if (table == 4)
            {
                funcName = "upd_plane";
                isString = new bool[] { false, true, false };
            }
            
        }

        private void OkButton_Click(object sender, EventArgs e)
        {
            string[] _args = new string[isString.Length];
            for (int i = 0; i < dgv.Columns.Count; i++)
            {

                if (isString[i])
                    _args[i] = "'" + dgv[i, 0].Value + "'";
                else
                    _args[i] = dgv[i, 0].Value.ToString();
            }

            Sql = "select " + funcName + "(" + string.Join(",", _args) + ");";

            DialogResult = DialogResult.OK;
            Close();
        }

        private void CancelButton_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }
    }
}

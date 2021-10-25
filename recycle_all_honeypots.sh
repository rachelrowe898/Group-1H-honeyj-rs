# Run script on restart using crontab

sudo bash recycle_honeypot.sh HRServeA 128.8.238.119 26 10000 /home/student/active_data_A >> /home/student/honeypot_logs/A_lifecycle.log
sudo bash recycle_honeypot.sh HRServeB 128.8.238.86 26 10001 /home/student/active_data_B >> /home/student/honeypot_logs/B_lifecycle.log
sudo bash recycle_honeypot.sh HRServeC 128.8.238.120 26 10002 /home/student/active_data_C >> /home/student/honeypot_logs/C_lifecycle.log
sudo bash recycle_honeypot.sh HRServeD 128.8.37.125 27 10003 /home/student/active_data_D >> /home/student/honeypot_logs/D_lifecycle.log

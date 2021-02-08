class UpdateBizdevReportJob < ApplicationJob
  include SuckerPunch::Job

  def perform
    week = "Week #{Date.today.strftime("%U").to_i}"
    OverviewUser.all.select{|x| x['Status'] == 'SEVEN'}.each do |user|
      # ownership_hours_total = Training.joins(:training_ownerships).where(training_ownerships: {user_type: 'Owner', user_id: user['Builder_id'].to_i}).select{|x| x.end_time.present? && x.end_time >= Date.today.beginning_of_year && x.end_time <= Date.today.end_of_year}.map{|x| x.hours}.sum.to_s
      # ownership_hours_ongoing = Training.joins(:training_ownerships).where(training_ownerships: {user_type: 'Owner', user_id: user['Builder_id'].to_i}).select{|x| x.end_time.present? && x.end_time >= Date::strptime(params[:date][:start_date],'%Y-%m-%d') && x.end_time <= Date::strptime(params[:date][:end_date],'%Y-%m-%d')}.map{|x| x.hours}.sum.to_s
      # ownership_hours_ongoing = OverviewTraining.all.select{|x| x['Owner'].present? && x['Owner'].join == user.id}.select{|x| x['Due Date'].present? && Date::strptime(x['Due Date'],'%Y-%m-%d') >= Date::strptime(params[:date][:start_date],'%Y-%m-%d') && Date::strptime(x['Due Date'],'%Y-%m-%d') <= Date::strptime(params[:date][:end_date],'%Y-%m-%d')}.map{|x| if x['Hours'].present?; x['Hours']; end}.sum.to_s
      ownership_hours_ongoing = OverviewTraining.all.select{|x| x['Owner'].present? && x['Owner'].join == user.id}.select{|x| x['Due Date'].present? && Date::strptime(x['Due Date'],'%Y-%m-%d') >= Date.today.beginning_of_week}.map{|x| if x['Hours'].present?; x['Hours']; end}.sum.to_s
      project_hours_dev = OverviewProject.all.select{|x| x['Developer'].present? && x['Developer'].join == user.id}.map{|z| z['Hours'].to_i}.sum.to_s
      project_hours_codev = OverviewProject.all.select{|x| x['Co-developer'].present? && x['Co-developer'].join == user.id}.map{|z| z['Hours'].to_i}.sum.to_s
      training_hours = User.find(user['Builder_id']).hours_this_week(Date.today).to_s
      projects_1 = OverviewProject.all.select{|x| x['Developer'].present? && x['Developer'].join == user.id && x['Lead Qualification Level'] == '1 - Prospect(s) : person or/and company'}.count.to_s
      projects_2 = OverviewProject.all.select{|x| x['Developer'].present? && x['Developer'].join == user.id && x['Lead Qualification Level'] == '2 - Identified contact lead'}.count.to_s
      projects_3 = OverviewProject.all.select{|x| x['Developer'].present? && x['Developer'].join == user.id && x['Lead Qualification Level'] == '3 - Handshaked contact lead'}.count.to_s
      projects_4 = OverviewProject.all.select{|x| x['Developer'].present? && x['Developer'].join == user.id && x['Lead Qualification Level'] == '4 - Strong relationship lead'}.count.to_s
      projects_5 = OverviewProject.all.select{|x| x['Developer'].present? && x['Developer'].join == user.id && x['Lead Qualification Level'] == '5 - Needs identified lead'}.count.to_s
      projects_6 = OverviewProject.all.select{|x| x['Developer'].present? && x['Developer'].join == user.id && x['Lead Qualification Level'] == '6 - Pre-Signed lead'}.count.to_s
      projects_7 = OverviewProject.all.select{|x| x['Developer'].present? && x['Developer'].join == user.id && x['Lead Qualification Level'] == '7 - Signed lead'}.count.to_s
      memo_count = 0.0
      memos_this_week = OverviewMemo.all.select{|x| x['Users'].present? && x['Users'].include?(user.id) && Date::strptime(x['Date'], "%Y-%m-%d") >= Date.today}.each do |memo|
        memo_count += (1.0 / memo['Users'].count)
      end
      data_hash = {Ongoing_Ownership:  ownership_hours_ongoing, Project_Hours_Dev: project_hours_dev, Project_Hours_Codev: project_hours_codev, '1 - Prospect' => projects_1, '2 - Identified contact' => projects_2, '3 - Handshaked contact' => projects_3, '4  - Strong relationship' => projects_4, '5 - Needs identified' => projects_5, '6 - Pre-signed' => projects_6, '7 - Signed' => projects_7, Weekly_Memos: memo_count.to_s, Trained_Hours: training_hours}
      data_hash.each do |key, value|
        line = OverviewBizdev.all.select{|x| x['User'] == user['Name'] && x['Data'] == key.to_s}.first
        if !line.present?
          line = OverviewBizdev.create('User' => user['Name'], 'Data' => key, week => value)
        else
          line[week] = value
        end
        line.save
      end
    end
  end
end

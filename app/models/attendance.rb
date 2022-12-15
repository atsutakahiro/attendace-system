class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_edit_at_is_invalid_without_a_started_edit_at
  
  validate :started_edit_at_is_invalid_without_a_finished_edit_at
  

  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_edit_at_than_finished_edit_at_fast_if_invalid

  def finished_edit_at_is_invalid_without_a_started_edit_at
    errors.add(:started_at, "が必要です") if (started_edit_at.present? && finished_edit_at.present?)
  end
  
  def started_edit_at_is_invalid_without_a_finished_edit_at
    if (worked_on < Date.current) && (started_edit_at.present? && finished_edit_at.blank?)
      errors.add(:finished_at, "が必要です") 
    end 
  end
    
  
  
  
  

  def started_edit_at_than_finished_edit_at_fast_if_invalid
    if started_edit_at.present? && finished_edit_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_edit_at > finished_edit_at
    end
  end
end


  
  
  
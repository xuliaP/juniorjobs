# frozen_string_literal: true

# TODO: documentation is missing for this class
# We should consider addig some documentation here
class AdminJobMailer < ApplicationMailer
  default from: Settings.email_from

  def edit_job_email(id)
    @job = Job.find(id)
    @user = @job.user
    mail(to: Settings.admin_email, subject: t('common.jobs.create.job_was_created_and_needs_to_review')) do |format|
      format.text
      format.html
    end
  end
end

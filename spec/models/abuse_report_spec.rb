require 'spec_helper'

describe AbuseReport do
  it "has a visible scope" do
    @report = Factory(:abuse_report)
    @report.bid.update_attribute :expires_at, 2.days.ago
    AbuseReport.visible.should_not include(@report)
    @report.bid.update_attribute :expires_at, 2.days.from_now
    AbuseReport.visible.should include(@report)
    @report.bid.update_attribute :disabled, true
    AbuseReport.visible.should_not include(@report)
  end
end

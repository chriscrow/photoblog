require 'spec_helper'

describe ApplicationHelper do
  
  describe "full_title" do
    it "should include the page title" do
      expect(full_title("foo")).to match(/^foo/)
    end
    
    it "should include base title" do
      expect(full_title("foo")).to match(/玉衡的站点/)
    end
    
    it "should not include a bar for home" do
      expect(full_title("")).not_to match(/\|/)
    end
  end
end
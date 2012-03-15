require 'spec_helper'

describe Character do 
  
  before(:each) do
    @character = Character.new
    @defender = Character.new
  end
  
  it "should respond to get and set name" do
    @character.name = "bob"
    @character.name.should == "bob"
  end
  
  it "should respond to get and set alignment" do
    @character.alignment = :good
    @character.alignment.should == :good
  end
  
  it "should force alignment to be good, evil, or neutral" do
    expect { @character.alignment = :super_bad }.to raise_error("you are not allowed to be bad")
  end
  
  it "should respond to get armor and default to 10" do
    @character.armor.should == 10
  end
  
  it 'should respond to get hit_points and default to 10 ' do
    @character.hit_points.should == 5
  end
  
  it "should be able to attack with roll greater than 10" do
    roll = 15
    @character.attack(@defender, roll).should == 1
  end
  
  it "should not be albe to attack with roll less than 10" do
    roll = 9
    @character.attack(@defender, roll).should == 0
  end
  
  it "should decrement hit points on successful hit" do
    roll = 11
    damage = @character.attack(@defender, roll)
    @defender.apply_damage(damage)
    @defender.hit_points.should == 4
  end

  it "should decrement hit points by 2 on a perfect roll" do
    roll = 20 # perfect roll!
    damage = @character.attack(@defender, roll)
    @defender.apply_damage(damage)
    @defender.hit_points.should == 3
  end
  
  it "should die if hit points are 0" do
    @defender.apply_damage(5)
    @character.alive?
  end

  it "should have said abilities and default to 10" do
    [:strength, :dexterity, :constitution, :widsom, :intelligence, :charisma].each do |a|
      @character.attributes[a].score.should == 10
    end
  end
  
  it "should not have attributes that exceed a score of 20" do
    expect { @character.attributes[:strength] += 30 }.to raise_error("cannot have attribute with score not between 1 and 20")
  end
  
  it "should not have attributes that have a score of less than 1" do
    expect { @character.attributes[:strength] -= 30 }.to raise_error("cannot have attribute with score not between 1 and 20")
  end
  
  it "should set the score value to the decremented value from the default" do
    @character.attributes[:intelligence] -= 3 
    @character.attributes[:intelligence].score.should == 7
  end

  it "should set the score value to the incremented value from the default" do
    @character.attributes[:intelligence] += 3 
    @character.attributes[:intelligence].score.should == 13
  end

  it "should return modifier values when querying for any character attribute" do
    @character.attributes[:intelligence] -= 3 # attribute value of 7, for example, should return a modifier of -2
    @character.attributes[:intelligence].modifier.should == -2 
  end

  it "should change attach roll and damage dealt based on strength" do
    roll = 8
    @character.attributes[:strength].score = 14
    damage = @character.attack(@defender, roll)
    damage.should == 3
  end  

  it "should double strength modifier on crit" do
    roll = 20
    @character.attributes[:strength].score = 14
    damage = @character.attack(@defender, roll)
    damage.should == 6
  end
  
  it "should if hit, should never receive damage less than 1" do
    roll = 16
    @character.attributes[:strength].score = 1 # strength of 1 has a modifier or -5!
    damage = @character.attack(@defender, roll)
    damage.should == 1
  end
  
  it "should modify armor based on dexterity modifier" do
    @character.attributes[:dexterity].score = 14
    @character.armor.should == 12
  end

  it "should modify hit points based on constitution modifier" do
    @character.attributes[:constitution].score = 14
    @character.hit_points.should == 7
  end

  it "should modify hit points based on constitution modifier but never make the hit points less than 1" do
    @character.attributes[:constitution].score = 1
    @character.hit_points.should == 1
  end
  
  it "should modify experience points if i hit my opponent" do
   roll = 20
   experience = @character.xp
   @character.attack(@defender, roll)  
   @character.xp.should == experience + 10
  end
  
  it "should level defaut to 1" do
    @character.level.should == 1
  end
  
  it "should be at level 1 with >= 1000 experience points" do
    100.times do
      roll = 20
      @character.attack(@defender, roll)
    end
    @character.level.should == 2
  end
  
  it "should be at level 3 with >= 2000 experience points" do
    200.times do
      roll = 20
      @character.attack(@defender, roll)
    end
    @character.level.should == 3
  end

  it "should have hit points equal to n if constitution == 14" do
    @character.attributes[:constitution].score = 14
    100.times do
      roll = 20
      @character.attack(@defender, roll)
    end
    @character.hit_points.should == 14
  end
  
  it "should have 1 added to his attack roll for every level achieved" do
    100.times do
      roll = 20
      @character.attack(@defender, roll)
    end
    roll = 9
    damage = @character.attack(@defender, roll)
    damage.should > 0
  end
  

end
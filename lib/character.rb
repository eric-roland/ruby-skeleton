class Character
  
  VALID_ALIGNMENTS = [:good, :neutral, :evil]
  DEFAULT_ATTRIBUTE_SCORES = 10
  ATTRIBUTES = [:strength, :dexterity, :constitution, :widsom, :intelligence, :charisma]
  
  attr_accessor :name
  attr_reader :alignment, :attributes, :xp
  
  def initialize
    @armor = 10
    @hit_points = 5
    @attributes = {}
    @xp = 0
    @level = 1
    ATTRIBUTES.each {|a| @attributes[a] = Attribute.new(DEFAULT_ATTRIBUTE_SCORES) }
  end
    
  def alignment=(alignment_val)
    raise "you are not allowed to be bad" unless VALID_ALIGNMENTS.include?(alignment_val)
    @alignment = alignment_val
  end
  
  def level
    @level
  end
  
  def armor
    @armor += @attributes[:dexterity].modifier
  end
  
  def hit_points
    temp_hit_points =  @hit_points + @attributes[:constitution].modifier
    (temp_hit_points > 0) ? temp_hit_points : 1
  end
  
  def attack(defender, roll)
    roll += @attributes[:strength].modifier
    roll += @level / 2
    roll = 20 if roll > 20
    damage = 0
    if roll >= defender.armor
      damage += 1 + @attributes[:strength].modifier
      damage = damage * 2 if roll == 20
      damage = 1 if damage <= 0
      @xp += 10
      level_up if @level < (@xp / 1000 + 1)
    end
    damage
  end
  
  def level_up
    @level += 1
    @hit_points += 5 + @attributes[:constitution].modifier
  end
  
  def apply_damage(damage)
    @hit_points -= damage
  end
  
  def alive?
    @hit_points >= 0 
  end
    
end

class Attribute
  
  MAX_SCORE = 20
  MIN_SCORE = 1
  SCORE_MODIFIER = [-5, -4, -4, -3, -3, -2, -2, -1, -1, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5]
  
  attr_accessor :score
  
  def initialize(score)
    @score = score
  end
  
  def -(val)
    valid_score?(@score - val)
  end
  
  def +(val)
    valid_score?(val + @score)
  end
  
  def modifier
    SCORE_MODIFIER[@score - 1]
  end
  
  def valid_score?(new_score)
    if new_score.between?(MIN_SCORE, MAX_SCORE)
      Attribute.new(new_score)
    else
      raise "cannot have attribute with score not between 1 and 20"
    end
  end
end
require 'test/unit'
require 'rubygems'
require 'fakeweb'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'woot'

class Test::Unit::TestCase
  
  def self.possible_blank_attributes
    @possible_blank_attributes ||= [:purchase_url]
  end
  
  def self.fixtures
    @fixtures ||= Dir[File.join(File.dirname(__FILE__), 'fixtures', '*.html')].inject({}) { |hash, file| hash.merge! File.basename(file).gsub(/\.html$/, '') => file }
  end
  
  def self.register_fakeweb_uris
    fixtures.each { |subdomain, file| FakeWeb.register_uri(:get, "http://#{subdomain}.#{Woot::DOMAIN}/", :body => File.read(file)) }
  end
  
  def self.woots
    @woots ||= (Woot::SUBDOMAINS + fixtures.keys).inject({}) { |hash, subdomain| hash.merge! subdomain => Woot.new(subdomain) }
  end
  
  register_fakeweb_uris
  
end

class MockTwitterStatus
  
  attr_reader :id, :text
  
  def initialize(id, text = '')
    @id = id
    @text = text
  end
  
  def user
    self
  end
  
end

WOOT_FIXTURE_VALUES = {
  'available' => {
    :subdomain       => 'available',
    :title           => 'Blockade Noise Isolating Earbuds - 2 Pack',
    :price           => '14.99',
    :currency        => 'USD',
    :currency_symbol => '$',
    :shipping        => "+ $5 shipping",
    :image           => 'http://sale.images.woot.com/Blockade_Noise_Isolating_EarbudsmqlStandard.jpg',
    :alternate_image => 'http://sale.images.woot.com/Blockade_Noise_Isolating_Earbudsqx4Detail.jpg',
    :url             => 'http://www.woot.com/sale/10457',
    :comments_url    => 'http://www.woot.com/Forums/ViewPost.aspx?PostID=3554500',
    :comments_count  => '71',
    :header          => 'I think the little hairy guy with the claws is popping my bike tires on purpose',
    :subheader       => 'Head down, earbuds in, try not to get hit by a laser',
    :writeup         => "My mother-in-law thought we were crazy. \342\200\234You two are going to end up pulverized by a giant world-eating alien just like your Aunt Regina!\342\200\235 We\342\200\231ve always wanted to live in Metro City, though, and when Jessica got that job offer at the Major Daily Newspaper, we were excited to move to where all the costumed action is.\nFor about the first three weeks, anyway.\nWhen the errant meteorite hit the Volvo, we shrugged it off and started using public transportation. Then, our dog Scamp was eaten by the Crimson Cowl\342\200\231s cyborg velociraptors. And around the fourth time some villain\342\200\231s robot henchman gets plowed through your wall and into your living room without so much as a \342\200\234Sorry, Citizens\342\200\235 from whatever hero happens to be on duty that day, you start to get a little annoyed.\nI\342\200\231m not complaining, really. That\342\200\231s what cape insurance is for, after all. That\342\200\231s the price you pay for living in the superhero capital of the world, I guess. You either pack your things and move to Wyoming, or you learn to adapt. It just takes a little adjusting.\nSo on the nights when the sky burns red with crisis or some silver-plated intergalactic herald is preaching doom and gloom all over the city, my wife and I plug the Blockade Noise Isolating Earbuds into our MP3 players. The triple flange design provides optimal noise protection from all the laser blasts and explosions that flood the city soundscape, allowing us to concentrate on the music or audiobook we\342\200\231re listening to. When I need to take a trip down to the corner market and have to jump out of the way of an automobile being thrown by some hulking gamma-irradiated scientist, the comfortable fit of these earbuds means the music stays in my ears. The integrated volume control in the cord is great for when I want to drown out any superhero bellowing witty banter, too.\nIf anyone knows a good way of keeping some of these heroes from perching on the gargoyle outside our bedroom window at night, though, I\342\200\231d love to hear it. I know they\342\200\231re just doing their inner-monologue thing, but it gets kinda creepy.",
    :specs           => "Warranty: 90 Day Woot Limited Warranty \nFeatures:\nPatented triple-flange ear bud design provides optimal noise protection for an excellent fit that radically reduces noise\n    Integrated volume control places fingertip adjustment of any iPod or MP3 player easily within reach\n    24 decibel Noise Reduction Rating brings an end to dangerously over-cranked tunes struggling to compete with loud external sounds\n    Use in the yard while mowing and gardening, in the workshop, on the job, in the gym or traveling on a plane to safely isolate background noise\n    Ultra comfortable design from the same company who brought you the industry leading WorkTunes\n    iPod and MP3 compatible (any device with a 3.5mm plug)\n    Meets ANSI/OSHA Standards\nAdditional Photos:\nBlockade Noise Isolating Earbuds\n    Volume Control\n    Triple-flange ear bud design\nIn the box:\n2 AO Safety 99014 Blockade Noise Isolating Earbuds\n    6 Extra Pairs of Ear Tips\n    2 Carrying Bags",
    :details         => "Condition:\n            New\n            Product:\n            \n\t\t\t\t\t\n\t\t\t\t\t    2 AO Safety 99014 Blockade Noise Isolating Earbuds",
    :purchase_url    => 'http://available.woot.com/WantOne.aspx?id=983db0c6-5c69-4737-926b-3697d4af542e'
  },
  'soldout' => {
    :subdomain       => 'soldout',
    :title           => 'iRobot Roomba 530 Robotic Vacuum with Virtual Wall',
    :price           => '129.99',
    :currency        => 'USD',
    :currency_symbol => '$',
    :shipping        => "+ $5 shipping",
    :image           => 'http://sale.images.woot.com/iRobot_Roomba_530_Robotic_Vacuum_with_Virtual_WalluquStandard.jpg',
    :alternate_image => 'http://sale.images.woot.com/iRobot_Roomba_530_Robotic_Vacuum_with_Virtual_WallyxlDetail.jpg',
    :url             => 'http://www.woot.com/sale/10244',
    :comments_url    => 'http://www.woot.com/Forums/ViewPost.aspx?PostID=3553042',
    :comments_count  => '209',
    :header          => 'Looking For Mr. Roombar',
    :subheader       => "This is nice, isn\342\200\231t it? I have to say, I was surprised when you called me. Most people who date robots prefer the kind that, you know, look like people.",
    :writeup         => "I just keep thinking about all those times you came over to play cards with Len and Sherry. Of course I noticed you, but I never imagined you noticed me, way down on the floor in my self-charging home base. Well, there was this one time when I heard you ask Sherry about me. It made my heart leap. But then Sherry just started talking about how convenient I was, and how my counter-rotating Bristle Brush and Beater Brush work together like a broom and dustpan to lift hair, dust, and debris out of carpet. I just assumed you were interested in my cleaning abilities, not me personally. Glad I was wrong!\nWow, everything on the menu looks so good. I\342\200\231d heard about this place, but it\342\200\231s even nicer than I imagined. Well, except for the floors. It\342\200\231s like they think they can slap down a brown carpet and forget about ever vacuuming again. Well, they can\342\200\231t fool me and my Dirt Detect capability. Like that smear of, like, dried holladaise sauce or whatever it is, over by that booth. See, if it was up to me, I\342\200\231d really bear down with my Spot Clean mode, and I\342\200\231d have that crud lifted up before you could say \342\200\234new, improved filter\342\200\235. See, that\342\200\231s the difference between me and a regular old-\nListen to me. Talking shop in the middle of a lovely first date. Sorry. I just don\342\200\231t get out much.\nSo, uh, have you seen any interesting movies lately? I haven\342\200\231t. I\342\200\231ve actually never seen a movie in a theater. Every time I try, I see all that popcorn and all those crumbs all over the floor, and I just can\342\200\231t resist getting down there and sweeping it all up. Well, you can imagine the noise. I\342\200\231m loud, I know. What can I say? I grew up in a loud family. You get us together, it\342\200\231s VRRRR-VRRRR-VRRRR the whole time.\nWhat? Go back to your place? Sure. Yeah, that would be fun. I\342\200\231m not that hungry anyway. Um, yes, I did bring my Virtual Wall. Yeah, I emptied my Debris Bin right before you picked me up. Why do you ask?\nOh. Oh, I see. So it\342\200\231s like that. I guess I should\342\200\231ve known.",
    :specs           => "Authorized for SquareTrade Extended Warranty$(document).ready(function() {st_widget.create({itemCondition:'Refurbished',itemDescription:'iRobot Roomba 530 Robotic Vacuum with Virtual Wall',itemPrice:'129.99',bannerStyle:'wide',widgetType:'quote',merchantID:'subscrip_014793207843'}); });Warranty: 90 Day iRobot\nFeatures:\nEfficiently vacuums dirt, debris, pet hair, dust, allergens and more from carpets and hard floors\n    Counter rotating Bristle Brush and Beater Brush work together like a dustpan and broom\n    Sturdy Bristle Brush digs deep into carpet fibers to grab dirt, debris, pet hair and more\n    Powerful vacuum sucks large and small debris into the large, bag-less bin\n    Fine filter traps dust, pollen and tiny particulate inside the bin\n    Cleans the whole floor, under and around furniture, into corners and along wall edges\n    Detects dirtier areas and spends more time cleaning them\n    Spot Clean provides quick clean-up of spills and concentrated messes\n    Automatically senses and avoids stairs and other drop-offs\n    Simple operation\342\200\224just press the Clean button and Roomba does the rest\n    Automatically returns to its self-charging Home Base\302\256 to dock and recharge between cleanings\n    Faster counter-rotating brushes with improved design pick up more hair and debris and are easier to remove and clean\n    Improved filter captures more dust and allergens while a larger bin holds more debris\n    Improved anti-tangle technology keeps Roomba from getting stuck on cords, carpet fringe and tassels\n    Improved sidebrush makes Roomba even more efficient at cleaning edges and corners\nAdditional Photo:\nUnderbelly\n    In Home Base with Virtual Wall\n    Virtual Wall\nIn the box:\n1 iRobot Roomba 530\n    1 Virtual Wall\302\240\n    1 Self-charging Home Base\n    1 Power Supply (3 hour charge time)\n    1 Rechargeable Battery\n    1 Filter \n\302\240",
    :details         => "Condition:\n            Refurbished\n            Product:\n            \n\t\t\t\t\t\n\t\t\t\t\t    1 iRobot Roomba 530 Robotic Vacuum with Virtual Wall and Self-Charging Home Base",
    :purchase_url    => nil
  }
}